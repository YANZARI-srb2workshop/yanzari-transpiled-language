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
---@field current byte The Current Character
---@field previous byte? The Previous Character
---@field location Span Cursor location
---@field extra any? Expandable content in the Scanner.
---@field current_output_pos number the output buffer position.
---@field states {[number]: string|table} Scanner states
---@field warnings table<number,string> a stack containing all the program's warnings
---@field errors table<number,string> a stack containing all the program's errors
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
	self.states = {}
	self.extra = {}
	self.errors = {}
	self.warnings = {}
	if #self.source.content.normalized>=1 then
		self.previous = self.source.content.normalized[self.location.line][self.location.col-1]
		self.current = self.source.content.normalized[self.location.line][self.location.col]
		self.next = self.source.content.normalized[self.location.line][self.location.col+1]
	end
	return self
end

-- Scanner's State
---@alias ScannerState {tokens: Token[][], token: byte[]?, location: Span, current_output_pos: number, previous: byte?, current: byte?, next: byte?, extra: any?}

-- Clear the Scanner
---@return nil nothing returns nothing
function Scanner:clearScanner()
	self.tokens = {[1]={}}
	self.token = {}
	self.location = Span.new(1,1)
	self.current_output_pos = 1
	self.extra = {}
	if #self.source.content.normalized>=1 then
		self.previous = self.source.content.normalized[self.location.line][self.location.col-1]
		self.current = self.source.content.normalized[self.location.line][self.location.col]
		self.next = self.source.content.normalized[self.location.line][self.location.col+1]
	end
end

-- Get the Scanner's State
---@return ScannerState state the current state of the scanner
function Scanner:getScannerState()
	return {
		tokens=self.tokens,
		token=self.token,
		location=self.location,
		extra=self.extra,
		current_output_pos=self.current_output_pos,
		previous = self.source.content.normalized[self.location.line][self.location.col-1],
		current = self.source.content.normalized[self.location.line][self.location.col],
		next = self.source.content.normalized[self.location.line][self.location.col+1]
	}
end

