include: "common_fields.view"

view: users {
  extends: [common_fields]
  sql_table_name: `sampitcher-playground.the_look_ca.users_table` ;;

  # ANTI-PATTERN 5: Primary key omitted - triggers Symmetric Aggregates & inaccurate distinct hashes
  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  # ANTI-PATTERN 6: ALL_CAPS naming with no description
  dimension: USER_AGE {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    type: tier
    sql: ${USER_AGE} ;;
    tiers: [0, 10, 30, 60]
    style: integer
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: .email ;;
  }

  # INTENTIONAL 15-20 SECOND EXPLORE STRESS TEST (HEAVY BIGQUERY UNNEST)
  dimension: slow_compute_benchmark {
    type: string
    sql: (
      SELECT CAST(SUM(FARM_FINGERPRINT(CONCAT(CAST(x AS STRING), .email))) AS STRING)
      FROM UNNEST(GENERATE_ARRAY(1, 1000000)) as x
    ) ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  # ANTI-PATTERN 7: PascalCase naming
  dimension: FullCustomerName {
    type: string
    sql: CONCAT(${first_name}, " ", ${last_name}) ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: street_address {
    type: string
    sql: ${TABLE}.street_address ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: user_geom {
    type: string
    sql: ${TABLE}.user_geom ;;
  }

  measure: count {
    type: count
    drill_fields: [last_name, first_name]
  }
}
