-module(markhor_app).

-behaviour(application).

%% Connection Pool Acceptors Macro
-define(C_ACCEPTORS,  100).

%% Application callbacks
-export([start/0, start/2, stop/1, url_mapper/2]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
    application:start(a,a).

start(_StartType, _StartArgs) ->
    application:start(lager),
    application:start(cowboy),
    %% lager:info("Markhor starting"),
    start_http(),
    markhor_sup:start_link().

start_http() ->
    Routes = routes(),
    Dispatch = cowboy_router:compile(Routes), 
    Port = port(),
    TransOpts = [{port, Port},{max_connections, 2048}],
    ProtoOpts = [{env, [{dispatch, Dispatch}]},
                    {onrequest, fun request_hook_responder:set_cors/1},
                    {onresponse, fun error_hook_responder:respond/4}
                ],    
    {ok, _}   = cowboy:start_http(http, ?C_ACCEPTORS, TransOpts, ProtoOpts).

routes() ->
    [
        {"api.localhost",[
                {"/v0.1/bid_request", bid_request_handler, []}
             ]
        }
    ]
.

port() ->
    case application:get_env(http_port) of
        {ok, Port} -> Port;
        undefined -> 5544
    end.

url_mapper(Version, Verb) ->
    string:join(["/v",Version,"/",Verb ],"") 
.

stop(_State) ->
    application:stop(lager),
    application:stop(cowboy),
    ok.
