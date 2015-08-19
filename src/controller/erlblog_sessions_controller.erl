%%%-------------------------------------------------------------------
%%% @author yy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 八月 2015 上午11:27
%%%-------------------------------------------------------------------
-module(erlblog_sessions_controller, [Req]).
-author("yy").

%% API
-compile(export_all).


%%
%% 登陆 page
%%
login('GET', []) ->
  {ok, [{redirect, Req:header(referer)}]};

%%
%% 登陆
%%
login('POST', []) ->
  Name = Req:post_param("username"),
  case boss_db:find(author, [{username, Name}], [{limit,1}]) of
    [Author] ->
      case Author:check_password(Req:post_param("password")) of
        true ->
          {redirect, proplists:get_value("redirect",
            Req:post_params(), "/"), Author:login_cookies()};
        false ->
          {ok, [{error, "Bad name/password combination"}]}
      end;
    [] ->
      {ok, [{error, "No Author named " ++ Name}]}
  end.


%%
%% 登出
%%
logout('GET', []) ->
  {redirect, "/login",
  [ mochiweb_cookies:cookie("user_id", "", [{path, "/"}]),
    mochiweb_cookies:cookie("session_id", "", [{path, "/"}]) ]}.
