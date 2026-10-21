view: graph_network_analytics {
  derived_table: {
    sql:
      SELECT
        g.p1_id AS anchor_product_id,
        g.p2_id AS recommended_product_id,
        g.u_id AS connecting_user_id,
        g.o1_id AS anchor_order_item_id,
        g.o2_id AS recommended_order_item_id,
        g.p2_price AS recommended_retail_price,
        u_stats.user_items_count
      FROM (
        SELECT * FROM GRAPH_TABLE(
          `sampitcher-playground.the_look.thelook_graph`
          MATCH (p1:products)<-[:order_to_product]-(o1:order_items)-[:order_to_user]->(u:users)
                             <-[:order_to_user]-(o2:order_items)-[:order_to_product]->(p2:products)
          WHERE p1.id != p2.id
            {% if graph_network_analytics.anchor_category_filter._is_filtered %}
              AND {% condition graph_network_analytics.anchor_category_filter %} p1.category {% endcondition %}
            {% endif %}
            {% if graph_network_analytics.anchor_brand_filter._is_filtered %}
              AND {% condition graph_network_analytics.anchor_brand_filter %} p1.brand {% endcondition %}
            {% endif %}
          COLUMNS (
            p1.id AS p1_id,
            p1.category AS p1_category,
            p1.brand AS p1_brand,
            p2.id AS p2_id,
            p2.retail_price AS p2_price,
            u.id AS u_id,
            o1.id AS o1_id,
            o2.id AS o2_id
          )
        )
      ) g
      JOIN (
        SELECT user_id, COUNT(id) as user_items_count
        FROM `sampitcher-playground.the_look.order_items`
        GROUP BY user_id
      ) u_stats ON g.u_id = u_stats.user_id
      WHERE 1=1
        {% if graph_network_analytics.min_customer_purchases._parameter_value == '5' %}
          AND u_stats.user_items_count > 5
        {% elsif graph_network_analytics.min_customer_purchases._parameter_value == '3' %}
          AND u_stats.user_items_count >= 3
        {% elsif graph_network_analytics.min_customer_purchases._parameter_value == '10' %}
          AND u_stats.user_items_count >= 10
        {% endif %}
    ;;
  }

  # --- Primary Key ---
  dimension: hop_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.anchor_order_item_id AS STRING), '-', CAST(${TABLE}.recommended_order_item_id AS STRING)) ;;
  }

  # --- Foreign Keys for Role-Playing Joins ---
  dimension: anchor_product_id {
    type: number
    sql: ${TABLE}.anchor_product_id ;;
    hidden: yes
  }

  dimension: recommended_product_id {
    type: number
    sql: ${TABLE}.recommended_product_id ;;
    hidden: yes
  }

  dimension: connecting_user_id {
    type: number
    sql: ${TABLE}.connecting_user_id ;;
    hidden: yes
  }

  # --- Graph Dynamic Parameters & Filters ---
  parameter: min_customer_purchases {
    type: unquoted
    label: "Customer Purchase Frequency Filter"
    description: "Filter graph traversal by the purchase volume of the connecting customer"
    allowed_value: { label: "All Customers (1+ items)" value: "1" }
    allowed_value: { label: "Frequent Customers (3+ items)" value: "3" }
    allowed_value: { label: "VIP Cohort (> 5 items)" value: "5" }
    allowed_value: { label: "Super VIP Cohort (10+ items)" value: "10" }
    default_value: "1"
  }

  filter: anchor_category_filter {
    type: string
    suggest_dimension: anchor_product.category
    label: "Filter: Anchor Category"
    description: "Push category filter directly into BigQuery graph execution for early pruning"
  }

  filter: anchor_brand_filter {
    type: string
    suggest_dimension: anchor_product.brand
    label: "Filter: Anchor Brand"
    description: "Push brand filter directly into BigQuery graph execution for early pruning"
  }

  # --- Graph Bridge Dimensions ---
  dimension: user_total_purchased_items {
    type: number
    sql: ${TABLE}.user_items_count ;;
    label: "Bridge: Customer Lifetime Items"
  }

  dimension: customer_purchasing_tier {
    type: string
    label: "Bridge: Customer Purchasing Tier"
    sql: CASE 
          WHEN ${TABLE}.user_items_count > 5 THEN 'VIP (> 5 Purchases)'
          WHEN ${TABLE}.user_items_count >= 3 THEN 'Frequent (3-5 Purchases)'
          ELSE 'Standard (1-2 Purchases)'
         END ;;
  }

  dimension: recommended_retail_price {
    type: number
    sql: ${TABLE}.recommended_retail_price ;;
    value_format_name: usd
    label: "Target: Recommended Item Price"
  }

  # --- Adaptable Measures ---
  measure: shared_customer_count {
    type: count_distinct
    sql: ${TABLE}.connecting_user_id ;;
    label: "Shared Customers"
    description: "Unique customers who co-purchased both the anchor and recommended product"
    drill_fields: [connecting_customer.id, connecting_customer.full_name, connecting_customer.state, connecting_customer.country]
  }

  measure: co_purchase_instances {
    type: count
    label: "Total Co-Purchase Paths"
    description: "Total number of traversed order paths connecting both items"
  }

  measure: potential_cross_sell_revenue {
    type: sum
    sql: ${recommended_retail_price} ;;
    value_format_name: usd
    label: "Potential Cross-Sell Value"
    description: "Sum of recommended product retail values across all co-purchase occurrences"
  }

  measure: average_cross_sell_price {
    type: average
    sql: ${recommended_retail_price} ;;
    value_format_name: usd
    label: "Avg Recommended Item Price"
  }

  measure: affinity_strength_index {
    type: number
    sql: ROUND(100.0 * ${shared_customer_count} / NULLIF(${co_purchase_instances}, 0), 1) ;;
    label: "Affinity Concentration Index (%)"
    description: "Percentage of co-purchases driven by unique customers vs repeat loops"
  }
}
