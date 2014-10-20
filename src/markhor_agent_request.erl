-module(markhor_agent_request).
-author(msempere).
-export([message_handler/2]).

message_handler(AgentName, FileContent) ->
    Agent = markhor_objects:yaml_to_agent(FileContent),

    Ref = make_ref(),
    router ! {self(), Ref, agent, Agent},
    receive 
        {Ref, Message} ->
            io:fwrite("Response from the router: ~p~n",[Message])
    after 
        1000 -> 
            io:fwrite("Lost agent request~n")
    end,
    ok.
