connection: "default_bigquery_connection"

# Include all governed views and hub explores
include: "/thelook_views/**/*.view.lkml"
include: "/explores/thelook_hub.explore.lkml"

datagroup: thelook_default_datagroup {
  sql_trigger: SELECT MAX(id) FROM `sampitcher-playground.the_look_ca.order_items_table` ;;
  max_cache_age: "4 hours"
}

access_grant: pii_data {
  user_attribute: can_see_pii
  allowed_values: ["Yes"]
}

persist_with: thelook_default_datagroup

# Unhide official company-wide baseline explores
explore: +order_items {
  hidden: no
}

explore: +users {
  hidden: no
}

explore: +orders {
  hidden: no
}
