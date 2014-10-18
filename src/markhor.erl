-module(markhor).

-export([start/0]).

start() ->
    application:start(yamerl),
    application:start(markhor).
