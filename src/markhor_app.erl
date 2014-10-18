-module(markhor_app).

-behaviour(application).

%% Connection Pool Acceptors Macro
-define(C_ACCEPTORS,  100).

%% Application callbacks
-export([start/2, stop/1, url_mapper/2]).

%% ===================================================================
%% Application callbacks
%% ===================================================================
start(_StartType, _StartArgs) ->
    markhor_config:load("basic.yaml"),
    ok = markhor_cowboy:start(),
    markhor_sup:start_link().

url_mapper(Version, Verb) ->
    string:join(["/v",Version,"/",Verb ],"") 
.

stop(_State) ->
    ok.
