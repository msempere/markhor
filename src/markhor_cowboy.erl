-module(markhor_cowboy).
-export([start/0]).
-author("msempere").

%% Connection Pool Acceptors Macro
-define(C_ACCEPTORS,  100).

start() ->
    application:start(crypto),
    application:start(ranch),
    application:start(cowboy),
    application:ensure_all_started(cowboy),
    Routes = routes(),
    Dispatch = cowboy_router:compile(Routes), 
    Port = port(),
    TransOpts = [{port, Port},{max_connections, 2048}],
    ProtoOpts = [{env, [{dispatch, Dispatch}]},
                    {onrequest, fun request_hook_responder:set_cors/1},
                    {onresponse, fun error_hook_responder:respond/4}
                ], 
    {ok, _}   = cowboy:start_http(http, ?C_ACCEPTORS, TransOpts, ProtoOpts),
    io:fwrite("Markhor listening on port ~p~n",[Port]),
    ok.

routes() ->
    [
         {'_', [
                {"/", bid_request_post_handler, []}
               ]
         }
    ]
.

port() ->
    case application:get_env(http_port) of
        {ok, Port} -> Port;
        undefined -> 5544
    end.
