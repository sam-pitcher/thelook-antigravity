connection: "default_bigquery_connection"

# ==============================================================================
# MARKETING SPOKE MODEL
# ==============================================================================
# Demonstrates how a departmental spoke consumes central Hub explores and views,
# then extends and refines them with marketing-specific business logic.
# ==============================================================================

# 1. Include Central Hub Governed Views & Reusable Explores
include: "/thelook_views/**/*.view.lkml"
include: "/explores/thelook_hub.explore.lkml"

# 2. Include Marketing Spoke Refinement Views
include: "/thelook_spoke_views/marketing_users.view.lkml"

datagroup: marketing_daily_datagroup {
  sql_trigger: SELECT MAX(id) FROM `sampitcher-playground.the_look_ca.order_items_table` ;;
  max_cache_age: "2 hours"
}

persist_with: marketing_daily_datagroup

# 3. Refine Hub Explores specifically for the Marketing Department
explore: +order_items {
  label: "Marketing: Campaign Attribution & Orders"
  description: "Marketing-specific order analysis with channel attribution"
  group_label: "Marketing Spoke"
}

explore: +users {
  label: "Marketing: Customer Acquisition & Audiences"
  description: "User demographic and marketing traffic channel analysis"
  group_label: "Marketing Spoke"
}
