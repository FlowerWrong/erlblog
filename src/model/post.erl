-module(post, [Id, Image, Title, Summary, Content, Markdown, AuthorId]).
-compile(export_all).

-has({post_tags, many}).

%% validation_tests() ->
%%   [{fun() -> length(Title) > 0 end,
%%     "请输入标题"},
%%     {fun() -> length(Markdown) > 0 end,
%%       "请输入markdown内容"}].