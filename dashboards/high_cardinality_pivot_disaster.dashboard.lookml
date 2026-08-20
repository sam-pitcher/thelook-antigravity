- dashboard: high_cardinality_pivot_disaster
  title: "User Domain & Browser Cross-Tab (Pivot Chaos)"
  layout: grid
  elements:
    - name: massive_pivot_grid
      title: "500-Column Email Domain Pivot"
      model: thelook
      explore: order_items
      type: table
      fields: [users.email, order_items.status, order_items.total_sale_price]
      pivots: [order_items.status]
      limit: 5000
    - name: browser_event_pivot
      title: "Browser vs City Full Pivot"
      model: thelook
      explore: events
      type: table
      fields: [events.city, events.browser, events.count]
      pivots: [events.browser]
      limit: 5000
