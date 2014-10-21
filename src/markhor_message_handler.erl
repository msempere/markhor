-module(markhor_message_handler).
-compile([{parse_transform, lager_transform}]).

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
            markhor_bid_request:message_handler(Json);
        {error, Msg} ->
            lager:error("Error on POST Request: ~p~n",[Msg])
    end.


handle_get_message(Agent, State) ->
    AgentName = binary_to_list(Agent),
    FileContent = markhor_config:load(string:concat(AgentName, ".yaml")),
    markhor_agent_request:message_handler(AgentName, FileContent).


%% API
handle_incomming_get_message(Req, State) ->
    {Agent_name, Req1} = cowboy_req:binding(agent_name, Req),
    lager:info("Received petition for Agent ~p~n", [Agent_name]),
    NewState = handle_get_message(Agent_name, State),
    {ok, Req2} = cowboy_req:reply(200, Req),
    {halt, Req2, NewState}.


handle_incomming_post_message(Req, State) ->
    {ok, Value, Req2} = cowboy_req:body(Req),
    case cowboy_req:has_body(Req) of
        true ->
            {ok, Body, Req3} = cowboy_req:body(Req),
            lager:info("Received bid request"),

            Response = handle_post_message(Body, State),
            case Response of
                {_} ->
                    {ok, Req4} = cowboy_req:reply(200, [{<<"Content-Type">>, <<"application/json">>}, {<<"x-openrtb-version">>,<<"2.1">>}], "{}", Req3 );
                {bid_price, Price} ->
                    {ok, Req4 } = cowboy_req:reply(200, [{<<"Content-Type">>, <<"application/json">>}, {<<"x-openrtb-version">>,<<"2.1">>}], string:concat(string:concat("{\"message\" : ", float_to_list(Price, [{decimals, 3}])), "}"), Req3 )
            end,
            {halt, Req4, State};
        false ->
            lager:warning("Received POST request without body"),
            {false, Req, State}
  end.

