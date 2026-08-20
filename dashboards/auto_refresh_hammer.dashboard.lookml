- dashboard: auto_refresh_hammer
  title: "Realtime Ops Floor (1-Min Aggressive Refresh)"
  layout: grid
  refresh: 1 minute
  auto_run: true
  elements:
    - name: live_orders
      title: "Live Order Volume (Past 5 Min)"
      model: thelook
      explore: order_items
      type: looker_line
      fields: [order_items.created_time, order_items.count]
      limit: 500
    - name: live_revenue
      title: "Live Gross Revenue"
      model: thelook
      explore: order_items
      type: looker_column
      fields: [order_items.status, order_items.total_sale_price]
      limit: 500
    - name: live_events
      title: "Live Web Impressions"
      model: thelook
      explore: events
      type: looker_area
      fields: [events.browser, events.count]
      limit: 1000
    - name: live_users
      title: "Active Users"
      model: thelook
      explore: users
      type: single_value
      fields: [users.count]
