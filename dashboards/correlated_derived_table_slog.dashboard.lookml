- dashboard: correlated_derived_table_slog
  title: "Customer Journey Deep Dive (Correlated Subquery Slog)"
  layout: grid
  elements:
    - name: touch_attribution_table
      title: "Touches Prior to Order & Browser Trail"
      model: thelook
      explore: order_items
      type: table
      fields: [unoptimized_order_metrics.order_item_id, unoptimized_order_metrics.user_id, unoptimized_order_metrics.touches_prior_to_order, unoptimized_order_metrics.full_user_browser_trail, unoptimized_order_metrics.user_lifetime_avg_price]
      limit: 2000
    - name: recency_rank_distribution
      title: "Recency Rank vs Revenue"
      model: thelook
      explore: order_items
      type: looker_column
      fields: [unoptimized_order_metrics.user_id, unoptimized_order_metrics.total_unweighted_user_avg]
      limit: 1000
