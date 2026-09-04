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

# Default datagroup required by central PDTs (user_order_facts)
datagroup: thelook_default_datagroup {
  sql_trigger: SELECT MAX(id) FROM `sampitcher-playground.the_look_ca.order_items_table` ;;
  max_cache_age: "4 hours"
}

datagroup: finance_eod_datagroup {
  sql_trigger: SELECT CURRENT_DATE() ;;
  max_cache_age: "12 hours"
}

access_grant: pii_data {
  user_attribute: can_see_pii
  allowed_values: ["Yes", "yes", "true"]
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

# 4. Extended Custom Departmental Explore (Extends Pattern)
explore: finance_high_value_audits {
  view_name: order_items_ext
  label: "Finance: High-Value Transaction Audits"
  group_label: "Finance Spoke"

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${finance_high_value_audits.user_id} ;;
  }

  join: inventory_items {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_items.id} = ${finance_high_value_audits.inventory_item_id} ;;
  }

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }
}
