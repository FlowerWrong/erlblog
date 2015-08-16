-module(erlblog_blog_controller, [Req]).
-compile(export_all).

%%
%% Posts
%%
%% GET posts
%%
posts('GET', []) ->
  Posts = boss_db:find(post, []),
  {ok, [{posts, Posts}]}.


%%
%% Post
%%
%% POST blog
%%
create('POST', []) ->
	Title = Req:post_param("title"),
  Summary = Req:post_param("title"),
	Content = Req:post_param("content"),
  Markdown = Req:post_param("content"),
	AuthorId = Req:post_param("author_id"),
	CreatedAt = erlang:now(),
	NewPost = post:new(id, Title, Summary, Content, Markdown, AuthorId),
  io:format("~p~n", [NewPost]),
	case NewPost:save() of
		{ok, SavedPost}->
			{json, [{post, SavedPost}]};
		{error, Reason}->
      {json, [{error, Reason}]}
	end.


%%
%% Post
%%
%% PUT blog
%%
update('PUT', [Id]) ->
  Post = boss_db:find(Id),
	Title = Req:post_param("title"),
  Summary = Req:post_param("title"),
	Content = Req:post_param("content"),
  Markdown = Req:post_param("content"),
	AuthorId = Req:post_param("author_id"),
  NewPost = Post:set([
    {title, Title},
    {summary, Summary},
    {content, Content},
    {markdown, Markdown},
    {author_id, AuthorId}
  ]),
	case NewPost:save() of
		{ok, SavedPost}->
      io:format("~p~n", [SavedPost]),
			{json, [{post, SavedPost}]};
		{error, Reason}->
      {json, [{error, Reason}]}
	end.


%%
%% Post
%%
%% GET post
show('GET', [Id]) ->
  io:format("~p~n", [Id]),
  Post = boss_db:find(Id),
  {ok, [{post, Post}]}.


%%
%% Post
%%
%% DELETE blog
%%
delete('DELETE', [Id]) ->
  io:format("~p~n", [Id]),
	case boss_db:delete(Id) of
		ok->
			{json, [{msg, "ok"}]};
		{error, Reason}->
      {json, [{error, Reason}]}
	end.
