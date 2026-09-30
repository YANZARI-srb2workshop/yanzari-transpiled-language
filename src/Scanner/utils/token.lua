-- Scanner
--- Token
--- 
--- This module handles the tokens.
--> By Yanzari

-- A module that handles intervals.
local Span = require('src.Scanner.utils.span')

-- Kind of a Token
---@class TokenKind
---@field category enum_value Token Category
---@field keyword enum_value? the keyword category for a Token (for keywords only).
---@field miscellaneous enum_value? Miscellaneous token category.
---@field operator enum_value? Token Operator Category
---@field size enum_value? Comment Size (used only for Comment Token)
---@field direction enum_value? Token Direction (used only for parentheses, braces, and brackets)

-- a class that handles Scanner tokens.
---@class Token
---@field kind TokenKind the token kind
---@field token byte[]? the token content
---@field location {start: Span, end: Span} the location of the token.
---@field extra any? Extra content for a token; for cases requiring the storage of additional information that a standard token does not hold.
local Token = {}
Token.__index = Token

-- Create a Token
---@param options Token an interface that you pass to the function, which returns a token.
---@return Token token a token.
function Token.new(options)
	-- Type Checking
	assert(type(options)=='table','Options must be a Token Interface')
	assert(type(options.kind)=='table','Options.kind must be a TokenKind')
	assert(type(options.kind.category)=='number','Options.kind.category must be a Number')
	if options.kind.miscellaneous~=nil then
		assert(type(options.kind.miscellaneous)=='number','Options.kind.miscellaneous must be a Number')
	end
	if options.kind.direction~=nil then
		assert(type(options.kind.direction)=='number','Options.kind.direction must be a Number')
	end
	if options.kind.keyword~=nil then
		assert(type(options.kind.keyword)=='number','Options.kind.keyword must be a Number')
	end
	if options.kind.operator~=nil then
		assert(type(options.kind.operator)=='number','Options.kind.operator must be a Number')
	end
	if options.kind.size~=nil then
		assert(type(options.kind.size)=='number','Options.kind.size must be a Number')
	end
	if options.token~=nil then
		assert(type(options.token)=='table','Options.token must be a byte array')
	end
	assert(type(options.location)=='table','Options.location must be a Span Group')
	assert(type(options.location.start)=='table','Options.location.start must be a Span')
	assert(type(options.location['end'])=='table','Options.location.end must be a Span')
	assert(getmetatable(options.location.start)==Span,'Options.location.start must be a Span')
	assert(getmetatable(options.location['end'])==Span,'Options.location.end must be a Span')
	---------------------------------------------------------------------

	local self = setmetatable({},Token)
	self.kind = options.kind
	self.token = options.token
	self.location = options.location
	self.extra = options.extra
	return self
end

-- Export
return Token