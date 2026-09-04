connection: "default_bigquery_connection"

# ==============================================================================
# EXTERNAL SPOKE MODEL (Using Project Import)
# ==============================================================================

# 1. Include governed assets from Central Hub
include: "//thelook-antigravity/thelook_views/**/*.view.lkml"
include: "//thelook-antigravity/explores/thelook_hub.explore.lkml"

# 2. Include local Spoke views / refinements
include: "/views/*.view.lkml"

datagroup: spoke_marketing_datagroup {
  sql_trigger: SELECT MAX(id) FROM `sampitcher-playground.the_look_ca.order_items_table` ;;
  max_cache_age: "4 hours"
}

persist_with: spoke_marketing_datagroup

# 3. Refine imported Hub explores with Departmental Branding & Controls
explore: +order_items {
  label: "Marketing: Campaign Attribution & Orders"
  group_label: "Marketing Team Explores"
}

explore: +users {
  label: "Marketing: Customer Acquisition & Audiences"
  group_label: "Marketing Team Explores"
}
