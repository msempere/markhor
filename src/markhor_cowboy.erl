-module(markhor_cowboy).
-export([start/0]).
-compile([{parse_transform, lager_transform}]).
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
    lager:info("Markhor started and listening on port ~p~n",[Port]),
    ok.

routes() ->
    [
         {'_', [
                {"/bid_request", markhor_message_handler, []},
                {"/agent/:agent_name", markhor_message_handler,[]}
               ]
         }
    ]
.

port() ->
    case application:get_env(http_port) of
        {ok, Port} -> Port;
        undefined -> 
            lager:info("Port not set using env:http_port. Using default port 5544 instead~n"),
            5544
    end.
