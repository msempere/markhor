-module(markhor_bid_request).
-export([message_handler/1]).

message_handler(Json) ->
    Ref = make_ref(),
    router ! {self(), Ref, bid_request, Json},
    receive 
        {_, bid_price, Price} ->
            {bid_price, Price};

        {_, no_auctions} ->
            io:fwrite("There were no auction~n"),
            {no_auction}
    after 
        2000 -> 
            io:fwrite("Lost bid request~n"),
            {no_auction}
    end.


%%get_id(#agent{creatives = Creatives}, Key) ->
%%    case lists:keyfind(Key, 3, Creatives) of
%%        {_, Id, _} -> {ok, Id};
%%        false   -> false
%%    end.

