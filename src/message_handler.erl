-module(message_handler).

-export([init/3
        , allowed_methods/2
        , content_types_accepted/2
        , handle_incomming_message/2
        , terminate/3
        , rest_init/2
        ]).


%% Init
init(_Transport, _Req, []) ->
    {upgrade, protocol, cowboy_rest}.

rest_init(Req, []) ->
    {ok, Req, [{"hola"}]}.


allowed_methods(Req, State) ->
    {[ <<"POST">>], Req, State}.


%% Callbacks
content_types_accepted(Req, State) ->
    {[      
        {<<"application/json">>, handle_incomming_message}  
    ], Req, State}.


terminate(_Reason, _Req, _State) ->
    ok.


handle_message(Body, State) ->
    case json:parse(Body) of
        {success, Json} -> 
            %%Id = proplists:get_value(<<"id">>, Json); 
            bid_handler:message_handler(Json, State);
        {error, Msg} -> io:fwrite("~p~n",[Msg])
    end.


%% API
handle_incomming_message(Req, State) ->
    io:fwrite("Received JSON message~n"),
    {ok, Value, Req2} = cowboy_req:body(Req),
    case cowboy_req:has_body(Req) of
        true ->
            {ok, Body, Req2} = cowboy_req:body(Req),
            spawn(fun() -> handle_message(Body, State) end),
            {ok, Req3 } = cowboy_req:reply(200, [{<<"Content-Type">>, <<"application/json">>}, {<<"x-openrtb-version">>,<<"2.1">>}], "{\"message\" :\"received bid request\", \"status\" : \"success\" }", Req2 ),
            {halt, Req3, State};
        false ->
            {false, Req, State}
  end.

