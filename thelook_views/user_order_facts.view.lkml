view: user_order_facts {
  derived_table: {
    # ANTI-PATTERN: ORDER BY in derived table subquery + non-persisted full table scan
    sql: SELECT 
           user_id,
           COUNT(*) as lifetime_orders,
           SUM(sale_price) as lifetime_revenue,
           AVG(sale_price) as avg_order_value,
           STRING_AGG(DISTINCT status, ", ") as order_statuses
         FROM `sampitcher-playground.the_look_ca.order_items_table`
         GROUP BY 1
         ORDER BY lifetime_revenue DESC ;;
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  # ANTI-PATTERN: Measure defined on raw string dimension aggregation
  dimension: lifetime_revenue_dim {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  measure: total_lifetime_revenue {
    type: sum
    sql: ${lifetime_revenue_dim} ;;
  }
}
