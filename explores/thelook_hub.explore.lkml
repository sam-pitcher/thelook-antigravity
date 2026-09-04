# ==============================================================================
# HUB EXPLORES: Governed, centralized explore definitions for Hub & Spoke
# ==============================================================================
# Spoke projects import these explores using project_import:
#   include: "//thelook-antigravity/explores/thelook_hub.explore.lkml"
# ==============================================================================

include: "/thelook_views/**/*.view.lkml"

explore: order_items {
  hidden: yes
  label: "Order Items"
  description: "Core sales and order item performance explore (Hub Governed)"

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }

  join: inventory_items {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }

  join: distribution_centers {
    type: left_outer
    relationship: many_to_one
    sql_on: ${distribution_centers.id} = ${products.distribution_center_id} ;;
  }

  join: user_order_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${user_order_facts.user_id} = ${order_items.user_id} ;;
  }
}

explore: orders {
  hidden: yes
  label: "Orders"
  description: "Order-level analysis explore (Hub Governed)"

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${orders.user_id} ;;
  }

  join: user_order_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${user_order_facts.user_id} = ${orders.user_id} ;;
  }
}

explore: users {
  hidden: yes
  label: "Users"
  description: "User customer lifetime facts and demographics (Hub Governed)"

  join: user_order_facts {
    type: left_outer
    relationship: one_to_one
    sql_on: ${user_order_facts.user_id} = ${users.id} ;;
  }
}
