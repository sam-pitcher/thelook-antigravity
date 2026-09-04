connection: "default_bigquery_connection"

# ==============================================================================
# FINANCE SPOKE MODEL
# ==============================================================================
# Demonstrates how the Finance department consumes central Hub explores and views,
# then refines them with tax and margin accounting fields.
# ==============================================================================

# 1. Include Central Hub Governed Views & Reusable Explores
include: "/thelook_views/**/*.view.lkml"
include: "/explores/thelook_hub.explore.lkml"

# 2. Include Finance Spoke Refinement Views
include: "/thelook_spoke_views/finance_order_items.view.lkml"

datagroup: finance_eod_datagroup {
  sql_trigger: SELECT CURRENT_DATE() ;;
  max_cache_age: "12 hours"
}

persist_with: finance_eod_datagroup

# 3. Refine Hub Explores specifically for the Finance Department
explore: +order_items {
  label: "Finance: Revenue & Tax Accounting"
  description: "Financial performance, margin breakdown, and tax liability"
  group_label: "Finance Spoke"
}

explore: +orders {
  label: "Finance: Order Audit Trail"
  description: "Reconciled order history"
  group_label: "Finance Spoke"
}
