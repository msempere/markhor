-module(creative).
-author("msempere").
-export_type([creative_size/0, creative/0]).
-export([new/2]).

-type creative_size() :: {Wight::integer() 
                          , Height::integer()}.

-record(creative_object, {
          id::integer(),
          size::creative_size()
         }).

-opaque creative() :: #creative_object{}.

%%creative constructor
-spec new(Id::integer(), Size::creative_size()) -> creative().

new(I, {W, H}) when is_integer(I), is_integer(W), is_integer(H) ->
    new_creative(I, {W, H}).

new_creative(I, S) ->
    #creative_object{id=I, size=S}.

