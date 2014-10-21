-module(markhor).

-export([start/0]).

start() ->
    application:start(yamerl),
    markhor_logger_config:start(),
    application:start(markhor).
