-module(bid_request_post_handler).

-export([init/3]).
-export([allowed_methods/2]).
-export([content_types_accepted/2]).
-export([handle_incomming_message/2]).
-export([terminate/3]).


%% Init
init(_Transport, _Req, []) ->
    {upgrade, protocol, cowboy_rest}.


allowed_methods(Req, State) ->
    {[ <<"POST">>], Req, State}.


%% Callbacks
content_types_accepted(Req, State) ->
    {[      
        {<<"application/json">>, handle_incomming_message}  
    ], Req, State}.


terminate(_Reason, _Req, _State) ->
    ok.


handle_message(Body) ->
    case json:parse(Body) of
        {success, Json} -> 
            Id = proplists:get_value(<<"id">>, Json), 
            io:fwrite("~p~n",[Id]);
        {error, Msg} -> io:fwrite("~p~n",[Msg])
    end.


%% API
handle_incomming_message(Req, State) ->
    io:fwrite("Received JSON message~n"),
    {ok, Value, Req2} = cowboy_req:body(Req),

    case cowboy_req:has_body(Req) of
        true ->
            {ok, Body, Req2} = cowboy_req:body(Req),
            spawn(fun() -> handle_message(Body) end),
            {ok, Req3 } = cowboy_req:reply(200, [{<<"Content-Type">>, <<"application/json">>}, {<<"x-openrtb-version">>,<<"2.1">>}], "{\"message\" :\"received bid request\", \"status\" : \"success\" }", Req2 ),
            {halt, Req3, State};
        false ->
            {false, Req, State}
  end.

