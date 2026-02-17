include: "common_fields.view"
view: order_items {
  extends: [common_fields]
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `the_look.order_items` ;;

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.delivered_at ;;
  }
    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "ID" in Explore.

  dimension: inventory_item_id {
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: product_id {
    hidden: yes
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: total_sale_price {
    description: "The global revenue for the look"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: eur_0
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format_name: eur_0
  }

  measure: total_completed_sale_price {
    type: sum
    sql: ${sale_price} ;;
    filters: [status: "Complete"]
    value_format_name: eur_0
  }

  dimension_group: shipped {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: orders_items_last_month {
    type: period_over_period
    based_on: count
    based_on_time: created_month
    period: month
    kind: previous
  }

  measure: ytd {
    type: running_total
    sql: ${count} ;;
  }

  measure: count {
    type: count
  }
}


view: +order_items {
  dimension: status {
    html: Status: {{status._value}}} ;;
  }
}
