- dashboard: unfiltered_event_firehose
  title: "Raw Event Stream Analytics (Unbounded Scans)"
  layout: grid
  elements:
    - name: all_events_raw
      title: "All Events Unfiltered (Full Table Scan)"
      model: thelook
      explore: events
      type: table
      fields: [events.id, events.user_id, events.sequence_number, events.session_id, events.ip_address, events.city]
      limit: 5000
    - name: event_traffic_funnel
      title: "Traffic Source by Browser"
      model: thelook
      explore: events
      type: looker_bar
      fields: [events.browser, events.traffic_source, events.count]
      limit: 2500
    - name: event_geo_spread
      title: "Geographic Spread"
      model: thelook
      explore: events
      type: looker_geo
      fields: [events.city, events.state, events.count]
      limit: 5000
    - name: event_sessions
      title: "Session Duration Distribution"
      model: thelook
      explore: events
      type: looker_column
      fields: [events.session_id, events.count]
      limit: 5000
