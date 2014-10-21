-module(markhor_config).
-compile([{parse_transform, lager_transform}]).
-author("msempere").
-export([load/1, parse_file/1]).


load(Filename) ->
    Privdir = filename:join([filename:dirname(code:which(?MODULE)), "..", "priv"]),
    File = filename:join([Privdir, Filename]),
    lager:info("Retrieving agent configuration from ~p~n",[File]),
    parse_file(File).

parse_file(File) ->
    case catch yamerl_constr:file(File) of
        [Cfg] ->
            Cfg;
        _Err -> 
            lager:error("File failed to consult ~p~n", [_Err]),
            false
    end.
