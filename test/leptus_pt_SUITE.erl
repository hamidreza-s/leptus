-module(leptus_pt_SUITE).

-export([all/0]).
-export([pt/1]).


all() ->
    [pt].

pt(_) ->
    ["/", "/hello", "/hello/:name"] = pt1:routes(),
    ["/1", "/2", "/3", "/4"] = pt2:routes().