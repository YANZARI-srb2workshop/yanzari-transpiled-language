-- Tests
--- Scanner
---
--- This module test the Scanner.
--> By Yanzari

-- creates a String named "YTL" and
--- returns the 3 characters of the String
--- to Tester check if everything is correct.
---@return boolean is_right,boolean invalid_chars,byte|string? char_or_byte_1,byte|string? char_or_byte_2,byte|string? char_or_byte_3 shows whether the test passed or not.
return function()
	-- Source
	---@type string
	local Source = "YTL"

	-- Source Code Module
	---@type SourceCode
	local SourceCode = require('src.SourceCode')

	-- Scanner Module
	---@type Scanner
	local Scanner = require('src.Scanner')

	-- the script's source code converted into an object
	---@type SourceCode
	local ScriptSource = SourceCode.new({
		content=Source
	})

	-- the Scanner that will read the script, to check if the Scanner is reading everything correctly.
	---@type Scanner
	local ScriptScanner = Scanner.new(ScriptSource)

	-- Byte 1
	---@type byte
	local byte1 = ScriptScanner.cursor:getCurrentCharacter()
	ScriptScanner.cursor:advance()

	-- Byte 2
	---@type byte
	local byte2 = ScriptScanner.cursor:getCurrentCharacter()
	ScriptScanner.cursor:advance()

	-- Byte 3
	---@type byte
	local byte3 = ScriptScanner.cursor:getCurrentCharacter()

	ScriptScanner.cursor:advance()

	-- Check to see if Byte 1, Byte 2, and Byte 3 are bytes.
	if type(byte1)=="number"
	and type(byte2)=="number"
	and type(byte3)=="number" then
		local char1,char2,char3 = string.char(byte1),string.char(byte2),string.char(byte3)
		-- Check if the text is correct.
		if char1=="Y"
		and char2=="T"
		and char3=="L" then
			-- Passed the Test
			return true,true
		end
		-- Didn't Pass the Test
		return false,true,char1,char2,char3
	end
	-- Didn't Pass the Test
	return false,false,byte1,byte2,byte3
end -- Export