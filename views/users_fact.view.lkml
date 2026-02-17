view: users_fact {
  # derived_table: {
  #   sql:
  #   SELECT
  #   users.id  AS user_id,
  #   COALESCE(SUM(order_items.sale_price ), 0) AS total_sale_price
  #   FROM `the_look.order_items`  AS order_items
  #   LEFT JOIN `the_look.users`  AS users ON order_items.user_id = users.id
  #   GROUP BY
  #       1
  #   ORDER BY
  #       2 DESC
  #   ;;
  # }

  derived_table: {
    # datagroup_trigger: daily
    explore_source: order_items {
      column: id { field: users.id }
      column: total_sale_price {}
    }
  }

  dimension: user_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: total_sale_price {
    type: number
    sql: ${TABLE}.total_sale_price ;;
  }

  measure: average_price_per_user {
    type: average
    sql: ${total_sale_price} ;;
  }

}
