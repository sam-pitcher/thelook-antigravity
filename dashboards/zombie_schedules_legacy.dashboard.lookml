- dashboard: zombie_schedules_legacy
  title: "Legacy Deprecated Metrics & Orphaned Content"
  layout: grid
  elements:
    - name: deprecated_sales_grid
      title: "Legacy Orders with Deprecated Parameters"
      model: thelook
      explore: orders
      type: table
      fields: [orders.order_id, orders.status, orders.count]
      limit: 5000
    - name: unmasked_pii_user_dump
      title: "Unmasked User Demographics"
      model: thelook
      explore: users
      type: table
      fields: [users.id, users.first_name, users.last_name, users.email, users.country]
      limit: 5000
