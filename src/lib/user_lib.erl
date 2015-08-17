%%%-------------------------------------------------------------------
%%% @author yy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 八月 2015 上午11:36
%%% https://github.com/ChicagoBoss/ChicagoBoss/wiki/An-Evening-With-Chicago-Boss
%%% https://groups.google.com/forum/#!topic/chicagoboss/DxcEW_LpF5Y
%%%-------------------------------------------------------------------
-module(user_lib).
-author("yy").

%% API
-compile(export_all).

hash_password(Password, Salt) ->
  mochihex:to_hex(erlang:md5(Salt ++ Password)).

hash_for(Name, Password) ->
  Salt = mochihex:to_hex(erlang:md5(Name)),
  hash_password(Password, Salt).

require_login(Req) ->
  case Req:cookie("user_id") of
    undefined -> {redirect, "/login"};
    Id ->
      case boss_db:find(Id) of
        undefined -> {redirect, "/login"};
        Author ->
          case Author:session_identifier() =:= Req:cookie("session_id") of
            false -> {redirect, "/login"};
            true -> {ok, Author}
          end
      end
  end.