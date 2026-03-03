connection: "default_bigquery_connection"

include: "/conversational_analytics_views/*.view.lkml"

explore: interaction_logs {}
