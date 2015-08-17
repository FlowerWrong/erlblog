-module(erlblog_blog_controller, [Req]).
-compile(export_all).


%%
%% 博客首页
%%
index('GET', []) ->
  Posts = boss_db:find(post, []),
  {ok, [{posts, Posts}]}.

%%
%% 关于我们
%%
about('GET', []) ->
  {ok, [{msg, "About Us"}]}.

%%
%% 设计
%%
design('GET', []) ->
  {ok, [{msg, "Design"}]}.

%%
%% 写blog
%%
create('POST', []) ->
  case user_lib:require_login(Req) of
    {redirect, _Url} -> {json, [{error, "Please login"}]};
    {ok, Author} ->
      io:format("~p~n", [Author]),
      Image = Req:post_param("image"),
      Title = Req:post_param("title"),
      Summary = Req:post_param("summary"),
      Content = Req:post_param("markdown"),
      Markdown = Req:post_param("markdown"),
      AuthorId = Author:id,
      NewPost = post:new(id, Image, Title, Summary, Content, Markdown, AuthorId),
      case NewPost:save() of
        {ok, SavedPost}->
          {json, [{post, SavedPost}]};
        {error, Reason}->
          {json, [{error, Reason}]}
      end
  end.


%%
%% 更新
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
%% 单篇博客
%%
show('GET', [Id]) ->
  Post = boss_db:find(Id),
  {ok, [{post, Post}]}.


%%
%% 删除
%%
delete('DELETE', [Id]) ->
	case boss_db:delete(Id) of
		ok->
			{json, [{msg, "ok"}]};
		{error, Reason}->
      {json, [{error, Reason}]}
	end.


%%
%% 上传图片 api
%%
uploader('POST', []) ->
  [{sb_uploaded_file, FileName, TempLocation, _Size, _Type, _}] = Req:post_files(),
  Uuid = uuid:to_string(uuid:uuid1()),
  Ext = filename:extension(FileName),
  Fname = "./priv/static/uploader/" ++ Uuid ++ Ext,
  file:copy(TempLocation, Fname),
  file:delete(TempLocation),
  Url = "/static/uploader/" ++ Uuid ++ Ext,
  {json, [{url, Url}]}.
