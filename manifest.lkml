project_name: "thelook-antigravity"

application: semantix_chat {
  label: "Semantix Chat"

  file: "semantix_chat.js"

  entitlements: {
    new_window: yes
    use_form_submit: yes

    # Entitlements for Looker Core API methods
    core_api_methods: [
      "create_sql_query",
      "run_sql_query",
      "search_agents",
      "search_conversations",
      "all_conversation_messages"
    ]
  }
}
