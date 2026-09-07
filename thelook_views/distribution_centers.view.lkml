include: "common_fields.view"

view: distribution_centers {
  extends: [common_fields]
  sql_table_name: `bigquery-public-data.thelook_ecommerce.distribution_centers` ;;

  dimension: distribution_center_geom {
    type: string
    sql: ${TABLE}.distribution_center_geom ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }
}
