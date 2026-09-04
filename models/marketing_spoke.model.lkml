connection: "default_bigquery_connection"

# ==============================================================================
# DEPARTMENTAL SPOKE MODEL: Marketing
# ==============================================================================
# Consumes central Hub explores and views, then refines/extends them.
# ==============================================================================

# 1. Include Central Hub Governed Views & Reusable Explores
include: "/thelook_views/**/*.view.lkml"
include: "/explores/thelook_hub.explore.lkml"

# 2. Include Marketing Spoke Refinement and Extension Views
include: "/spoke_views/marketing_users_rfn.view.lkml"
include: "/spoke_views/marketing_users_ext.view.lkml"

datagroup: marketing_daily_datagroup {
  sql_trigger: SELECT MAX(id) FROM `sampitcher-playground.the_look_ca.order_items_table` ;;
  max_cache_age: "2 hours"
}

persist_with: marketing_daily_datagroup

# 3. Refined Hub Explores for Marketing
explore: +order_items {
  label: "Marketing: Campaign Attribution & Orders"
  group_label: "Marketing Spoke"
}

explore: +users {
  label: "Marketing: Customer Acquisition & Audiences"
  group_label: "Marketing Spoke"
}

# 4. Extended Custom Departmental Explore (Demonstrating Extends pattern)
explore: marketing_campaign_cohorts {
  extends: [users]
  from: marketing_users_ext
  label: "Marketing: Cohort Performance Analysis"
  group_label: "Marketing Spoke"
}
