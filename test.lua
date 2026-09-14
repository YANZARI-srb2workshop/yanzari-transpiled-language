-- Test
---
--- This module calls the Test
--- and performs a complete test.
--> By Yanzari

-- Test Module
local Tester = require("tests")

-- the Flags Table
local function printTheAvailableFlags()
    print("+----------------------------------------------------+")
    print("|          Flag          |        Description        |")
    print("+------------------------+---------------------------+")
    print("|                        |                           |")
    print("|--scanner               | tests only the scanner.   |")
    print("|--full                  | runs all the tests.       |")
    print("|--help                  | shows this help message.  |")
    print("*----------------------------------------------------*")
end

-- Print the Help Message
local function printTheHelpMessage()
    print("test the Yanzari's Transpiled Language modules")
    print("")
    print("Here are the valid flags:")
    printTheAvailableFlags()
    print("")
end

-- Available Flags
---@param invalidFlag string the invalid flag passed
local function printTheErrorAboutUnavailableFlags(invalidFlag)
    print("error: this flag does not exist: "..invalidFlag)
    print("")
    print("Here are the valid flags:")
    printTheAvailableFlags()
    print("")
end

-- Prints the help message if no arguments are passed.
if arg[1]==nil then
    printTheHelpMessage()
    return nil
end

-- Only the Scanner
if arg[1]=="--scanner" then
    -- Just run the scanner test.
    Tester.TestScanner()
elseif arg[1]=="--full" then
    -- Make the full test.
    Tester.Test()
elseif arg[1]=="--help" then
    -- Show the Help Message
    printTheHelpMessage()
else
    -- If the flag does not exist
    printTheErrorAboutUnavailableFlags(arg[1])
end