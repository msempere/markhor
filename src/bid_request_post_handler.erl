-module(bid_request_post_handler).

-export([init/3]).
-export([allowed_methods/2]).
-export([content_types_accepted/2]).
-export([post_json/2]).
-export([terminate/3]).

%% Init
init(_Transport, _Req, []) ->
    {upgrade, protocol, cowboy_rest}.

allowed_methods(Req, State) ->
    {[ <<"POST">>], Req, State}.


%% Callbacks
content_types_accepted(Req, State) ->
    {[      
        {<<"application/json">>, post_json}  
    ], Req, State}.

terminate(_Reason, _Req, _State) ->
    ok.

%% API
post_json(Req, State) ->
    io:fwrite("JSON Posted~n"),
    {ok, Value, Req2} = cowboy_req:body(Req),
    case cowboy_req:has_body(Req) of
    true ->
      {ok, Body, Req2} = cowboy_req:body(Req),
      io:fwrite("~p~n", [Body]),
      {ok, Req3 } = cowboy_req:reply(200, [{<<"Content-Type">>, <<"application/json">>}, {<<"x-openrtb-version">>,<<"2.1">>}], "{\"message\" : \"posted_a_message\", \"status\" : \"success\" }", Req2 ),
      {halt, Req3, State};
    false ->
      {false, Req, State}
  end.

