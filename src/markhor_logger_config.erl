-module(markhor_logger_config).
-author("msempere").
-export([start/0]).


-define(HANDLERS, 
    [{lager_console_backend, info},
     {lager_file_backend, [{file, "log/error.log"},   {level, error}, {size, 10485760}, {date, "$D0"}, {count, 5}]},
     {lager_file_backend, [{file, "log/console.log"}, {level, info}, {size, 10485760}, {date, "$D0"}, {count, 5}]}]).

start() ->
    start_lager(),
    ok.

start_lager() ->
    application:load(lager),
    application:set_env(lager, handlers, ?HANDLERS),
    application:set_env(lager, error_logger_redirect, false),
    application:start(lager),
    application:ensure_all_started(lager),
    ok.
