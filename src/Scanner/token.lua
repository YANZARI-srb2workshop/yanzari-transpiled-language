-- Scanner
--- Token
--- 
--- This module handles the tokens.
--> By Yanzari

-- A module that handles intervals.
local Span = require('src.Scanner.span')

-- Kind of a Token
---@class TokenKind
---@field category enum_value Token Category
---@field miscellaneous enum_value? Miscellaneous token category.
---@field operator enum_value? Token Operator Category
---@field size enum_value? Comment Size (used only for Comment Token)
---@field direction enum_value? Token Direction (used only for parentheses, braces, and brackets)

-- Token
---@class Token
---@field kind TokenKind
---@field token byte[]? The Token Content
---@field location {start: Span, end: Span} the Token Location
---@field extra any? Extra content for Token
local Token = {}
Token.__index = Token

-- Create a Token
---@param options Token
---@return Token self
function Token.new(options)
	-- Type Checking
	assert(type(options)=='table','Options is not a Token Interface')
	assert(type(options.kind)=='table','Options.kind is not a TokenKind')
	assert(type(options.kind.category)=='number','Options.kind.category is not a Number')
	if options.kind.miscellaneous~=nil then
		assert(type(options.kind.miscellaneous)=='number','Options.kind.miscellaneous is not a Number')
	end
	if options.kind.direction~=nil then
		assert(type(options.kind.direction)=='number','Options.kind.direction is not a Number')
	end
	if options.kind.operator~=nil then
		assert(type(options.kind.operator)=='number','Options.kind.operator is not a Number')
	end
	if options.kind.size~=nil then
		assert(type(options.kind.size)=='number','Options.kind.size is not a Number')
	end
	if options.token~=nil then
		assert(type(options.token)=='table','Options.token is not a byte array')
	end
	assert(type(options.location)=='table','Options.location is not a Span Group')
	assert(type(options.location.start)=='table','Options.location.start is not a Span')
	assert(type(options.location['end'])=='table','Options.location.end is not a Span')
	assert(getmetatable(options.location.start)==Span,'Options.location.start is not a Span')
	assert(getmetatable(options.location['end'])==Span,'Options.location.end is not a Span')
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