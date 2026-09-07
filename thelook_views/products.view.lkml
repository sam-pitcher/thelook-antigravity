include: "common_fields.view"

view: products {
  extends: [common_fields]
  sql_table_name: `bigquery-public-data.thelook_ecommerce.products` ;;

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    label: "Brand"
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    label: "Category"
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
    label: "Cost"
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: number
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }
}
