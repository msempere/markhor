-module(markhor_router).
-compile([{parse_transform, lager_transform}]).
-author("msempere").
-export([init/0]).

init() ->
    lager:info("Started Router"),
    loop([]).

loop(Agents) ->
    receive
        {From, Ref, bid_request, Json} ->

            Imp = proplists:get_value(<<"imp">>, Json),
            Height = proplists:get_value(<<"h">>, proplists:get_value(<<"banner">>, hd(Imp))),
            Width = proplists:get_value(<<"w">>, proplists:get_value(<<"banner">>, hd(Imp))),
            RightAgents = markhor_objects:right_agents(Agents, Height, Width),
            
            case length(RightAgents) > 0 of
                true ->
                    {Price, _} = lists:last(RightAgents),
                    From ! {Ref, bid_price, Price},
                    lager:info("Someone is interested offering ~p~n",[Price]),
                    loop(Agents);
                false ->
                    lager:info("There isn't anyone interested on that bid request"),
                    From ! {Ref, no_auctions},
                    loop(Agents)
            end;

        {From, Ref, agent, AgentName, FileContent} ->
            From ! {Ref, ok_agent},
            lager:info("Received petition for agent ~p~n",[AgentName]),
            case markhor_objects:agent_in_list(AgentName, Agents) of
                true ->
                    lager:warning("Agent ~p already exist~n",[AgentName]),
                    loop(Agents);
                false ->
                    Agent = markhor_objects:yaml_to_agent(FileContent),
                    lager:info("Agent ~p added correctly~n",[AgentName]),
                    loop([Agent|Agents])
            end
    end.

