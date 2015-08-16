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
  Image = Req:post_param("image"),
	Title = Req:post_param("title"),
  Summary = Req:post_param("title"),
	Content = Req:post_param("content"),
  Markdown = Req:post_param("content"),
	AuthorId = Req:post_param("author_id"),
	CreatedAt = erlang:now(),
	NewPost = post:new(id, Image, Title, Summary, Content, Markdown, AuthorId),
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
  Image = Req:post_param("image"),
	Title = Req:post_param("title"),
  Summary = Req:post_param("title"),
	Content = Req:post_param("content"),
  Markdown = Req:post_param("content"),
	AuthorId = Req:post_param("author_id"),
  NewPost = Post:set([
    {image, Image},
    {title, Title},
    {summary, Summary},
    {content, Content},
    {markdown, Markdown},
    {author_id, AuthorId}
  ]),
	case NewPost:save() of
		{ok, SavedPost}->
			{json, [{post, SavedPost}]};
		{error, Reason}->
      {json, [{error, Reason}]}
	end.


%%
%% Post
%%
%% GET post
show('GET', [Id]) ->
  Post = boss_db:find(Id),
  {ok, [{post, Post}]}.


%%
%% Post
%%
%% DELETE blog
%%
delete('DELETE', [Id]) ->
	case boss_db:delete(Id) of
		ok->
			{json, [{msg, "ok"}]};
		{error, Reason}->
      {json, [{error, Reason}]}
	end.


%%
%% Uploader image api
%%
uploader('POST', []) ->
  [{sb_uploaded_file, FileName, TempLocation, _Size, _Type, _}] = Req:post_files(),
  Fname = "./priv/static/uploader/" ++ FileName,
  file:copy(TempLocation, Fname),
  file:delete(TempLocation),
  Url = "/static/uploader/" ++ FileName,
  {json, [{url, Url}]}.
