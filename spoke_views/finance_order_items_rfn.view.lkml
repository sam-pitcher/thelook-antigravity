include: "/thelook_views/order_items.view.lkml"

# ==============================================================================
# SPOKE REFINEMENT VIEW: order_items_rfn
# ==============================================================================
# Refines 'order_items' in place for Finance accounting logic.
# File Naming Standard: [view_name]_rfn.view.lkml
# ==============================================================================

view: +order_items {

  dimension: estimated_tax {
    type: number
    description: "Estimated sales tax at 8.25% standard rate"
    sql: ${sale_price} * 0.0825 ;;
    value_format_name: usd
  }

  dimension: net_revenue_pre_cost {
    type: number
    description: "Gross revenue minus estimated tax liability"
    sql: ${sale_price} - ${estimated_tax} ;;
    value_format_name: usd
  }

  measure: total_estimated_tax {
    type: sum
    description: "Total tax liability across order items"
    sql: ${estimated_tax} ;;
    value_format_name: usd
  }

  measure: total_net_revenue {
    type: sum
    description: "Net revenue after tax deductions"
    sql: ${net_revenue_pre_cost} ;;
    value_format_name: usd
  }
}
