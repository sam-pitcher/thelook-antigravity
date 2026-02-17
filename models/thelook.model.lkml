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
  # access_filter: {
  #   field: users.country
  #   user_attribute: country
  # }
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

# Place in `thelook` model
# explore: +order_items {
#   aggregate_table: rollup__created_date {
#     query: {
#       dimensions: [
#         created_date,
#         status
#       ]
#       measures: [total_sale_price]

#     }

#     materialization: {
#       partition_keys: [created_date]
#       cluster_keys: [status]
#       datagroup_trigger: daily
#     }
#   }
# }


# explore: users_fact {}

explore: users {}
