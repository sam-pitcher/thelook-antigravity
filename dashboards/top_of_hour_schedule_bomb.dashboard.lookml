- dashboard: top_of_hour_schedule_bomb
  title: "Automated Executive Digest (Top of Hour Pileup)"
  layout: grid
  elements:
    - name: hourly_revenue_dump
      title: "Hourly Revenue Dump"
      model: thelook
      explore: order_items
      type: table
      fields: [order_items.created_date, users.country, order_items.status, order_items.total_sale_price]
      limit: 2500
    - name: hourly_event_dump
      title: "Hourly Web Activity"
      model: thelook
      explore: events
      type: table
      fields: [events.created_date, events.browser, events.traffic_source, events.count]
      limit: 5000
    - name: hourly_inventory_dump
      title: "Inventory Stock Distribution"
      model: thelook
      explore: order_items
      type: looker_column
      fields: [products.category, products.brand, order_items.count]
      limit: 1000
