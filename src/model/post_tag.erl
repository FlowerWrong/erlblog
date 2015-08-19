%%%-------------------------------------------------------------------
%%% @author yy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 八月 2015 下午5:26
%%%-------------------------------------------------------------------
-module(post_tag, [Id, TagId, PostId]).
-author("yy").

%% API
-compile(export_all).

-belongs_to(post).
-belongs_to(tag).
