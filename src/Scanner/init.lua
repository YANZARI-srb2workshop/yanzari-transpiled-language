-- Scanner
--- 
--- This module will read the content of a text and convert it into tokens.
--- (I will implement the tokenization part soon)
--- 
--- This part is a work in progress.
--> By Yanzari

-- A module that handles intervals.
local Span = require('src.Scanner.span')

-- A module that handles tokens.
local Token = require('src.Scanner.token')

-- a module that handles markers.
local Marker = require('src.Scanner.marker')

-- the module containing the object representation of the source code.
local SourceCode = require('src.SourceCode')

-- Scanner
---@class Scanner
---@field source SourceCode The Source Code
---@field tokens Token[][] a buffer containing all the stored tokens
---@field token byte[]? The Token Content
---@field next byte? The Next Character
---@field current byte? The Current Character
---@field previous byte? The Previous Character
---@field location Span Cursor location
---@field extra any? Expandable content in the Scanner.
---@field current_output_pos number the output buffer position.
local Scanner = {}
Scanner.__index = Scanner

-- Create a New Scanner
---@param source SourceCode The Source Code
---@return Scanner self
function Scanner.new(source)
	-- Type Checking

	assert(getmetatable(source)==SourceCode,"The source is not a Source Code object.")
	----------------------------------------------------------------------------------

	local self = setmetatable({},Scanner)
	self.source = source
	self.tokens = {[1]={}}
	self.token = {}
	self.location = Span.new(1,1)
	self.current_output_pos = 1
	if #source.content.normalized>=1 then
		self.previous = self.source.content.normalized[self.location.line][self.location.col-1]
		self.current = self.source.content.normalized[self.location.line][self.location.col]
		self.next = self.source.content.normalized[self.location.line][self.location.col+1]
	end
	return self
end

-- Advance a Token
---@param limit number? the Advance Limit
function Scanner:advance(limit)
	if self.current==nil then
		return nil
	end
	limit = limit or 1
	for _=1,limit do
		local cur = self.current
		local jumplines = 0
		if cur==nil then
			if self.source.content.normalized[self.location.line+1]==nil then
				break
			end
			jumplines = 1
		end
		self.location = Span.new(self.location.line+jumplines,self.location.col+1)
		self.previous = self.source.content.normalized[self.location.line][self.location.col-1]
		self.current = self.source.content.normalized[self.location.line][self.location.col]
		self.next = self.source.content.normalized[self.location.line][self.location.col+1]
	end
end

-- turn back
---@param marker ScannerMarker a marker to be able to go back
---@return byte char the current character before returning.
function Scanner:back(marker)
	-- Type Checking
	assert(getmetatable(marker)==Marker,'marker is not a Marker')
	-------------------------------------------------------------
	
	self.location = Span.new(marker.line,marker.col)

	-- Old Token
	---@type byte
	local old = self.source.content.normalized[self.location.line][self.location.col]

	self.previous = self.source.content.normalized[self.location.line][self.location.col-1]
	self.current = self.source.content.normalized[self.location.line][self.location.col]
	self.next = self.source.content.normalized[self.location.line][self.location.col+1]
	return old
end

-- Insert a char
---@param char byte? the character to be inserted.
function Scanner:insertChar(char)
	-- Typing Check
	if char~=nil then
		assert(type(char)=='number','char is not a number')
		assert(char < 255 and char > 0, "Invalid Byte")
	end
	------

	if char==nil then
		char = self.current
	end
	table.insert(self.token,char)
end

-- Remove a Inserted char
function Scanner:removeInsertedChar()
	table.remove(self.token)
end

-- Get a Inserted char
---@param offset number? the offset to get the character.
function Scanner:getInsertedChar(offset)
	-- Typing Check
	if offset~=nil then
		assert(type(offset)=='number','offset is not a number')
	end
	------
	if offset == nil then
		return self.token
	end
	return self.token[offset]
end

