view: product_affinity_graph {
  derived_table: {
    sql:
      SELECT
        p1_id AS source_product_id,
        p1_name AS source_product_name,
        p1_category AS source_category,
        p1_brand AS source_brand,
        p2_id AS recommended_product_id,
        p2_name AS recommended_product_name,
        p2_category AS recommended_category,
        p2_brand AS recommended_brand,
        user_id,
        order_item_id_1,
        order_item_id_2
      FROM GRAPH_TABLE(
        `sampitcher-playground.the_look.thelook_graph`
        MATCH (p1:products)<-[:order_to_product]-(o1:order_items)-[:order_to_user]->(u:users)<-[:order_to_user]-(o2:order_items)-[:order_to_product]->(p2:products)
        WHERE p1.id != p2.id
        COLUMNS (
          p1.id AS p1_id,
          p1.name AS p1_name,
          p1.category AS p1_category,
          p1.brand AS p1_brand,
          p2.id AS p2_id,
          p2.name AS p2_name,
          p2.category AS p2_category,
          p2.brand AS p2_brand,
          u.id AS user_id,
          o1.id AS order_item_id_1,
          o2.id AS order_item_id_2
        )
      )
    ;;
  }

  dimension: hop_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.order_item_id_1 AS STRING), '-', CAST(${TABLE}.order_item_id_2 AS STRING)) ;;
  }

  # --- Source Product (Anchor) ---
  dimension: source_product_id {
    type: number
    sql: ${TABLE}.source_product_id ;;
  }

  dimension: source_product_name {
    type: string
    sql: ${TABLE}.source_product_name ;;
  }

  dimension: source_category {
    type: string
    sql: ${TABLE}.source_category ;;
  }

  dimension: source_brand {
    type: string
    sql: ${TABLE}.source_brand ;;
  }

  # --- Recommended Product (Traversed Target) ---
  dimension: recommended_product_id {
    type: number
    sql: ${TABLE}.recommended_product_id ;;
  }

  dimension: recommended_product_name {
    type: string
    sql: ${TABLE}.recommended_product_name ;;
  }

  dimension: recommended_category {
    type: string
    sql: ${TABLE}.recommended_category ;;
  }

  dimension: recommended_brand {
    type: string
    sql: ${TABLE}.recommended_brand ;;
  }

  # --- Measures ---
  measure: shared_customers {
    type: count_distinct
    sql: ${TABLE}.user_id ;;
    description: "Distinct customers who purchased both the source and recommended products across graph hops"
  }

  measure: co_purchase_count {
    type: count
    description: "Total number of traversed purchase paths connecting both items"
  }
}
