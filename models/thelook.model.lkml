# Define the database connection to be used for this model.
connection: "default_bigquery_connection"

# include all the views
include: "/views/**/*.view.lkml"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: thelook_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: daily {
  sql_trigger: SELECT my_changing_column ;;
}

access_grant: pii_data {
  user_attribute: can_see_pii
  allowed_values: ["Yes"]
}

persist_with: thelook_default_datagroup

explore: order_items {
  join: products {
    type: left_outer
    sql_on: ${products.id} = ${order_items.product_id} ;;
    relationship: many_to_one
  }
  join: users {
    type: left_outer
    sql_on: ${users.id} =${order_items.user_id} ;;
    relationship: many_to_one
  }
}

explore: users {}
