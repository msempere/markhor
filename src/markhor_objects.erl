-module(markhor_objects).
-author("msempere").
-export_type([agent/0, creative/0]).
-export([new_agent/3, new_creative/6, handle_agent_message/3]).


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


new_creative(I, W, H, Adi, Ado, N) when is_integer(I), is_integer(W), is_integer(H), is_atom(Adi), is_atom(Ado), is_atom(N) ->
    new_creative_creator(I, W, H, Adi, Ado, N).


new_creative_creator(I, W, H, Adi, Ado, N) ->
    #creative_object{id=I, width=W, height=H, adid=Adi, adomain=Ado, nurl=N}.


%%agent constructor
-spec new_agent(Bidprice::float(), Name::atom(), Creatives::list()) -> agent().


new_agent(N, P, C) when is_atom(N), is_float(P), is_list(C) ->
    new_agent_creator(N, P, C).


new_agent_creator(N, P, C) ->
    #agent_object{name=N, bidprice=P, creatives=C}.


%%add_creative(A = #agent_object{creatives=Creatives}, C) ->
%%    #agent_object{id=A#agent_object.id, name=A#agent_object.name, bidprice=A#agent_object.bidprice, creatives=[C|Creatives]}.


handle_agent_message(AgentName, FileContent, Agents) ->
    ok.




