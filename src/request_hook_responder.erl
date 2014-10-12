-module(request_hook_responder).
-export([set_cors/1]).

%% Enable CORS . 
%% Every incoming request is intercepted and its response headers are set here.
set_cors(Req) ->
    HostInfo = cowboy_req:host_info(Req),
    erlang:display(HostInfo),
    Req1 = cowboy_req:set_resp_header(<<"access-control-allow-methods">>, <<"GET, PUT, POST, DELETE, OPTIONS">>, Req),
    Req2 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req1),
    Req3 = cowboy_req:set_resp_header(<<"access-control-allow-headers">>, <<"Origin, X-Requested-With, Content-Type, Accept">>, Req2),
    Req4 = cowboy_req:set_resp_header(<<"server">>, <<"markhor">>, Req3),
    Req4
.
