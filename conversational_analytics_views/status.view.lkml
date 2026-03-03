view: status {
  derived_table: {
    datagroup_trigger: daily
    increment_key: "timestamp"
    increment_offset: 1
    sql: SELECT
        event_id,
        timestamp,
        -- Extracts the classification directly
        JSON_VALUE(ml_generate_text_result, '$.candidates[0].content.parts[0].text') AS status
      FROM
        ML.GENERATE_TEXT(
          MODEL `sampitcher-playground.conversation_logs.gemini_2_5_flash`,
          (
            SELECT
              event_id,
              timestamp,
              CONCAT(
                'Analyze this conversational agent log. Classify it into exactly one of these categories: ',
                'MISSING_DATA: If the agent says there are no values or access to a specific table. ',
                'MISSING_FIELD: If the agent says it lacks a field or column. The the fields needed to calculate the requested measure. ',
                'DISAMBIGUATION: If the agent asks for clarification or is confused between multiple options. ',
                'SUCCESS: If the agent successfully answered or is processing a query. ',
                'ERROR: For hallucinations or "field not found" messages. ',
                'Return ONLY the category name. Content to analyze: ', content
              ) AS prompt
            FROM
              `sampitcher-playground.conversation_logs.interaction_logs`
            WHERE {% incrementcondition %} timestamp {%  endincrementcondition %}
          ),
          STRUCT(
            0.1 AS temperature,
            20 AS max_output_tokens
          )
        ) ;;
  }

  dimension: event_id {
    type: string
    sql: ${TABLE}.event_id ;;
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

}
