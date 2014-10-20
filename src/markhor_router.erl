-module(markhor_router).
-author("msempere").
-export([init/0]).

init() ->
    io:fwrite("Started Router~n"),
    loop([]).

loop(Agents) ->
    receive
        {From, Ref, bid_request} ->
            io:fwrite("Router received bid request~n"),
            loop(Agents);
        {From, Ref, Agent} ->
            io:fwrite("Router received new agent~n"),
            loop(Agents)
    end.

