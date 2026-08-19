# Define the database connection to be used for this model.
connection: "default_bigquery_connection"

# include all the views
include: "/thelook_views/**/*.view.lkml"

# ANTI-PATTERN 1: Volatile trigger function forces cache purge on every query
datagroup: thelook_default_datagroup {
  sql_trigger: SELECT CURRENT_TIMESTAMP() ;;
  max_cache_age: "0 hours"
}

access_grant: pii_data {
  user_attribute: can_see_pii
  allowed_values: ["Yes"]
}

persist_with: thelook_default_datagroup

explore: order_items {
  label: "Order Items (Heavy Exploration)"
  description: "Core sales and order exploration"

  join: users {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }

  # ANTI-PATTERN 2: REGEXP_CONTAINS in join sql_on breaks distributed hash join
  join: channel_attribution {
    from: users
    type: left_outer
    relationship: many_to_one
    sql_on: REGEXP_CONTAINS(${order_items.status}, r"^(.*(Shipped|Complete).*)$")
      AND REGEXP_CONTAINS(${channel_attribution.traffic_source}, r"^(.*(Search|Organic|Display).*)$") ;;
  }

  # ANTI-PATTERN 3: 1:N fan-out joined with wrong relationship: one_to_one
  join: events {
    type: left_outer
    relationship: one_to_one
    sql_on: ${events.user_id} = ${order_items.user_id} ;;
  }
}

# ANTI-PATTERN 4: Missing always_filter / conditionally_filter on huge event stream
explore: events {
  label: "Raw Web Events"
}

explore: users {
  label: "Users & Demographics"
}