-- Set the Scanner's State
---@param state ScannerState a scanner state
---@return nil nothing returns nothing
function Scanner:setScannerState(state)
	-- Type Checking
	assert(type(state)=="table",'state is not a table.')
	assert(type(state.location)=="table", 'state.location is not a span.')
	assert(type(state.location.line)=="number", 'state.location.line is not a number.')
	assert(type(state.location.col)=="number", 'state.location.col is not a number.')
	assert(state.location.line<=#self.source.content.normalized,"attempt to break out of the line boundaries")
	assert(state.location.line>0,"attempt to break out of the line boundaries")
	-- Uncomment this if you don't want states with EOF:
	-- assert(state.location.col<=#self.source.content.normalized[state.location.line],"attempt to break out of the column boundaries")
	assert(state.location.col>0,"attempt to break out of the column boundaries")
	if state.current~=nil then
		assert(type(state.current)=='number','The current character is not a byte.')
		assert(state.current>=0 and state.current<=255,'The current character is not a byte.')
	end
	if state.previous~=nil then
		assert(type(state.previous)=='number','The previous character is not a byte.')
		assert(state.previous>=0 and state.previous<=255,'The previous character is not a byte.')
	end
	if state.next~=nil then
		assert(type(state.next)=='number','The next character is not a byte.')
		assert(state.next>=0 and state.next<=255,'The next character is not a byte.')
	end
	assert((state.current_output_pos)<=256,'buffer overflow')
	assert((state.current_output_pos+1)>0,'buffer overflow')
	---------------------------------------------------------------------------------

	self.tokens = state.tokens
	self.token = state.token
	self.extra = state.extra
	self.location = state.location
	self.previous = state.previous
	self.current = state.current
	self.next = state.next
	self.current_output_pos = state.current_output_pos
end

-- Error Interface
---@class ErrorInterface
---@field text string error message
---@field location {start: Span, end: Span} error span

-- Type Checking a Error
---@param options ErrorInterface a Error Interface
local function TypeCheckingError(options)
	assert(type(options)=='table','options is not a ErrorInterface')
	assert(type(options.text)=='string','options.text is not a string')
	assert(type(options.location)=='table','options.location is not a span group')
	assert(getmetatable(options.location.start)==Span,'options.location.start is not a span')
	assert(getmetatable(options.location['end'])==Span,'options.location.end is not a span')
end

-- Emit a Error
---@param options ErrorInterface a Error Interface
function Scanner:emitError(options)
	-- Runtime Type Checking
	TypeCheckingError(options)
	--------------------------------------------------------------------------------

	table.insert({
		text=options.text,
		location=options.location
	},self.errors)
end

-- Emit a Warning
---@param options ErrorInterface a Warning Interface
function Scanner:emitWarning(options)
	-- Runtime Type Checking
	TypeCheckingError(options)
	--------------------------------------------------------------------------------

	table.insert({
		text=options.text,
		location=options.location
	},self.warnings)
end

-- A new Span based on the current position.
function Scanner:newSpanBasedOnCurrentPosition()
	return Span.new(self.location.line,self.location.col)
end

-- Advance a Token
---@param limit number? the Advance Limit
function Scanner:advance(limit)
	if self.current==nil and self.source.content.normalized[self.location.line+1]==nil then
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
		if jumplines>=1 then
			self.location = Span.new(self.location.line+jumplines,1)
		else
			self.location = Span.new(self.location.line,self.location.col+1)
		end
		self.previous = self.source.content.normalized[self.location.line][self.location.col-1]
		self.current = self.source.content.normalized[self.location.line][self.location.col]
		self.next = self.source.content.normalized[self.location.line][self.location.col+1]
	end
end

-- Is this the end of the line or not?
---@return boolean EOL Is it the end of the line?
function Scanner:isEOL()
	if self.current==nil and self.source.content.normalized[self.location.line+1]~=nil then
		return true
	end
	return false
end

-- Is this the end of the file or not?
---@return boolean EOF Is it the end of the file?
function Scanner:isEOF()
	if self.current==nil and self.source.content.normalized[self.location.line+1]==nil then
		return true
	end
	return false
end

-- turn back
---@param marker ScannerMarker a marker to be able to go back
---@return byte char the current character before returning.
function Scanner:back(marker)
	-- Type Checking
	assert(getmetatable(marker)==Marker,'marker is not a Marker')
	assert(marker.line<=#self.source.content.normalized,"attempt to break out of the line boundaries")
	assert(marker.line>0,"attempt to break out of the line boundaries")
	assert(marker.col<=#self.source.content.normalized[marker.line],"attempt to break out of the column boundaries")
	assert(marker.col>0,"attempt to break out of the column boundaries")
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

	if char==nil then
		char = self.current
	end
	-- Typing Check
	assert(char~=nil,'char is nil')
	assert(type(char)=='number','char is not a number')
	assert(char <= 255 and char >= 0, "Invalid Byte")
	-------------------------------------------------------
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
	-- Type Checking
	assert((self.current_output_pos+1)<=256,'buffer overflow')
	----------------------------------------------------------

	self.current_output_pos = self.current_output_pos+1
	if self.tokens[self.current_output_pos]==nil then
		self.tokens[self.current_output_pos] = {}
	end
end

-- Skip to the Previous Output Buffer
function Scanner:skipToThePreviousOutputBuffer()
	-- Type Checking
	assert((self.current_output_pos-1)>=1,'attempt to set the current output buffer position to -1')
	------------------------------------------------------------------------------------------------

	self.current_output_pos = self.current_output_pos-1
	if self.tokens[self.current_output_pos]==nil then
		self.tokens[self.current_output_pos] = {}
	end
end

-- Emit a Token
---@param token Token Token to Emit
function Scanner:emitToken(token)
	-- Type Checking
	assert(type(token)=='table','token is not a Token')

	-- Add Token to the self.tokens buffer
	table.insert(self.tokens[self.current_output_pos],token)
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

-- Return character based on the `line` and `column` parameters.
---
--- If the `line` parameter is greater than 1: returns the character in the column specified by
--- the `column` parameter + 1, where the line is the current line + `line` parameter.
--- 
--- If the `line` parameter is 0: returns the character in the column is
--- the `column` parameter + current column and the line is the
--- current line.
---@param line number line relative to the current line.
---@param column number column relative to the current column.
---@return byte char the line-related character.
function Scanner:getCharacter(line,column)
	if line==nil then
		line = 0
	end
	if column==nil then
		column = 0
	end

	-- Type Checking
	assert(type(line)=='number','line is not a number')
	assert(type(column)=='number','column is not a number')
	assert(line>=0,'line is negative')
	assert(column>=0,'column is negative')
	-------------------------------------------------------
	if line>=1 then
		-- Type Checking
		assert(self.location.line+line<=#self.source.content.normalized,'line is invalid')
		assert(type(self.source.content.normalized[self.location.line+line])=='table','column is invalid')
		assert(column+1<=#self.source.content.normalized[self.location.line+line],'column is invalid')
		-------------------------------------
		
		return self.source.content.normalized[self.location.line+line][column+1]
	end
	-- Type Checking
	assert(self.location.line<=#self.source.content.normalized,'line is invalid')
	assert(self.location.col+column<=#self.source.content.normalized[self.location.line],'column is invalid')
	---------------------------------------------------------------------------------------
	return self.source.content.normalized[self.location.line][self.location.col+column]
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
	if the_char_used_for_match==nil then
		if the_char_to_match==nil then
			return true
		end
		return false
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
	if the_char_used_for_match==nil then
		return false
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
	if the_char_used_for_match==nil then
		return false
	end

	assert(type(the_char_used_for_match)=='number' and (the_char_used_for_match>=0 and the_char_used_for_match<=255),'the_char_used_for_match need to be a byte')
	assert(type(start_range)=='number' and (start_range>=0 and start_range<=255),'start_range need to be a byte')
	assert(type(end_range)=='number' and (end_range>=0 and end_range<=255),'end_range need to be a byte')

	return (the_char_used_for_match<start_range) or (the_char_used_for_match>end_range)
end

-- Load a Rule
---@param name string name of the rule
---@return ScannerRule rule a Scanner Rule
local function LoadRule(name)
	assert(type(name)=='string','name is not a string')

	-- A Rule
	---@type ScannerRule
	local content = require('src.Scanner.rules.'..name)
	return content
end

-- Scanner Rules
---@type ScannerRule[]
Scanner.rules = {
	LoadRule('layout.indentation'), -- Indentation
	LoadRule('operator'), -- Operator
	LoadRule('layout.space'), -- Spaces
	-- Coming Soon More
}

-- Run Scanner Rules
---
--- You must run the returned thread without any arguments.
---@async
---@param self Scanner self
---@return thread thread A thread you can use to scan the text asynchronously.
Scanner.runRules = function(self)
	---@return Token|Token[]? token_or_output the tokens generated by the Scanner.
	return coroutine.create(function()
		if #Scanner.rules<=0 then
			return nil
		end
		while true do
			local passed = false
			for rulenumber,rule in ipairs(Scanner.rules) do
				if self:isEOF() then
					break
				end

				---@type boolean
				local enterred

				-- Token returned by the rule
				---@type Token?
				local token

				enterred,token = rule:run(self)
				assert(type(enterred)=='boolean','rule #'..tostring(rulenumber)..' returned argument #1 is not a boolean')
				if enterred==true then
					if token~=nil then
						assert(getmetatable(token)==Token,'rule #'..tostring(rulenumber)..' returned argument #2 is not a Token')
						
						coroutine.yield(token)
						self:emitToken(token)
						self.token = {}
					end
					passed = true
					break
				end
			end
			if self:isEOF() then
				break
			end
			if passed==false then
				-- Unknown character; I'll handle it later (I'll add support for syntax errors later).
				break
			end
		end
		return self.tokens
	end)
end

-- Export
return Scanner