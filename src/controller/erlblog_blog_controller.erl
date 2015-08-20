-module(erlblog_blog_controller, [Req]).
-compile(export_all).


%%
%% 博客首页 page
%%
index('GET', []) ->
  Posts = boss_db:find(post, []),
  case Req:cookie("user_id") of
    undefined -> {ok, [{posts, Posts}]};
    Id ->
      case boss_db:find(Id) of
        undefined -> {ok, [{posts, Posts}]};
        Author ->
          case Author:session_identifier() =:= Req:cookie("session_id") of
            false -> {ok, [{posts, Posts}]};
            true -> {ok, [{posts, Posts}, {current_user, Author}]}
          end
      end
  end.

%%
%% 关于我们 page
%%
about('GET', []) ->
  {ok, [{msg, "About Us"}]}.

%%
%% 设计 page
%%
design('GET', []) ->
  {ok, [{msg, "Design"}]}.

%%
%% 新建 page
%%

%%
%% 新建blog api
%%
create('POST', []) ->
  case user_lib:require_login(Req) of
    {redirect, _Url} -> {json, [{error, "Please login"}]};
    {ok, Author} ->
      Image = Req:post_param("image"),
      Title = Req:post_param("title"),
      Summary = Req:post_param("summary"),
      Content = Req:post_param("markdown"),
      Markdown = Req:post_param("markdown"),

      % 标签
      Tags = Req:post_param("tags"),
      TagList = string:tokens(Tags, ","),

      UserId = Author:id(),
      AuthorId = list_to_integer(UserId -- "author-"),

      NewPost = post:new(id, Image, Title, Summary, Content, Markdown, AuthorId),
      case NewPost:save() of
        {ok, SavedPost}->
          PostId = SavedPost:id(),
          lists:foreach(fun(TagName) ->
            case boss_db:find(tag, [{name, 'equals', TagName}]) of
              [] ->
                Tag = tag:new(id, TagName),
                case Tag:save() of
                  {ok, SavedTag}->
                    TagId = SavedTag:id(),
                    case boss_db:find(post_tag, [{tag_id, 'equals', TagId}, {post_id, 'equals', PostId}]) of
                      [] ->
                        PostTag = post_tag:new(id, TagId, PostId),
                        PostTag:save();
                      [_DbPostTag] -> ok
                    end;
                  {error, Reason}->
                    io:format("~p~n", [Reason])
                end;
              [DbTag] ->
                TagId = DbTag:id(),
                case boss_db:find(post_tag, [{tag_id, 'equals', TagId}, {post_id, 'equals', PostId}]) of
                  [] ->
                    PostTag = post_tag:new(id, TagId, PostId),
                    PostTag:save();
                  [_DbPostTag] -> ok
                end
            end
          end, TagList),
          {json, [{post, SavedPost}]};
        {error, Reason}->
          {json, [{error, Reason}]}
      end
  end.

%%
%% 编辑 page
%%
edit('GET', [Id]) ->
  case user_lib:require_login(Req) of
    {redirect, _Url} -> {json, [{error, "Please login"}]};
    {ok, _Author} ->
      Post = boss_db:find(Id),
      % FIXME N+1 query
      PostTags = Post:post_tags(),
      io:format("~p~n", [PostTags]),
      {ok, [{post, Post}, {post_tags, PostTags}]}
  end.

%%
%% 更新 api
%%
update('PUT', [Id]) ->
  case user_lib:require_login(Req) of
    {redirect, _Url} -> {json, [{error, "Please login"}]};
    {ok, Author} ->
      Post = boss_db:find(Id),

      % 删除所有post tag的表间关系
      % FIXME so ugly
      PostTags = Post:post_tags(),
      lists:foreach(fun(PostTag) ->
        boss_db:delete(PostTag:id())
      end, PostTags),

      Image = Req:post_param("image"),
      Title = Req:post_param("title"),
      Summary = Req:post_param("summary"),
      Markdown = Req:post_param("markdown"),

      Content = erlmarkdown:conv(Markdown),

      UserId = Author:id(),
      AuthorId = list_to_integer(UserId -- "author-"),

      % 标签
      Tags = Req:post_param("tags"),
      TagList = string:tokens(Tags, ","),

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
          PostId = SavedPost:id(),
          lists:foreach(fun(TagName) ->
            % FIXME so ugly
            case boss_db:find(tag, [{name, 'equals', TagName}]) of
              [] ->
                Tag = tag:new(id, TagName),
                case Tag:save() of
                  {ok, SavedTag}->
                    TagId = SavedTag:id(),
                    case boss_db:find(post_tag, [{tag_id, 'equals', TagId}, {post_id, 'equals', PostId}]) of
                      [] ->
                        PostTag = post_tag:new(id, TagId, PostId),
                        PostTag:save();
                      [_DbPostTag] -> ok
                    end;
                  {error, Reason}->
                    io:format("~p~n", [Reason])
                end;
              [DbTag] ->
                TagId = DbTag:id(),
                case boss_db:find(post_tag, [{tag_id, 'equals', TagId}, {post_id, 'equals', PostId}]) of
                  [] ->
                    PostTag = post_tag:new(id, TagId, PostId),
                    PostTag:save();
                  [_DbPostTag] -> ok
                end
            end
          end, TagList),
          {json, [{post, SavedPost}]};
        {error, Reason}->
          {json, [{error, Reason}]}
      end
  end.

%%
%% 单篇博客
%%
show('GET', [Id]) ->
  Post = boss_db:find(Id),
  {ok, [{post, Post}]}.

%%
%% 删除 api
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
