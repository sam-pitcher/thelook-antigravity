include: "/thelook_views/users.view.lkml"

# ==============================================================================
# SPOKE EXTENSION VIEW: users_ext
# ==============================================================================
# Creates an explicit new copy/variant of 'users' to avoid naming collisions.
# File Naming Standard: [view_name]_ext.view.lkml
# Recommendation: Extends is preferred when creating custom departmental objects.
# ==============================================================================

view: marketing_users_ext {
  extends: [users]

  dimension: campaign_cohort {
    type: string
    description: "Marketing cohort segmentation derived from signup quarter"
    sql: CONCAT('Cohort-', ${created_quarter}) ;;
  }

  measure: cohort_user_count {
    type: count_distinct
    sql: ${id} ;;
    description: "Count of unique users within campaign cohort"
  }
}
