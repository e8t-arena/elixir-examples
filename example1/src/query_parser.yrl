Nonterminals query select_clause from_clause.

Terminals select_asterik select_keyword from.

Rootsymbol query.

query -> select_clause from_clause : ['$1', '$2'].

select_clause -> select_asterik : ['select', 'all'].

select_clause -> select_keyword : ['select', extract_token('$1')].

from_clause -> from : ['from', extract_token('$1')].

Erlang code.

% extract the value from a token
extract_token({_Token, _Line, Value}) -> Value.