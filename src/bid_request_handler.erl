-module(bid_request_handler).
-export([bid_handler/2]).

bid_handler(Json, State) ->
    Id = proplists:get_value(<<"id">>, Json); 
    ok.
