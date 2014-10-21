-module(markhor_bid_request).
-compile([{parse_transform, lager_transform}]).
-export([message_handler/1]).

message_handler(Json) ->
    Ref = make_ref(),
    router ! {self(), Ref, bid_request, Json},
    receive 
        {_, bid_price, Price} ->
            {bid_price, Price};

        {_, no_auctions} ->
            lager:info("There were no auction for the received bid request~n"),
            {no_auction}
    after 
        1000 -> 
            lager:info("Timeout waiting for bid price~n"),
            {no_auction}
    end.

