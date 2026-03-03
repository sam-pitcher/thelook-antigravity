view: lookml_gaps {
  sql_table_name: `sampitcher-playground.conversation_logs.lookml_gaps` ;;

  dimension: agent_id {
    type: string
    sql: ${TABLE}.agent_id ;;
  }
  dimension: conversation_id {
    type: string
    sql: ${TABLE}.conversation_id ;;
  }
  dimension: missing_fields {
    type: string
    sql: ${TABLE}.missing_fields ;;
  }
  dimension: query {
    type: string
    sql: ${TABLE}.query ;;
  }
  dimension: reason {
    type: string
    sql: ${TABLE}.reason ;;
  }
  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }
  dimension_group: timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.timestamp ;;
  }
  measure: count {
    type: count
  }
}
