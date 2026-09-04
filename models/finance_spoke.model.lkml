connection: "default_bigquery_connection"

# ==============================================================================
# DEPARTMENTAL SPOKE MODEL: Finance
# ==============================================================================
# Consumes central Hub explores and views, then refines/extends them with accounting logic.
# ==============================================================================

# 1. Include Central Hub Governed Views & Reusable Explores
include: "/thelook_views/**/*.view.lkml"
include: "/explores/thelook_hub.explore.lkml"

# 2. Include Finance Spoke Refinement and Extension Views
include: "/spoke_views/finance_order_items_rfn.view.lkml"
include: "/spoke_views/finance_order_items_ext.view.lkml"

datagroup: finance_eod_datagroup {
  sql_trigger: SELECT CURRENT_DATE() ;;
  max_cache_age: "12 hours"
}

persist_with: finance_eod_datagroup

# 3. Refined Hub Explores for Finance
explore: +order_items {
  label: "Finance: Revenue & Tax Accounting"
  group_label: "Finance Spoke"
}

explore: +orders {
  label: "Finance: Order Audit Trail"
  group_label: "Finance Spoke"
}

# 4. Extended Custom Departmental Explore (Demonstrating Extends pattern)
explore: finance_high_value_audits {
  extends: [order_items]
  from: finance_order_items_ext
  label: "Finance: High-Value Transaction Audits"
  group_label: "Finance Spoke"
}
