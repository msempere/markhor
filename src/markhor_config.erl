-module(markhor_config).
-author("msempere").
-export([load/1, parse_file/1]).


load(Filename) ->
    Privdir = filename:join([filename:dirname(code:which(?MODULE)), "..", "priv"]),
    File = filename:join([Privdir, Filename]),
    io:fwrite("Reading ~p~n",[File]),
    parse_file(File).

parse_file(File) ->
    yamerl_constr:file(File).
