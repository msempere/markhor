-module(markhor_agent_request).
-compile([{parse_transform, lager_transform}]).
-author(msempere).
-export([message_handler/2]).

message_handler(AgentName, FileContent) ->

    Ref = make_ref(),
    router ! {self(), Ref, agent, AgentName, FileContent},
    receive 
        {Ref, ok_agent} ->
            lager:info("Petition for creating agent ~p received correctly~n", [AgentName])
    after 
        1000 -> 
            lager:info("Timeout while waiting for the agent creating reponse back~n")
    end,
    ok.
