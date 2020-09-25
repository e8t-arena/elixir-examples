% SELECT * FROM test
% SELECT test.id, test.name FROM test
% SELECT * FROM test1, test2
% SELECT test1.id, test2.name FROM test1, test2

Definitions.

KEYWORD = [a-z_]+[a-z_0-9]
WHITESPACE = [\s\t\n\r]
KEYWORD_SUB_ASTERIK = {KEYWORD}+\.\*
KEYWORD_SUB_KEYWORD = {KEYWORD}+\.{KEYWORD}+

Rules.

select\s\*+
    : {token, {select_asterik, TokenLine}}.
select\s{KEYWORD_SUB_KEYWORD}+(\,{WHITESPACE}*{KEYWORD_SUB_KEYWORD}+)*
    : {token, {select_keyword, TokenLine, handle_keyword(TokenChars)}}.
from\s{KEYWORD}+(\,{WHITESPACE}*{KEYWORD}+)*
    : {token, {from, TokenLine, handle_keyword(TokenChars)}}.
{WHITESPACE}+
    : skip_token.

Erlang code.

handle_keyword(Chars) ->
    lists:reverse(lists:droplast(lists:reverse(string:lexemes(Chars, " ,")))).