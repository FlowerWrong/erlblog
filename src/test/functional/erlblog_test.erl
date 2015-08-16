-module(erlblog_test).
-compile(export_all).

start() ->
  boss_web_test:get_request("/posts", [], [ fun boss_assert:http_ok/1 ], []).

create_post() ->
  boss_web_test:post_request("/posts/create", [],
    [{title, "test_title_1"}, {content, "test_content_1"}, {author_id, 1}],
    [ fun boss_assert:http_ok/1 ], []).
