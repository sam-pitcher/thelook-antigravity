- dashboard: table_calculation_lockup
  title: "Financial Projections & Moving Windows (Table Calc Heavy)"
  layout: grid
  elements:
    - name: complex_calc_table
      title: "15 Nested Moving Window Calculations"
      model: thelook
      explore: order_items
      type: table
      fields: [order_items.created_date, order_items.count, order_items.total_sale_price]
      table_calculations:
        - table_calculation: running_sales
          label: "Running Total Sales"
          expression: "running_total(${order_items.total_sale_price})"
        - table_calculation: pct_of_running
          label: "Percent of Running Total"
          expression: "${order_items.total_sale_price} / running_total(${order_items.total_sale_price})"
        - table_calculation: 7d_moving_avg
          label: "7 Day Moving Average"
          expression: "mean(offset_list(${order_items.total_sale_price}, -6, 7))"
        - table_calculation: 14d_moving_avg
          label: "14 Day Moving Average"
          expression: "mean(offset_list(${order_items.total_sale_price}, -13, 14))"
        - table_calculation: 30d_moving_avg
          label: "30 Day Moving Average"
          expression: "mean(offset_list(${order_items.total_sale_price}, -29, 30))"
        - table_calculation: lag_diff
          label: "Day-over-Day Diff"
          expression: "${order_items.total_sale_price} - offset(${order_items.total_sale_price}, -1)"
        - table_calculation: lag_pct
          label: "Day-over-Day Percent Change"
          expression: "(${order_items.total_sale_price} - offset(${order_items.total_sale_price}, -1)) / offset(${order_items.total_sale_price}, -1)"
        - table_calculation: z_score
          label: "Z-Score"
          expression: "(${order_items.total_sale_price} - mean(${order_items.total_sale_price})) / standard_deviation(${order_items.total_sale_price})"
      limit: 5000
