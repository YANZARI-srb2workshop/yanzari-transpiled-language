-- Scanner
--- Enums
--- 
--- The Scanner Enums include:
--- Token Types,
--- Comment Sizes,
--- etc.
--> By Yanzari

-- Enum Module
local enum = require("src.libs.enum")

-- Kinds of Tokens
local TokenKinds = enum.new(
    'StartOfFile',
    'String', -- "1"
    'Template', -- `1`
    'Integer', -- 1
    'Float', -- 1.2
    'Exponent', -- 1e2
    'Hexadecimal', -- 0xAA 0xBB
    'Binary', -- 0b00110011
    'Identifier', -- Flower
    'BitString', -- b"hihi"
    'Keyword', -- is
    'Operators', -- +
    'Indent',
    'Dedent',
    'NewLine',
    'Comment', -- //
    'Directive', -- //!
    'Property', -- //$
    'Documentation', -- //@
    'EndOfFile' -- EOF
)

-- Commentary Sizes
local CommentSize = enum.new(
    'Short', -- //
    'Long' -- /* */
)

-- Miscellanious Token Kinds
local MiscellaniousTokenKinds = enum.new(
    'Parentesis',
    'CurlyBrackets',
    'SquareBrackets',
    'Semicolon'
)

-- Operators Token Kinds
local OperatorsTokenKinds = enum.new(
    'Plus', -- +
    'Plus Plus', -- ++
    'Minus', -- -
    'Minus Minus', -- --
    'Asterisk', -- *
    'Slash', -- /
    'Percent', -- %
    'Asterisk Asterisk', -- **
    'Colon', -- :
    'Colon Colon', -- ::
    'Comma', -- ,
    'Dot', -- .
    'VerticalLine', -- |
    'Ampersand', -- &
    'Circumflex', -- ^
    'VerticalLine VerticalLine', -- ||
    'Ampersand Ampersand', -- &&
    'Circumflex Circumflex', -- ^^
    'LessThan', -- <
    'GreaterThan', -- >
    'LessThan LessThan', -- <<
    'GreaterThan GreaterThan', -- >>
    'LessThan Equals', -- <=
    'GreaterThan Equals', -- >=
    'LessThan Equals GreaterThan', -- <=
    'Equals Equals', -- ==
    'Equals', -- =
    'Plus Equals', -- +=
    'Minus Equals', -- -=
    'Asterisk Equals', -- *=
    'Slash Equals', -- /=
    'Percent Equals', -- %=
    'Asterisk Asterisk Equals', -- **=
    'VerticalLine Equals', -- |=
    'Ampersand Equals', -- &=
    'Circumflex Equals', -- ^=
    'Exclamation', -- !
    'Exclamation Equals', -- !=
    'Tilde' -- ~
)

-- Directions of Tokens (e.g. Left Parentesis, Left Curly Brackets)
local TokenDirection = enum.new(
    'Left',
    'Right'
)

-- Module
local Enums = {
    TokenKinds=TokenKinds, -- Kinds of Tokens
    MiscellaniousTokenKinds=MiscellaniousTokenKinds, -- Miscellanious Token Kinds
    OperatorsTokenKinds=OperatorsTokenKinds, -- Operators Token Kinds
    CommentSize=CommentSize, -- Commentary Sizes
    TokenDirection=TokenDirection -- Directions of Tokens (e.g. Left Parentesis, Left Curly Brackets)
}
return Enums