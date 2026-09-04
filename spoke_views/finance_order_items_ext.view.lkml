include: "/thelook_views/order_items.view.lkml"

# ==============================================================================
# SPOKE EXTENSION VIEW: order_items_ext
# ==============================================================================
# Extends 'order_items' to create a dedicated accounting reconciliation view.
# File Naming Standard: [view_name]_ext.view.lkml
# ==============================================================================

view: finance_order_items_ext {
  extends: [order_items]

  dimension: is_high_value_transaction {
    type: yesno
    description: "Flags transactions exceeding $100 for audit review"
    sql: ${sale_price} >= 100.00 ;;
  }

  measure: high_value_transaction_count {
    type: count
    description: "Total high-value orders requiring auditing"
    filters: [is_high_value_transaction: "yes"]
  }
}
