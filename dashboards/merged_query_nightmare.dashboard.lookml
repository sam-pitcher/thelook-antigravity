- dashboard: merged_query_nightmare
  title: "Omnichannel Merged Funnel (JVM In-Memory Joins)"
  layout: grid
  elements:
    - name: merged_funnel_view
      title: "Cross-Explore Merged Revenue & Traffic Funnel"
      type: looker_column
      merged_queries:
        - model: thelook
          explore: order_items
          fields: [users.country, order_items.total_sale_price]
        - model: thelook
          explore: events
          fields: [events.city, events.count]
          join_fields:
            - field_name: events.city
              source_field_name: users.country
        - model: thelook
          explore: users
          fields: [users.country, users.count]
          join_fields:
            - field_name: users.country
              source_field_name: users.country
      limit: 1000
