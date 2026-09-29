-- Scanner
--- 
--- This module will read the content of a text and convert it into tokens.
--- (I will implement the tokenization part soon)
--- 
--- This part is a work in progress.
--> By Yanzari

-- A module that handles intervals.
local Span = require('src.Scanner.utils.span')

-- A module that handles tokens.
local Token = require('src.Scanner.utils.token')

-- a module that handles markers.
local Marker = require('src.Scanner.utils.backtracking.marker')

-- a module that handles cursor.
local Cursor = require('src.Scanner.utils.scanning.cursor')

-- a module containing the object representation of the source code.
local SourceCode = require('src.SourceCode')

-- a module that handles errors
local Errors = require('src.Scanner.utils.handling.errors')

-- Scanner
---@class Scanner
---@field source SourceCode The Source Code
---@field tokens Token[][] a buffer containing all the stored tokens
---@field token byte[]? The Token Content
---@field cursor ScannerCursor The Scanner Cursor
---@field extra any? Expandable content in the Scanner.
---@field current_output_pos number the output buffer position.
---@field states {[number]: string|table} Scanner states
---@field warnings ScannerErrorBucket a bucket that stores all the errors issued.
---@field errors ScannerErrorBucket a bucket that stores all the warnings issued.
local Scanner = {}
Scanner.__index = Scanner

-- Create a New Scanner
---@param source SourceCode The Source Code
---@return Scanner self
function Scanner.new(source)
	-- Type Checking

	assert(getmetatable(source)==SourceCode,"The source must be a Source Code object.")
	----------------------------------------------------------------------------------

	local self = setmetatable({},Scanner)
	self.source = source
	self.tokens = {[1]={}}
	self.token = {}
	self.current_output_pos = 1
	self.states = {}
	self.extra = {}
	self.errors = Errors.new()
	self.warnings = Errors.new()
	self.cursor = Cursor.new(self.source)
	return self
end

-- Insert a char
---@param char byte? the character to be inserted.
function Scanner:insertChar(char)

	if char==nil then
		char = self.cursor:getCurrentCharacter()
	end
	-- Typing Check
	assert(char~=nil,'char is nil')
	assert(type(char)=='number','char must be a number')
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
		assert(type(offset)=='number','offset must be a number')
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
	assert(type(token)=='table','token must be a Token')

	-- Add Token to the self.tokens buffer
	table.insert(self.tokens[self.current_output_pos],token)
end

-- Get a Inserted Token
---@param offset number? the offset to get the Token.
function Scanner:getInsertedToken(offset)
	-- Typing Check
	if offset~=nil then
		assert(type(offset)=='number','offset must be a number')
	end
	------
	if offset == nil then
		return self.tokens[self.current_output_pos]
	end
	return self.tokens[self.current_output_pos][offset]
end

-- Load a Rule
---@param name string name of the rule
---@return ScannerRule rule a Scanner Rule
local function LoadRule(name)
	assert(type(name)=='string','name must be a string')

	-- A Rule
	---@type ScannerRule
	local content = require('src.Scanner.rules.'..name)
	return content
end

-- Scanner Rules
---@type ScannerRule[]
Scanner.rules = {
	LoadRule('layout.indentation'), -- Indentation
	LoadRule('identifier'),
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
				if self.cursor:isEOF() then
					break
				end

				---@type boolean
				local enterred

				-- Token returned by the rule
				---@type Token?
				local token

				enterred,token = rule:run(self)
				assert(type(enterred)=='boolean','rule #'..tostring(rulenumber)..' returned argument #1 must be a boolean')
				if enterred==true then
					if token~=nil then
						assert(getmetatable(token)==Token,'rule #'..tostring(rulenumber)..' returned argument #2 must be a Token')
						
						coroutine.yield(token)
						self:emitToken(token)
					end
					self.token = {}
					passed = true
					break
				end
			end
			if self.cursor:isEOF() then
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