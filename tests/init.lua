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
---@return nil nil returns nothing
function Tester.TestScanner()
	print(".")
	print("| Scanner")

	-- Check if it passed the test.
	Tests.Scanner()

	print("")
end

-- Full Test
---@return nil nil returns nothing
function Tester.Test()
	Tester.TestScanner()
end

-- Export
return Tester