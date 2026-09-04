include: "/thelook_views/users.view.lkml"

# ==============================================================================
# SPOKE VIEW REFINEMENT: Marketing Spoke
# ==============================================================================
# Refines the central Hub 'users' view to add department-specific dimensions
# and measures without modifying the core governed Hub code.
# ==============================================================================

view: +users {

  dimension: is_organic_acquisition {
    type: yesno
    description: "Marketing classification for Organic vs Paid traffic sources"
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
    description: "Total users acquired via paid media / marketing campaigns"
    filters: [is_organic_acquisition: "no"]
  }
}
