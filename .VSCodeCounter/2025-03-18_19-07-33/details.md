# Details

Date : 2025-03-18 19:07:33

Directory /Users/arthur/Projects/guapchat

Total : 74 files,  2788 codes, 391 comments, 604 blanks, all 3783 lines

[Summary](results.md) / Details / [Diff Summary](diff.md) / [Diff Details](diff-details.md)

## Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [chatserver/.formatter.exs](/chatserver/.formatter.exs) | Elixir | 6 | 0 | 1 | 7 |
| [chatserver/README.md](/chatserver/README.md) | Markdown | 12 | 0 | 7 | 19 |
| [chatserver/assets/css/app.css](/chatserver/assets/css/app.css) | CSS | 3 | 1 | 2 | 6 |
| [chatserver/assets/js/app.js](/chatserver/assets/js/app.js) | JavaScript | 14 | 23 | 8 | 45 |
| [chatserver/assets/js/user\_socket.js](/chatserver/assets/js/user_socket.js) | JavaScript | 8 | 51 | 6 | 65 |
| [chatserver/assets/tailwind.config.js](/chatserver/assets/tailwind.config.js) | JavaScript | 61 | 10 | 4 | 75 |
| [chatserver/assets/vendor/topbar.js](/chatserver/assets/vendor/topbar.js) | JavaScript | 153 | 7 | 6 | 166 |
| [chatserver/config/config.exs](/chatserver/config/config.exs) | Elixir | 42 | 20 | 10 | 72 |
| [chatserver/config/dev.exs](/chatserver/config/dev.exs) | Elixir | 39 | 40 | 12 | 91 |
| [chatserver/config/prod.exs](/chatserver/config/prod.exs) | Elixir | 7 | 10 | 6 | 23 |
| [chatserver/config/runtime.exs](/chatserver/config/runtime.exs) | Elixir | 33 | 73 | 12 | 118 |
| [chatserver/config/test.exs](/chatserver/config/test.exs) | Elixir | 21 | 12 | 8 | 41 |
| [chatserver/lib/chatserver.ex](/chatserver/lib/chatserver.ex) | Elixir | 8 | 0 | 2 | 10 |
| [chatserver/lib/chatserver/accounts.ex](/chatserver/lib/chatserver/accounts.ex) | Elixir | 111 | 6 | 40 | 157 |
| [chatserver/lib/chatserver/accounts/user.ex](/chatserver/lib/chatserver/accounts/user.ex) | Elixir | 19 | 0 | 3 | 22 |
| [chatserver/lib/chatserver/application.ex](/chatserver/lib/chatserver/application.ex) | Elixir | 22 | 10 | 5 | 37 |
| [chatserver/lib/chatserver/auth.ex](/chatserver/lib/chatserver/auth.ex) | Elixir | 100 | 0 | 19 | 119 |
| [chatserver/lib/chatserver/dialogue/dialogue.ex](/chatserver/lib/chatserver/dialogue/dialogue.ex) | Elixir | 15 | 0 | 4 | 19 |
| [chatserver/lib/chatserver/dialogues.ex](/chatserver/lib/chatserver/dialogues.ex) | Elixir | 46 | 0 | 11 | 57 |
| [chatserver/lib/chatserver/mailer.ex](/chatserver/lib/chatserver/mailer.ex) | Elixir | 3 | 0 | 1 | 4 |
| [chatserver/lib/chatserver/messages.ex](/chatserver/lib/chatserver/messages.ex) | Elixir | 70 | 6 | 32 | 108 |
| [chatserver/lib/chatserver/messages/message.ex](/chatserver/lib/chatserver/messages/message.ex) | Elixir | 17 | 0 | 4 | 21 |
| [chatserver/lib/chatserver/repo.ex](/chatserver/lib/chatserver/repo.ex) | Elixir | 5 | 0 | 1 | 6 |
| [chatserver/lib/chatserver/token.ex](/chatserver/lib/chatserver/token.ex) | Elixir | 3 | 1 | 1 | 5 |
| [chatserver/lib/chatserver\_web.ex](/chatserver/lib/chatserver_web.ex) | Elixir | 83 | 8 | 26 | 117 |
| [chatserver/lib/chatserver\_web/channels/main\_channel.ex](/chatserver/lib/chatserver_web/channels/main_channel.ex) | Elixir | 76 | 5 | 16 | 97 |
| [chatserver/lib/chatserver\_web/channels/user\_socket.ex](/chatserver/lib/chatserver_web/channels/user_socket.ex) | Elixir | 27 | 1 | 8 | 36 |
| [chatserver/lib/chatserver\_web/components/core\_components.ex](/chatserver/lib/chatserver_web/components/core_components.ex) | Elixir | 562 | 23 | 92 | 677 |
| [chatserver/lib/chatserver\_web/components/layouts.ex](/chatserver/lib/chatserver_web/components/layouts.ex) | Elixir | 12 | 0 | 3 | 15 |
| [chatserver/lib/chatserver\_web/controllers/auth\_controller.ex](/chatserver/lib/chatserver_web/controllers/auth_controller.ex) | Elixir | 122 | 0 | 20 | 142 |
| [chatserver/lib/chatserver\_web/controllers/changeset\_json.ex](/chatserver/lib/chatserver_web/controllers/changeset_json.ex) | Elixir | 13 | 9 | 4 | 26 |
| [chatserver/lib/chatserver\_web/controllers/dialogue\_controller.ex](/chatserver/lib/chatserver_web/controllers/dialogue_controller.ex) | Elixir | 23 | 0 | 5 | 28 |
| [chatserver/lib/chatserver\_web/controllers/error\_html.ex](/chatserver/lib/chatserver_web/controllers/error_html.ex) | Elixir | 10 | 11 | 4 | 25 |
| [chatserver/lib/chatserver\_web/controllers/error\_json.ex](/chatserver/lib/chatserver_web/controllers/error_json.ex) | Elixir | 9 | 9 | 4 | 22 |
| [chatserver/lib/chatserver\_web/controllers/fallback\_controller.ex](/chatserver/lib/chatserver_web/controllers/fallback_controller.ex) | Elixir | 19 | 2 | 4 | 25 |
| [chatserver/lib/chatserver\_web/controllers/message\_controller.ex](/chatserver/lib/chatserver_web/controllers/message_controller.ex) | Elixir | 34 | 0 | 10 | 44 |
| [chatserver/lib/chatserver\_web/controllers/message\_json.ex](/chatserver/lib/chatserver_web/controllers/message_json.ex) | Elixir | 23 | 0 | 4 | 27 |
| [chatserver/lib/chatserver\_web/controllers/page\_controller.ex](/chatserver/lib/chatserver_web/controllers/page_controller.ex) | Elixir | 6 | 2 | 2 | 10 |
| [chatserver/lib/chatserver\_web/controllers/page\_html.ex](/chatserver/lib/chatserver_web/controllers/page_html.ex) | Elixir | 8 | 0 | 3 | 11 |
| [chatserver/lib/chatserver\_web/controllers/user\_controller.ex](/chatserver/lib/chatserver_web/controllers/user_controller.ex) | Elixir | 34 | 0 | 10 | 44 |
| [chatserver/lib/chatserver\_web/controllers/user\_json.ex](/chatserver/lib/chatserver_web/controllers/user_json.ex) | Elixir | 22 | 0 | 4 | 26 |
| [chatserver/lib/chatserver\_web/endpoint.ex](/chatserver/lib/chatserver_web/endpoint.ex) | Elixir | 39 | 9 | 9 | 57 |
| [chatserver/lib/chatserver\_web/gettext.ex](/chatserver/lib/chatserver_web/gettext.ex) | Elixir | 16 | 3 | 7 | 26 |
| [chatserver/lib/chatserver\_web/router.ex](/chatserver/lib/chatserver_web/router.ex) | Elixir | 25 | 0 | 1 | 26 |
| [chatserver/lib/chatserver\_web/telemetry.ex](/chatserver/lib/chatserver_web/telemetry.ex) | Elixir | 76 | 10 | 8 | 94 |
| [chatserver/mix.exs](/chatserver/mix.exs) | Elixir | 70 | 13 | 6 | 89 |
| [chatserver/mix.lock](/chatserver/mix.lock) | Elixir | 46 | 0 | 1 | 47 |
| [chatserver/priv/repo/migrations/.formatter.exs](/chatserver/priv/repo/migrations/.formatter.exs) | Elixir | 4 | 0 | 1 | 5 |
| [chatserver/priv/repo/migrations/20250227163235\_create\_users.exs](/chatserver/priv/repo/migrations/20250227163235_create_users.exs) | Elixir | 13 | 0 | 3 | 16 |
| [chatserver/priv/repo/migrations/20250227163314\_create\_messages.exs](/chatserver/priv/repo/migrations/20250227163314_create_messages.exs) | Elixir | 12 | 0 | 3 | 15 |
| [chatserver/priv/repo/migrations/20250317110600\_users\_passhash.exs](/chatserver/priv/repo/migrations/20250317110600_users_passhash.exs) | Elixir | 13 | 0 | 3 | 16 |
| [chatserver/priv/repo/migrations/20250317175445\_dialogues.exs](/chatserver/priv/repo/migrations/20250317175445_dialogues.exs) | Elixir | 10 | 0 | 2 | 12 |
| [chatserver/priv/repo/migrations/20250317190709\_messages\_to\_dia.exs](/chatserver/priv/repo/migrations/20250317190709_messages_to_dia.exs) | Elixir | 8 | 0 | 2 | 10 |
| [chatserver/priv/repo/migrations/20250318143506\_create\_dialogues.exs](/chatserver/priv/repo/migrations/20250318143506_create_dialogues.exs) | Elixir | 10 | 0 | 3 | 13 |
| [chatserver/priv/repo/migrations/20250318152156\_message\_table\_onlytext.exs](/chatserver/priv/repo/migrations/20250318152156_message_table_onlytext.exs) | Elixir | 12 | 0 | 2 | 14 |
| [chatserver/priv/repo/migrations/20250318152633\_message\_table\_onlytext\_with\_dia\_id.exs](/chatserver/priv/repo/migrations/20250318152633_message_table_onlytext_with_dia_id.exs) | Elixir | 12 | 0 | 2 | 14 |
| [chatserver/priv/repo/migrations/20250318154159\_message\_read\_default\_false.exs](/chatserver/priv/repo/migrations/20250318154159_message_read_default_false.exs) | Elixir | 8 | 0 | 2 | 10 |
| [chatserver/priv/repo/seeds.exs](/chatserver/priv/repo/seeds.exs) | Elixir | 0 | 11 | 1 | 12 |
| [chatserver/priv/static/images/logo.svg](/chatserver/priv/static/images/logo.svg) | XML | 6 | 0 | 1 | 7 |
| [chatserver/test/chatserver/accounts\_test.exs](/chatserver/test/chatserver/accounts_test.exs) | Elixir | 53 | 0 | 15 | 68 |
| [chatserver/test/chatserver/messages\_test.exs](/chatserver/test/chatserver/messages_test.exs) | Elixir | 49 | 0 | 15 | 64 |
| [chatserver/test/chatserver\_web/channels/chat\_room\_channel\_test.exs](/chatserver/test/chatserver_web/channels/chat_room_channel_test.exs) | Elixir | 22 | 0 | 6 | 28 |
| [chatserver/test/chatserver\_web/controllers/error\_html\_test.exs](/chatserver/test/chatserver_web/controllers/error_html_test.exs) | Elixir | 10 | 1 | 4 | 15 |
| [chatserver/test/chatserver\_web/controllers/error\_json\_test.exs](/chatserver/test/chatserver_web/controllers/error_json_test.exs) | Elixir | 10 | 0 | 3 | 13 |
| [chatserver/test/chatserver\_web/controllers/message\_controller\_test.exs](/chatserver/test/chatserver_web/controllers/message_controller_test.exs) | Elixir | 74 | 0 | 19 | 93 |
| [chatserver/test/chatserver\_web/controllers/page\_controller\_test.exs](/chatserver/test/chatserver_web/controllers/page_controller_test.exs) | Elixir | 7 | 0 | 2 | 9 |
| [chatserver/test/chatserver\_web/controllers/user\_controller\_test.exs](/chatserver/test/chatserver_web/controllers/user_controller_test.exs) | Elixir | 82 | 0 | 19 | 101 |
| [chatserver/test/support/channel\_case.ex](/chatserver/test/support/channel_case.ex) | Elixir | 27 | 2 | 7 | 36 |
| [chatserver/test/support/conn\_case.ex](/chatserver/test/support/conn_case.ex) | Elixir | 29 | 2 | 8 | 39 |
| [chatserver/test/support/data\_case.ex](/chatserver/test/support/data_case.ex) | Elixir | 48 | 0 | 11 | 59 |
| [chatserver/test/support/fixtures/accounts\_fixtures.ex](/chatserver/test/support/fixtures/accounts_fixtures.ex) | Elixir | 22 | 0 | 3 | 25 |
| [chatserver/test/support/fixtures/messages\_fixtures.ex](/chatserver/test/support/fixtures/messages_fixtures.ex) | Elixir | 20 | 0 | 3 | 23 |
| [chatserver/test/test\_helper.exs](/chatserver/test/test_helper.exs) | Elixir | 2 | 0 | 1 | 3 |
| [roadmap.xml](/roadmap.xml) | XML | 52 | 0 | 7 | 59 |

[Summary](results.md) / Details / [Diff Summary](diff.md) / [Diff Details](diff-details.md)