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
	'Octal', -- 0o001
	'Identifier', -- Flower
	'BitString', -- b"hihi"
	'Keyword', -- is
	'Operator', -- +
	'JSXTag', -- <example> </example>
	'Indent',
	'Dedent',
	'NewLine',
	'Comment', -- //
	'Directive', -- //!
	'Property', -- //$
	'Documentation', -- //@
	'Miscellaneous', -- Miscellaneous token category.
	'EndOfFile' -- EOF
)

-- Commentary Sizes
local CommentSize = enum.new(
	'Short', -- //
	'Long' -- /* */
)

-- some extra types of tokens
local MiscellaneousTokenKinds = enum.new(
	'Parentesis',
	'CurlyBracket',
	'SquareBracket',
	'Semicolon'
)

-- Types of Operators
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
	'LessThan LessThan Equals', -- <<=
	'GreaterThan GreaterThan', -- >>
	'GreaterThan GreaterThan Equals', -- >>=
	'LessThan Equals', -- <=
	'GreaterThan Equals', -- >=
	'LessThan Equals GreaterThan', -- <=>
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
	'Tilde', -- ~
	'Custom'
)

-- Directions of Tokens (e.g. Left Parentesis, Left Curly Brackets)
local TokenDirection = enum.new(
	'Left',
	'Right'
)

-- Module
local Enums = {
	TokenKinds=TokenKinds, -- Kinds of Tokens
	MiscellaneousTokenKinds=MiscellaneousTokenKinds, -- some extra types of tokens
	OperatorsTokenKinds=OperatorsTokenKinds, -- Types of Operators
	CommentSize=CommentSize, -- Commentary Sizes
	TokenDirection=TokenDirection -- Directions of Tokens (e.g. Left Parentesis, Left Curly Brackets)
}

-- Export
return Enums