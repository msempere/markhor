-module(json).
-author("msempere").
-export([parse/1]).

parse(RawMessage) ->
  case jsx:is_json(RawMessage) of
    true -> {success, do_parse_json(RawMessage)};
    false -> {error, invalid_json}
  end.

do_parse_json(JsonMessage) ->
  Message = jsx:decode(JsonMessage),
  io:fwrite("Parsed json: ~tp~n", [Message]),
  Message.
