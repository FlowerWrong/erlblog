-module(erlblog_test).
-compile(export_all).

start() ->
  boss_web_test:get_request("/posts", [],
    [ fun boss_assert:http_ok/1,
      fun(Res) -> boss_assert:tag_with_text("strong",
        "Rahm says hello!", Res) end ], []).
