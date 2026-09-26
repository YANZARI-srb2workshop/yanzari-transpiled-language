-- Tests
--- Scanner
---
--- This module test the Scanner.
--> By Yanzari

-- creates a String named "YTL" and
--- returns the 3 characters of the String
--- to Tester check if everything is correct.
---@return nil nil returns nothing
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
	local v1 = ScriptScanner.current

	-- The Scanner's previous State
	---@type ScannerState
	local statev1 = ScriptScanner:getScannerState()
	ScriptScanner:advance()

	-- Byte 2
	---@type byte
	local v2 = ScriptScanner.current

	-- The Scanner's New State
	---@type ScannerState
	local statev2 = ScriptScanner:getScannerState()
	if statev1.current==statev2.current then
		print("- [Failed] The old character is a reference to the current character.")
		return nil
	end
	ScriptScanner:advance()

	-- Byte 3
	---@type byte
	local v3 = ScriptScanner.current

	ScriptScanner:advance()

	-- Check to see if Byte 1, Byte 2, and Byte 3 are bytes.
	if type(v1)=="number"
	and type(v2)=="number"
	and type(v3)=="number" then
		local char1,char2,char3 = string.char(v1),string.char(v2),string.char(v3)
		-- Check if the text is correct.
		if char1=="Y"
		and char2=="T"
		and char3=="L" then
			-- Passed the Test
			print("+ Success")
			return nil
		end
		-- Didn't Pass the Test
		print("- [Failed] Any of the 3 characters are the expected ones.")
		print(char1,char2,char3)
		return nil
	end
	-- Didn't Pass the Test
	print("- [Failed] One of the 3 characters is not a byte:")
	print(v1,v2,v3)
	return nil
end -- Export