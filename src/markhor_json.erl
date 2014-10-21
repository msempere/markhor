-module(markhor_json).
-compile([{parse_transform, lager_transform}]).
-author("msempere").
-export([parse/1]).

parse(RawMessage) ->
  case jsx:is_json(RawMessage) of
    true -> {success, do_parse_json(RawMessage)};
    false -> 
          lager:error("Invalid Json while parsing"),
          {error, invalid_json}
  end.

do_parse_json(JsonMessage) ->
  Message = jsx:decode(JsonMessage),
  Message.
