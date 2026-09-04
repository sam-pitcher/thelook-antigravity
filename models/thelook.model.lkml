connection: "default_bigquery_connection"

include: "/thelook_views/**/*.view.lkml"

datagroup: thelook_default_datagroup {
  sql_trigger: SELECT MAX(id) FROM `sampitcher-playground.the_look_ca.order_items_table` ;;
  max_cache_age: "4 hours"
}

access_grant: pii_data {
  user_attribute: can_see_pii
  allowed_values: ["Yes"]
}

persist_with: thelook_default_datagroup

explore: order_items {
  label: "Order Items"
  description: "Core sales and order item performance explore"

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
  label: "Orders"
  description: "Order-level analysis explore"

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
  label: "Users"
  description: "User customer lifetime facts and demographics"

  join: user_order_facts {
    type: left_outer
    relationship: one_to_one
    sql_on: ${user_order_facts.user_id} = ${users.id} ;;
  }
}

explore: events {
  label: "Events"
  description: "Web traffic and event clickstream"

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${events.user_id} ;;
  }
}
