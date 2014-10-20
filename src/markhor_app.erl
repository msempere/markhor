-module(markhor_app).

-behaviour(application).

%% Connection Pool Acceptors Macro
-define(C_ACCEPTORS,  100).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================
start(_StartType, _StartArgs) ->
    ok = markhor_cowboy:start(),
    
    %% started router. Name is registered as "router"
    register(router, spawn_link(markhor_router, init, [])),

    markhor_sup:start_link().


stop(_State) ->
    ok.
