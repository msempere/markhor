-module(markhor_bid_request).
-export([message_handler/2]).

message_handler(Json, State) ->
    Imp = proplists:get_value(<<"imp">>, Json),
    Height = proplists:get_value(<<"h">>, proplists:get_value(<<"banner">>, hd(Imp))),
    Wight = proplists:get_value(<<"w">>, proplists:get_value(<<"banner">>, hd(Imp))),
    %%io:fwrite("~p~n",[get_id(hd(State), {Height, Wight})]),
    ok.


%%get_id(#agent{creatives = Creatives}, Key) ->
%%    case lists:keyfind(Key, 3, Creatives) of
%%        {_, Id, _} -> {ok, Id};
%%        false   -> false
%%    end.

