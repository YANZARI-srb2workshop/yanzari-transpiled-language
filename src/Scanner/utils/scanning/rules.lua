-- Scanner
--- Rules
--- 
--- a module that implements the Scanner's rule class
--> By Yanzari

-- the interface for the `ScannerRule` to create a Rule.
---@class ScannerRuleInterface
---@field enter fun(base: Scanner): boolean when you call the rule's scanning function.
---@field loop fun(base: Scanner): Token? when the rule scan was accepted.
---@field exit? fun(base: Scanner): nil when the rule scan is complete.
---@field exportable? table exportable content.

-- the class for creating rules for the scanner.
---@class ScannerRule: ScannerRuleInterface
local Rules = {}
Rules.__index = Rules

-- Create a rule for the scanner.
---@param options ScannerRuleInterface an interface to create the rule.
---@return ScannerRule rule a rule for the scanner
function Rules.new(options)
	-- Type Checking
	assert(type(options)=='table','Options must be a Scanner Rule Interface.')
	assert(type(options.enter)=='function','Options.enter must be a function.')
	assert(type(options.loop)=='function','Options.loop must be a function.')
	if options.exit~=nil then
		assert(type(options.exit)=='function','Options.exit must be a function.')
	end
	if options.exportable~=nil then
		assert(type(options.exportable)=='table','Options.exportable must be a table.')
	end
	----------------------------------------------------------------------------------

	local self = setmetatable({},Rules)
	self.enter = options.enter
	self.loop = options.loop
	self.exit = options.exit
	self.exportable = options.exportable
	return self
end

-- run the Rule
---
--- The first returned argument, `entered`
--- indicates whether the rule found at least one match;
--- 
--- the second returned argument, `token`
--- is the token produced by the rule.
---@param base Scanner an instance of the Scanner.
---@return boolean entered,Token? token
function Rules:run(base)
	local enter
	local token
	-----------
	
	enter = self.enter(base)
	if enter~=true then
		return false,nil
	end
	token = self.loop(base)
	if token==nil then
		return true,nil
	end
	if self.exit~=nil then
		self.exit(base)
	end
	return true,token
end

-- Export
return Rules