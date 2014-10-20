-module(markhor_router).
-author("msempere").
-export([init/0]).

init() ->
    io:fwrite("Started Router~n"),
    loop([]).

loop(Agents) ->
    receive
        {From, Ref, bid_request, Json} ->
            From ! {Ref, ok_bid_request},
            io:fwrite("Router received bid request:~n~p~n",[Json]),
            loop(Agents);

        {From, Ref, agent, Agent} ->
            From ! {Ref, ok_agent},
            io:fwrite("Router received new agent:~n~p~n",[Agent]),
            case markhor_objects:agent_in_list(Agent, Agents) of
                true ->
                    io:fwrite("Agent already exist~n"),
                    loop(Agents);
                false ->
                    loop([Agent|Agents])
            end
    end.

