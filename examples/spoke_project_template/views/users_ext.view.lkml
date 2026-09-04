# Include base view from imported Hub
include: "//thelook-antigravity/thelook_views/users.view.lkml"

# Extension: [view_name]_ext.view.lkml
view: users_ext {
  extends: [users]

  dimension: campaign_cohort {
    type: string
    sql: CONCAT('Cohort-', ${created_quarter}) ;;
  }
}
