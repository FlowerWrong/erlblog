-module(author, [Id, Username, Password, Avatar]).
-compile(export_all).

-has({posts, many}).

validation_tests() ->
  [{fun() -> length(Username) > 0 end,
    "请输入用户名"},
    {fun() -> length(Password) > 0 end,
      "请输入密码"}].

-define(SECRET_STRING, "erlblog").

session_identifier() ->
  mochihex:to_hex(erlang:md5(?SECRET_STRING ++ Id)).

check_password(Password) ->
  Salt = mochihex:to_hex(erlang:md5(Username)),
  user_lib:hash_password(Password, Salt) =:= Password.

login_cookies() ->
  [ mochiweb_cookies:cookie("user_id", Id, [{path, "/"}]),
    mochiweb_cookies:cookie("session_id", session_identifier(), [{path, "/"}]) ].