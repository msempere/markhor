-module(markhor_cowboy).
-export([start/0]).
-author("msempere").

start() ->
    application:start(crypto),
    application:start(ranch),
    application:start(cowboy),
    application:ensure_all_started(cowboy),
    Routes = routes(),
    Dispatch = cowboy_router:compile(Routes), 
    Port = port(),
    {ok, _}   = cowboy:start_http(http, 100, [{port, Port}], [{env, [{dispatch, Dispatch}]}]),
    io:fwrite("Markhor listening on port ~p~n",[Port]),
    ok.

routes() ->
    [
         {'_', [
                {"/", message_handler, []}
               ]
         }
    ]
.

port() ->
    case application:get_env(http_port) of
        {ok, Port} -> Port;
        undefined -> 5544
    end.
