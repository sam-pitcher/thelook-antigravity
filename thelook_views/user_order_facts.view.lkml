view: user_order_facts {
  derived_table: {
    sql: SELECT 
           user_id,
           COUNT(*) as lifetime_orders,
           SUM(sale_price) as lifetime_revenue,
           AVG(sale_price) as avg_order_value,
           STRING_AGG(DISTINCT status, ", ") as order_statuses
         FROM `sampitcher-playground.the_look_ca.order_items_table`
         GROUP BY 1 ;;
    datagroup_trigger: thelook_default_datagroup
    cluster_keys: ["user_id"]
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
    value_format_name: usd
  }

  dimension: avg_order_value {
    type: number
    sql: ${TABLE}.avg_order_value ;;
    value_format_name: usd
  }

  dimension: order_statuses {
    type: string
    sql: ${TABLE}.order_statuses ;;
  }

  measure: total_lifetime_revenue {
    type: sum
    sql: ${lifetime_revenue} ;;
    value_format_name: usd
  }

  measure: average_lifetime_revenue {
    type: average
    sql: ${lifetime_revenue} ;;
    value_format_name: usd
  }

  measure: count {
    type: count
  }
}
