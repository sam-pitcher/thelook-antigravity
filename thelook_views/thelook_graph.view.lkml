view: thelook_graph {
  sql_analytic_model_name: sampitcher-playground.the_look.thelook_graph ;;

  dimension: order_item_id {
    primary_key: yes
    type: number
    sql: order_items_id ;;
  }

  dimension: order_id {
    type: number
    sql: order_items_order_id ;;
  }

  dimension: order_status {
    type: string
    sql: order_items_status ;;
  }

  # --- Customer Node Properties ---
  dimension: user_id {
    type: number
    sql: users_id ;;
  }

  dimension: user_first_name {
    type: string
    sql: users_first_name ;;
  }

  dimension: user_last_name {
    type: string
    sql: users_last_name ;;
  }

  dimension: user_state {
    type: string
    sql: users_state ;;
  }

  dimension: user_country {
    type: string
    sql: users_country ;;
  }

  dimension: user_traffic_source {
    type: string
    sql: users_traffic_source ;;
  }

  # --- Product Node Properties ---
  dimension: product_id {
    type: number
    sql: products_id ;;
  }

  dimension: product_name {
    type: string
    sql: products_name ;;
  }

  dimension: product_category {
    type: string
    sql: products_category ;;
  }

  dimension: product_brand {
    type: string
    sql: products_brand ;;
  }

  dimension: product_department {
    type: string
    sql: products_department ;;
  }

  # --- Predefined BigQuery Graph Base Measures ---
  measure: total_sales {
    type: number
    sql: order_items_total_sales ;;
    value_format_name: usd
  }

  measure: total_order_items {
    type: number
    sql: order_items_total_order_items ;;
  }

  measure: total_retail_value {
    type: number
    sql: products_total_retail_value ;;
    value_format_name: usd
  }

  # --- Looker Derived Non-Aggregate Measure ---
  measure: average_item_sale_price {
    type: number
    sql: ${total_sales} / NULLIF(${total_order_items}, 0) ;;
    value_format_name: usd
  }
}
