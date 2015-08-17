-module(erlblog_authors_controller, [Req]).
-compile(export_all).

before_(_) ->
  user_lib:require_login(Req).

%%
%% Users
%%
%% GET users
%%
list('GET', [], Author) ->
  Authors = boss_db:find(author, []),
  {ok, [{authors, Authors}]}.
