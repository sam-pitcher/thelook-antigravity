# Include base view from imported Hub
include: "//thelook-antigravity/thelook_views/users.view.lkml"

# Refinement: [view_name]_rfn.view.lkml
view: +users {
  dimension: is_organic_acquisition {
    type: yesno
    sql: ${traffic_source} IN ('Search', 'Organic') ;;
  }

  measure: organic_user_count {
    type: count
    filters: [is_organic_acquisition: "yes"]
  }
}
