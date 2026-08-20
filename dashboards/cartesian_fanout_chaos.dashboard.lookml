- dashboard: cartesian_fanout_chaos
  title: "Cartesian Attribution & Self Join Matrix"
  layout: grid
  elements:
    - name: cross_join_sales
      title: "Order Items x Distribution Centers Cross Matrix"
      model: thelook
      explore: order_items
      type: table
      fields: [order_items.id, distribution_centers.name, users.country, order_items.sale_price]
      limit: 2000
    - name: non_equi_prior_events
      title: "Touches Within 60 Days Prior to Purchase"
      model: thelook
      explore: order_items
      type: table
      fields: [order_items.user_id, events.browser, prior_events.browser, order_items.total_sale_price]
      limit: 1000
    - name: peer_price_comparison
      title: "Higher Value Peer Orders Multiplier"
      model: thelook
      explore: order_items
      type: looker_scatter
      fields: [order_items.user_id, order_items.sale_price, higher_value_peer_orders.sale_price]
      limit: 1500
