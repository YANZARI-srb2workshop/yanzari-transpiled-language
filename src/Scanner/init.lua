-- Scanner
--- 
--- This module will read the content of a text and convert it into tokens.
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

-- This class handles text tokenization.<br>
--- It transforms the text into tokens so that the parser<br>
--- can convert them into a Concrete Syntax Tree.
---@class Scanner
---@field source SourceCode the source code. for the scanner to be able to read the source code.
---@field tokens Token[][] a buffer containing all the stored tokens
---@field token byte[]? The content of a token; it contains multiple bytes.
---@field cursor ScannerCursor The Scanner Cursor
---@field extra any? Expandable content in the Scanner.
---@field current_output_pos number the output buffer position.
---@field states {[number]: string|table} The scanner states; they can be used to store state information.
---@field warnings ScannerErrorBucket a bucket that stores all the errors issued.
---@field errors ScannerErrorBucket a bucket that stores all the warnings issued.
local Scanner = {}
Scanner.__index = Scanner

-- Create a New Scanner
---@nodiscard
---@param source SourceCode the source code. for the scanner to be able to read the source code.
---@return Scanner self an instance of the Scanner.
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

-- inserts a character into the `token` buffer.<br>
---
--- If the `byte` parameter has not been provided,<br>
--- it inserts the character at the scanner's current position.
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

-- removes the most recently inserted character from the `token` buffer.
function Scanner:removeInsertedChar()
	table.remove(self.token)
end

-- gets a character inserted into the `token` buffer.
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

-- moves to the next output buffer.
function Scanner:moveToTheNextOutputBuffer()
	-- Type Checking
	assert((self.current_output_pos+1)<=256,'buffer overflow')
	----------------------------------------------------------

	self.current_output_pos = self.current_output_pos+1
	if self.tokens[self.current_output_pos]==nil then
		self.tokens[self.current_output_pos] = {}
	end
end

-- moves to the previous output buffer.
function Scanner:moveToThePreviousOutputBuffer()
	-- Type Checking
	assert((self.current_output_pos-1)>=1,'attempt to set the current output buffer position to -1')
	------------------------------------------------------------------------------------------------

	self.current_output_pos = self.current_output_pos-1
	if self.tokens[self.current_output_pos]==nil then
		self.tokens[self.current_output_pos] = {}
	end
end

-- emits a token and places it in the `tokens` buffer<br>
--- at the buffer position determined by "self.current_output_pos".
---@param token Token Token to Emit
function Scanner:emitToken(token)
	-- Type Checking
	assert(type(token)=='table','token must be a Token')

	-- Add Token to the self.tokens buffer
	table.insert(self.tokens[self.current_output_pos],token)
end

-- get a token already present in the output.
---
--- If the `offset` is not provided,<br>
--- it returns all inserted tokens.
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

-- The Scanner rules are per instance.
---
--- `StartOfFile`: A rule that triggers when the scanner starts scanning.
--- 
--- `EndOfFile`: A rule that triggers when the scanner finishes scanning.
---
--- `Unknown`: a rule that is called when the scanner encounters an unknown character.<br>
--- It can be nil or not.
--- 
--- If `Unknown` returns `true`,<br>
--- it stops the scanner, and the scanner returns the final result.
---
--- If `Unknown` returns `false`,<br>
--- the scanner continues even with the unknown character.
--- 
--- If `Unknown` is `nil`,<br>
--- it stops the scanner, and the scanner returns the final result.
---@type {[number|'StartOfFile'|'EndOfFile'|'Unknown']: ScannerRule}
Scanner.rules = require('src.Scanner.rules')

-- executes only one rule and calls a callback if it returns a token.
---@param base Scanner the class with the rules.
---@param rule ScannerRule the rule itself.
---@param callback fun(options: {base: Scanner, token: Token}): nil the callback for when a token is present.
---@return boolean passed Did it pass the rule?
local function runRule(base,rule,callback)
	---@type boolean
	local entered

	-- Token returned by the rule
	---@type Token?
	local token

	entered,token = rule:run(base)
	assert(type(entered)=='boolean','this rule returned argument #1 must be a boolean')
	if entered==true then
		if token~=nil then
			assert(getmetatable(token)==Token,'this rule returned argument #2 must be a Token')
			
			callback({base=base,token=token})
		end
		base.token = {}
		return true
	end
	return false
end

-- Run Scanner Rules
---
--- You must run the returned thread without any arguments. <br>
--- the thread returns:
--- ```lua
--- {
---   output?: Token[][] -- the final output, with the tokens produced by the scanner. This field only appears when the scanner finishes.
---   token?: Token -- the token produced by the scanner, while the scanner has not yet finished. This field only appears when the scanner has not yet finished.
---   number_of_tokens?: number -- number of tokens produced by the scanner. This field only appears when the scanner finishes.
---   number_of_unknown_characters?: number -- number of unknown characters found by the scanner. This field only appears when the scanner finishes.
---   ended: boolean -- if the scanner has finished producing the tokens.
--- }
--- ```
---@async
---@nodiscard
---@param self Scanner self
---@return thread thread A thread you can use to scan the text asynchronously.
Scanner.runRules = function(self)
	return coroutine.create(function()
		if #Scanner.rules<=0 then
			return {
				output=nil,
				number_of_tokens=0,
				number_of_unknown_characters=0,
				ended=true
			}
		end
		local number_of_tokens = 0
		local number_of_unknown_characters = 0
		local RuleCallback = function(options)
			number_of_tokens=number_of_tokens+1
			coroutine.yield({
				token=options.token,
				ended=false
			})
			self:emitToken(options.token)
		end
		if self.rules.StartOfFile~=nil then
			runRule(self,self.rules.StartOfFile,RuleCallback)
		end
		while true do
			local passed = false
			for _,rule in ipairs(self.rules) do
				local ended = runRule(self,rule,RuleCallback)
				if ended==true then
					passed = true
					break
				end
			end
			if self.cursor:isEOF() then
				if self.rules.EndOfFile~=nil then
					runRule(self,self.rules.EndOfFile,RuleCallback)
				end
				break
			end
			if passed==false then
				if self.rules.Unknown~=nil then
					number_of_unknown_characters = number_of_unknown_characters+1
					-------------------------------------------------------------

					local can_break = runRule(self,self.rules.Unknown,RuleCallback)
					assert(type(can_break)=='boolean',"The result of the 'unknown' function must be a boolean.")
					if can_break==true then
						break
					end
				else
					break
				end
			end
		end
		return {
				output=self.tokens,
				number_of_tokens=number_of_tokens,
				number_of_unknown_characters=number_of_unknown_characters,
				ended=true
			}
	end)
end

-- Export
return Scanner