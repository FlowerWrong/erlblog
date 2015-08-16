-module(erlblog_authors_controller, [Req]).
-compile(export_all).

%%
%% Users
%%
%% GET users
%%
list('GET', []) ->
  Authors = boss_db:find(author, []),
  {ok, [{authors, Authors}]}.
