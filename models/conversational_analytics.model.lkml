connection: "default_bigquery_connection"
# connection: "bigquery_oauth"

include: "/conversational_analytics_views/*.view.lkml"

datagroup: daily {
  sql_trigger: select current_date() ;;
}

explore: interaction_logs {
  join: status {
    type: left_outer
    sql_on: ${interaction_logs.event_id} = ${status.event_id} ;;
    relationship: one_to_one
  }
  join: status_missing_field {
    type: left_outer
    sql_on: ${status.event_id} = ${status_missing_field.event_id} ;;
    relationship: one_to_one
  }

}

include: "/thelook_views/thelook_graph.view.lkml"
include: "/thelook_views/product_affinity_graph.view.lkml"
include: "/thelook_views/graph_network_analytics.view.lkml"
include: "/thelook_views/products.view.lkml"
include: "/thelook_views/users.view.lkml"

explore: thelook_graph {
  label: "TheLook Knowledge Graph"
  description: "In-database BigQuery Property Graph analytic model explore"
}

explore: product_affinity_graph {
  label: "Product Recommendations (Graph Multi-Hop)"
  description: "Collaborative filtering and affinity recommendations traversed across multi-hop graph paths"
}

explore: graph_network_analytics {
  label: "Graph Intelligence (Self-Service Multi-Hop Network)"
  description: "Interactive graph traversal combining dynamic GQL paths with full dimensional slicing on products and customers"

  join: anchor_product {
    from: products
    view_label: "1. Anchor Product (Origin)"
    type: left_outer
    sql_on: ${graph_network_analytics.anchor_product_id} = ${anchor_product.id} ;;
    relationship: many_to_one
  }

  join: recommended_product {
    from: products
    view_label: "2. Discovered Product (Recommendation)"
    type: left_outer
    sql_on: ${graph_network_analytics.recommended_product_id} = ${recommended_product.id} ;;
    relationship: many_to_one
  }

  join: connecting_customer {
    from: users
    view_label: "3. Connecting Customer (Graph Bridge)"
    type: left_outer
    sql_on: ${graph_network_analytics.connecting_user_id} = ${connecting_customer.id} ;;
    relationship: many_to_one
  }
}
