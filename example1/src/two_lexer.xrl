Definitions.

D = [0-9]
NONZERODIGIT = [1-9]
O = [0-7]
HEX = [0-9a-fA-F]
UPPER = [A-Z]
LOWER = [a-z]
EQ = (=)
END = (;)
COLON = (:)
SHARP = (#)
WHITESPACE = [\s\t]
TERMINATOR = \n|\r\n|\r
COMMA = ,
Capital = ({UPPER}{LOWER}+)+

PrimitiveType = ({LOWER}+|{UPPER}{LOWER}+)
ComplexType = ({LOWER}+\.{Capital}|{Capital})
VectorPrimitiveType = (V|v)(ector)(<)({PrimitiveType})(>)
VectorComplexType = (V|v)(ector)(<)({ComplexType})(>)

% dialog
% boolFalse
% contacts.link
% storage.fileUnknown
MtpName = ({PrimitiveType}|{PrimitiveType}{Capital}+|{PrimitiveType}\.{PrimitiveType}|{PrimitiveType}\.{PrimitiveType}{Capital}+)
% 1c138d15
% MtpId = ({HEX}\{8\})
MtpId = ({HEX}+)

Rules.
{COMMA} : skip_token.
{WHITESPACE} : skip_token.
{TERMINATOR} : skip_token.
{EQ} : {token, {eq, TokenLine, TokenChars}}.
{MtpName}#{MtpId} : {token, {mtp_name, TokenLine, TokenChars}}.
{MtpName}#{MtpId} : {token, {mtp_name, TokenLine, split_msg_type(TokenChars)}}.
% (flags:#) : {token, {flags_sharp_token, TokenLine, TokenChars}}.
{PrimitiveType} : {token, {primitive_type, TokenLine, TokenChars}}.
{END} : {token, {eol, TokenLine, TokenChars}}.

Erlang code.

split_msg_type(Chars) ->
    string:lexemes(Chars, "#").

% :two_lexer.string('boolFalse#bc799737 = Bool;')
% :two_lexer.string('inputReportReasonOther#e1746d0a text:string = ReportReason;')