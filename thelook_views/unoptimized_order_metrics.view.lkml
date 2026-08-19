view: unoptimized_order_metrics {
  derived_table: {
    # TOXIC ANTI-PATTERN 1: Correlated subqueries scanning entire unpartitioned event table per order row
    # TOXIC ANTI-PATTERN 2: Distributed ORDER BY forcing full shuffle sort in subquery
    sql: SELECT 
           oi.id as order_item_id,
           oi.user_id,
           oi.order_id,
           oi.sale_price,
           (
             SELECT COUNT(*) 
             FROM `sampitcher-playground.the_look_ca.events_table` e 
             WHERE e.user_id = oi.user_id 
               AND e.created_at <= oi.created_at
           ) as touches_prior_to_order,
           (
             SELECT STRING_AGG(DISTINCT browser, " -> ") 
             FROM `sampitcher-playground.the_look_ca.events_table` e2 
             WHERE e2.user_id = oi.user_id
           ) as full_user_browser_trail,
           AVG(oi.sale_price) OVER(PARTITION BY oi.user_id) as user_lifetime_avg_price,
           DENSE_RANK() OVER(PARTITION BY oi.user_id ORDER BY oi.created_at DESC) as order_recency_rank
         FROM `sampitcher-playground.the_look_ca.order_items_table` oi
         ORDER BY touches_prior_to_order DESC, order_item_id ASC ;;
  }

  dimension: order_item_id {
    type: number
    sql: ${TABLE}.order_item_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: touches_prior_to_order {
    type: number
    sql: ${TABLE}.touches_prior_to_order ;;
  }

  dimension: full_user_browser_trail {
    type: string
    sql: ${TABLE}.full_user_browser_trail ;;
  }

  dimension: user_lifetime_avg_price {
    type: number
    sql: ${TABLE}.user_lifetime_avg_price ;;
  }

  # TOXIC ANTI-PATTERN 3: Measure doing SUM on a non-aggregated window metric (Symmetric Aggregate collision)
  measure: total_unweighted_user_avg {
    type: sum
    sql: ${user_lifetime_avg_price} ;;
  }
}
