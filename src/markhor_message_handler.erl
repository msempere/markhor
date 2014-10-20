-module(markhor_message_handler).

-export([init/3
        , allowed_methods/2
        , content_types_accepted/2
        , content_types_provided/2
        , handle_incomming_post_message/2
        , handle_incomming_get_message/2
        , terminate/3
        , rest_init/2
        ]).

%% Init
init(_Transport, _Req, []) ->
    {upgrade, protocol, cowboy_rest}.


rest_init(Req, []) ->
    {ok, Req, []}.


allowed_methods(Req, State) ->
    {[ <<"GET">>, <<"POST">>], Req, State}.


%% Callbacks
content_types_accepted(Req, State) ->
    {[      
        {<<"application/json">>, handle_incomming_post_message}  
    ], Req, State}.


content_types_provided(Req, State) ->
    {[
        {<<"text/plain">>, handle_incomming_get_message}
     ], Req, State}.


terminate(_Reason, _Req, _State) ->
    ok.


handle_post_message(Body, State) ->
    case markhor_json:parse(Body) of
        {success, Json} -> 
            %%Id = proplists:get_value(<<"id">>, Json); 
            markhor_bid_request:message_handler(Json, State);
        {error, Msg} -> io:fwrite("~p~n",[Msg])
    end.


handle_get_message(Agent, State) ->
    AgentName = binary_to_list(Agent),
    FileContent = markhor_config:load(string:concat(AgentName, ".yaml")),
    markhor_objects:handle_agent_message(AgentName, FileContent, State).


%% API
handle_incomming_get_message(Req, State) ->
    {Agent_name, Req1} = cowboy_req:binding(agent_name, Req),
    io:fwrite("Received petition for Agent ~p~n", [Agent_name]),
    NewState = handle_get_message(Agent_name, State),
    {ok, Req2} = cowboy_req:reply(200, Req),
    {halt, Req2, NewState}.


handle_incomming_post_message(Req, State) ->
    {ok, Value, Req2} = cowboy_req:body(Req),
    case cowboy_req:has_body(Req) of
        true ->
            {ok, Body, Req3} = cowboy_req:body(Req),

            handle_post_message(Body, State),

            {ok, Req4 } = cowboy_req:reply(200, [{<<"Content-Type">>, <<"application/json">>}, {<<"x-openrtb-version">>,<<"2.1">>}], "{\"message\" :\"received bid request\", \"status\" : \"success\" }", Req3 ),
            {halt, Req4, State};
        false ->
            {false, Req, State}
  end.

