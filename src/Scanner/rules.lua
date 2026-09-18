-- Scanner
--- Rules
--- 
--- a module that implements the Scanner's rule class
--> By Yanzari

-- Rule Class Interface
---@class ScannerRuleInterface
---@field enter fun(base: Scanner): boolean when you call the rule's scanning function.
---@field loop fun(base: Scanner): Token? when the rule scan was accepted.
---@field exit? fun(base: Scanner): nil when the rule scan is complete.
---@field exportable? table exportable content.

-- Rule Class
---@class ScannerRule: ScannerRuleInterface
local Rules = {}
Rules.__index = Rules

-- Create a new Rules
---@param options ScannerRuleInterface
function Rules.new(options)
    -- Type Checking
    assert(type(options)=='table','Options is not a Scanner Rule Interface.')
    assert(type(options.enter)=='function','Options.enter is not a function.')
    assert(type(options.loop)=='function','Options.loop is not a function.')
    if options.exit~=nil then
        assert(type(options.exit)=='function','Options.exit is not a function.')
    end
    if options.exportable~=nil then
        assert(type(options.exportable)=='table','Options.exportable is not a table.')
    end
    ----------------------------------------------------------------------------------

    local self = setmetatable({},Rules)
    self.enter = options.enter
    self.loop = options.loop
    self.exit = options.exit
    self.exportable = options.exportable
    return self
end

-- Run the Rule
---@param base Scanner an instance of the Scanner.
---@return Token? token token that will be emitted to the output buffer, or nil.
function Rules:run(base)
    local enter
    local token
    -----------
    
    enter = self.enter(base)
    if enter~=true then
        return nil
    end
    token = self.loop(base)
    if token==nil then
        return nil
    end
    if self.exit~=nil then
        self.exit(base)
    end
    return token
end

-- Export
return Rules