-module(agent).
-author("msempere").
-export_type([agent/0]).
-export([new/3, add_creative/2, new/4]).


-record(agent_object, {
          id :: integer(),
          name :: atom(),
          bidprice :: float(),
          creatives :: []
         }).

-opaque agent() :: #agent_object{}.

%%agent constructor
-spec new(Id::integer(), Bidprice::float(), Name::atom()) -> agent().

new(I, N, P) when is_integer(I), is_atom(N), is_float(P) ->
    new_agent(I, N, P).

new(I, N, P, C) when is_integer(I), is_atom(N), is_float(P), is_list(C) ->
    new_agent(I, N, P, C).

new_agent(I, N, P) ->
    #agent_object{id=I, name=N, bidprice=P, creatives=[]}.

new_agent(I, N, P, C) ->
    #agent_object{id=I, name=N, bidprice=P, creatives=C}.

add_creative(A = #agent_object{creatives=Creatives}, C) ->
    #agent_object{id=A#agent_object.id, name=A#agent_object.name, bidprice=A#agent_object.bidprice, creatives=[C|Creatives]}.




