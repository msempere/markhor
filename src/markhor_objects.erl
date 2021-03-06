-module(markhor_objects).
-author("msempere").
-export_type([agent/0, creative/0]).
-export([new_agent/4, new_creative/6, yaml_to_agent/1, agent_in_list/2, right_agents/3]).


-record(creative_object, {
          id    :: integer(),
          width :: integer(),
          height :: integer(),
          adid  :: atom(),
          adomain :: atom(),
          nurl  :: atom()
         }).

-record(agent_object, {
          name :: atom(),
          iurl :: atom(),
          bidprice :: float(),
          creatives :: []
         }).


-opaque agent() :: #agent_object{}.

-opaque creative() :: #creative_object{}.


%%creative constructor
-spec new_creative(Id::integer(), Width::integer(), Height::integer(), Adid::atom(), Adomain::atom(), Nurl::atom()) -> creative(). 


new_creative(I, W, H, Adi, Ado, N) when is_integer(I), is_integer(W), is_integer(H), is_list(Adi), is_list(Ado), is_list(N) ->
    new_creative_creator(I, W, H, Adi, Ado, N).


new_creative_creator(I, W, H, Adi, Ado, N) ->
    #creative_object{id=I, width=W, height=H, adid=Adi, adomain=Ado, nurl=N}.


%%agent constructor
-spec new_agent(Bidprice::float(), Name::atom(), Iurl::atom(), Creatives::list()) -> agent().


new_agent(N, P, I, C) when is_list(N), is_float(P), is_list(I), is_list(C) ->
    new_agent_creator(N, P, I, C).


new_agent_creator(N, P, I, C) ->
    #agent_object{name=N, bidprice=P, iurl=I, creatives=C}.


yaml_to_agent(FileContent) ->
    Name = proplists:get_value("name", FileContent),
    BidPrice = proplists:get_value("bid_price", FileContent),
    Iurl = proplists:get_value("iurl", FileContent),
    Creatives = proplists:get_value("creatives", FileContent),
    CS = [
          new_creative(
              proplists:get_value("id", C), 
              proplists:get_value("width", C), 
              proplists:get_value("height", C), 
              proplists:get_value("adid", C), 
              proplists:get_value("adomain", C), 
              proplists:get_value("nurl", C) 
           )|| C <- Creatives
         ],
    new_agent(Name, BidPrice, Iurl, CS).


%% get agents that have the correct creatives
right_agents([], _, _) ->
    [];

right_agents(Agents, Height, Width) ->
    lists:keysort(1, [{Agent#agent_object.bidprice, hd(Creatives)} || Agent <- Agents, length(Creatives=get_right_creatives(Agent#agent_object.creatives, Height, Width)) > 0]).


%% get agent's creatives that have the correct format
get_right_creatives([], _, _) ->
    [];

get_right_creatives(Creatives, Height, Width) ->
    [Creative || Creative <- Creatives, Creative#creative_object.height == Height, Creative#creative_object.width == Width].


agent_in_list(_, []) ->
    false;

agent_in_list(AgentName, List) ->
    case lists:keyfind(AgentName, 2, List) of
         false -> false;
         _ -> true
    end.