-- Skip to the Next Output Buffer
function Scanner:skipToTheNextOutputBuffer()
	self.current_output_pos = self.current_output_pos+1
	if self.tokens[self.current_output_pos]==nil then
		self.tokens[self.current_output_pos] = {}
	end
end

-- Skip to the Previous Output Buffer
function Scanner:skipToThePreviousOutputBuffer()
	self.current_output_pos = self.current_output_pos-1
	if self.tokens[self.current_output_pos]==nil then
		self.tokens[self.current_output_pos] = {}
	end
end

-- Emit a Token
---@param kind TokenKind the Token Type.
---@param start_location Span a Location Marker for the Start of Token Insertion
---@param end_location Span a Location Marker for the End of Token Insertion
---@param extra any? Content extendable to a token.
function Scanner:emitToken(kind,start_location,end_location,extra)
	---@type Token
	local TokenNode = Token.new({
		kind=kind,
		token=self.token,
		location={start=start_location,['end']=end_location},
		extra=extra
	})
	table.insert(self.tokens[self.current_output_pos],TokenNode)
end

-- Get a Inserted Token
---@param offset number? the offset to get the Token.
function Scanner:getInsertedToken(offset)
	-- Typing Check
	if offset~=nil then
		assert(type(offset)=='number','offset is not a number')
	end
	------
	if offset == nil then
		return self.tokens[self.current_output_pos]
	end
	return self.tokens[self.current_output_pos][offset]
end

-- return the current location of the token.
---@return Span currentLocation current location of the token.
function Scanner:returnLocation()
	return Span.new(self.location.line,self.location.col+1)
end

-- match a char
---@param the_char_used_for_match byte?  The Character Used For Matching
---@param the_char_to_match byte The Character to Matching
---@return boolean result the result of the match.
function Scanner:matchAChar(the_char_used_for_match,the_char_to_match)
	if the_char_used_for_match==nil then
		the_char_used_for_match = self.current
	end
	-- Type Checking
	assert(type(the_char_to_match)=='number' and (the_char_to_match>=0 and the_char_to_match<=255),'the_char_to_match need to be a byte')
	assert(type(the_char_used_for_match)=='number' and (the_char_used_for_match>=0 and the_char_used_for_match<=255),'the_char_used_for_match need to be a byte')

	return (the_char_to_match==the_char_used_for_match)
end

-- match (using range) a char
---@param the_char_used_for_match byte? The Character Used For match
---@param start_range byte The start of the range
---@param end_range byte The end of the range
---@return boolean result the result of the match.
function Scanner:matchRangeAChar(the_char_used_for_match,start_range,end_range)
	-- Type Checking
	if the_char_used_for_match==nil then
		the_char_used_for_match = self.current
	end

	assert(type(the_char_used_for_match)=='number' and (the_char_used_for_match>=0 and the_char_used_for_match<=255),'the_char_used_for_match need to be a byte')
	assert(type(start_range)=='number' and (start_range>=0 and start_range<=255),'start_range need to be a byte')
	assert(type(end_range)=='number' and (end_range>=0 and end_range<=255),'end_range need to be a byte')

	return (the_char_used_for_match>=start_range) and (the_char_used_for_match<=end_range)
end

-- match (using out of range) a char
---@param the_char_used_for_match byte? The Character Used For match
---@param start_range byte The start of the range
---@param end_range byte The end of the range
---@return boolean result the result of the match.
function Scanner:matchOutOfRangeAChar(the_char_used_for_match,start_range,end_range)
	-- Type Checking
	if the_char_used_for_match==nil then
		the_char_used_for_match = self.current
	end

	assert(type(the_char_used_for_match)=='number' and (the_char_used_for_match>=0 and the_char_used_for_match<=255),'the_char_used_for_match need to be a byte')
	assert(type(start_range)=='number' and (start_range>=0 and start_range<=255),'start_range need to be a byte')
	assert(type(end_range)=='number' and (end_range>=0 and end_range<=255),'end_range need to be a byte')

	return (the_char_used_for_match<=start_range) or (the_char_used_for_match>=end_range)
end

-- Export
return Scanner