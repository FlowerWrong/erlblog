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


% "4e83a4f4f90a28a12a06e0c535b13727" "yangfusheng"
% "963b4fdae702bc7e83e6fe52769f381a" "123456"
check_password(PasswordPlain) ->
  Salt = mochihex:to_hex(erlang:md5(Username)),
  UserPass = user_lib:hash_password(PasswordPlain, Salt),
  UserPass =:= binary:bin_to_list(Password).

login_cookies() ->
  [ mochiweb_cookies:cookie("user_id", Id, [{path, "/"}]),
    mochiweb_cookies:cookie("session_id", session_identifier(), [{path, "/"}]) ].