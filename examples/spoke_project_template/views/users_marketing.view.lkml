# Include the base view from the imported Hub project
include: "//thelook-antigravity/thelook_views/users.view.lkml"

# Refine the Hub 'users' view with Marketing-specific dimensions and metrics
view: +users {

  dimension: is_organic_acquisition {
    type: yesno
    description: "Indicates whether the user arrived through organic search"
    sql: ${traffic_source} IN ('Search', 'Organic') ;;
  }

  dimension: marketing_channel_group {
    type: string
    description: "Standardized marketing acquisition channel groupings"
    sql: CASE 
           WHEN ${traffic_source} IN ('Search', 'Organic') THEN 'Search Engine'
           WHEN ${traffic_source} = 'Email' THEN 'Direct Email CRM'
           WHEN ${traffic_source} = 'Facebook' THEN 'Social Ads'
           ELSE 'Display / Other'
         END ;;
  }

  measure: organic_user_count {
    type: count
    description: "Total users acquired via organic search"
    filters: [is_organic_acquisition: "yes"]
  }

  measure: paid_user_count {
    type: count
    description: "Total users acquired via paid media campaigns"
    filters: [is_organic_acquisition: "no"]
  }
}
