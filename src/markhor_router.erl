-module(markhor_router).
-author("msempere").
-export([init/0]).

init() ->
    io:fwrite("Started Router~n"),
    loop([]).

loop(Agents) ->
    receive
        {From, Ref, bid_request, Json} ->
            io:fwrite("Router received bid request"),

            Imp = proplists:get_value(<<"imp">>, Json),
            Height = proplists:get_value(<<"h">>, proplists:get_value(<<"banner">>, hd(Imp))),
            Width = proplists:get_value(<<"w">>, proplists:get_value(<<"banner">>, hd(Imp))),
            RightAgents = markhor_objects:right_agents(Agents, Height, Width),
            
            case length(RightAgents) > 0 of
                true ->
                    {Price, _} = lists:last(RightAgents),
                    From ! {Ref, bid_price, Price},
                    loop(Agents);
                false ->
                    From ! {Ref, no_auctions},
                    loop(Agents)
            end;

        {From, Ref, agent, AgentName, FileContent} ->
            From ! {Ref, ok_agent},
            io:fwrite("Router received new agent: ~p~n",[AgentName]),
            case markhor_objects:agent_in_list(AgentName, Agents) of
                true ->
                    io:fwrite("Agent already exist~n"),
                    loop(Agents);
                false ->
                    Agent = markhor_objects:yaml_to_agent(FileContent),
                    loop([Agent|Agents])
            end
    end.

