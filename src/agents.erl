-module(agents).
-author("msempere").
-export([add_agent/2, add_creative/3]).

-record(creative,{width,
                  height}).

-record(agent,{name,
               creatives=[]}).


add_agent(agent = #agent{name = Name}, Dataset) -> 
    lists:keystore(Name, #agent.name, Dataset, agent). 

add_creative(agent = #agent{name = agentName}, Creative = #creative{}, Datase) -> 
    lists:append(agent#agent.creatives, [Creative#creative{}]).



