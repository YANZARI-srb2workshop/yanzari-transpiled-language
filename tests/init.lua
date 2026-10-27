-- Tester
---
--- This module creates some tests.
--- It serves to validate whether something is correct or not.
--- 
--- This part is a work in progress.
--> By Yanzari

-- the Tests
local Tests = {
	Scanner = require("tests.scanner"), -- Scanner Test
}
-- Tester
local Tester = {}

-- Test Scanner
---@return ... returns nothing
function Tester.TestScanner()
	local is_right,invalid_chars,char1,char2,char3 = Tests.Scanner()
	return {
		is_right=is_right,
		invalid_chars=invalid_chars,
		char1=char1,
		char2=char2,
		char3=char3
	}
end

-- Full Test
---@return {scanner: {is_right:boolean, invalid_chars:boolean, char1:byte|string, char2:byte|string, char3:byte|string}, [string]: ...} tests How did all the tests go?
function Tester.Test()
	return {
		scanner=Tester.TestScanner()
	}
end

-- Export
return Tester