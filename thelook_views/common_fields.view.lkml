# Common abstract base view defining standard primary key and count
view: common_fields {
  extension: required

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  measure: count {
    type: count
  }
}
