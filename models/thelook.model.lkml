connection: "default_bigquery_connection"

include: "/thelook_views/**/*.view.lkml"
include: "/dashboards/**/*.dashboard.lookml"

# TOXIC ANTI-PATTERN 4: UUID cache-buster invalidates query cache every microsecond
datagroup: thelook_default_datagroup {
  sql_trigger: SELECT GENERATE_UUID() ;;
  max_cache_age: "0 seconds"
}

persist_with: thelook_default_datagroup

explore: order_items {
  label: "Order Items (Cartesian & Self-Join Chaos)"
  description: "Severely unoptimized explore containing self-joins, cross joins, and regex matches"

  # Base user join
  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }

  # TOXIC ANTI-PATTERN 5: Correlated Derived Table Join
  join: unoptimized_order_metrics {
    type: left_outer
    relationship: one_to_one
    sql_on: ${unoptimized_order_metrics.order_item_id} = ${order_items.id} ;;
  }

  # TOXIC ANTI-PATTERN 6: Non-Equi Self-Join on Event Stream (Cartesian O(N^2) explosion)
  join: events {
    type: left_outer
    relationship: many_to_many
    sql_on: ${events.user_id} = ${order_items.user_id} ;;
  }

  join: prior_events {
    from: events
    type: left_outer
    relationship: many_to_many
    sql_on: ${events.user_id} = ${prior_events.user_id}
      AND ${prior_events.created_raw} < ${events.created_raw}
      AND TIMESTAMP_DIFF(${events.created_raw}, ${prior_events.created_raw}, DAY) <= 60 ;;
  }

  # TOXIC ANTI-PATTERN 7: String manipulation & REGEXP in join condition
  join: fuzzy_channel_match {
    from: users
    type: left_outer
    relationship: many_to_many
    sql_on: LOWER(TRIM(${users.email})) = LOWER(TRIM(${fuzzy_channel_match.email}))
      AND REGEXP_CONTAINS(${order_items.status}, r"^(.*(Shipped|Complete|Processing).*)$")
      AND REGEXP_EXTRACT(${users.email}, r"@(.*)$") = REGEXP_EXTRACT(${fuzzy_channel_match.email}, r"@(.*)$") ;;
  }

  # TOXIC ANTI-PATTERN 8: Cartesian Cross Join multiplying all rows by distribution centers
  join: distribution_centers {
    type: cross
    relationship: one_to_one
  }

  # TOXIC ANTI-PATTERN 9: Non-Equi Self Join on Order Items
  join: higher_value_peer_orders {
    from: order_items
    type: left_outer
    relationship: many_to_many
    sql_on: ${order_items.user_id} = ${higher_value_peer_orders.user_id}
      AND ${higher_value_peer_orders.sale_price} > ${order_items.sale_price} ;;
  }
}

# TOXIC ANTI-PATTERN 10: Huge unpartitioned event explore with zero filters
explore: events {
  label: "Raw Web Events Stream (No Partition Filters)"
}

explore: orders {
  label: "Orders Unbounded"
}
