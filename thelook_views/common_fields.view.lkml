view: common_fields {
  extension: required
  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }
  # plus loads of others...
}
