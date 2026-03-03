connection: "default_bigquery_connection"

include: "/conversational_analytics_views/*.view.lkml"

datagroup: daily {
  sql_trigger: select current_date() ;;
}

explore: interaction_logs {}
