-- Scanner
--- Rules
--- 
--- 
--- It loads the rules.
--> By Yanzari

-- a rules table
---@type {[number|'StartOfFile'|'EndOfFile'|'Unknown']: ScannerRule}
local Rules = {}

-- It adds a rule to the Rules table.
---@param rulename string the name of the rule.
local function AddRule(rulename,name)
    local rule = require('src.Scanner.rules.'..rulename)
    if type(name)~='string' then
        Rules[#Rules+1] = rule
    else
        Rules[name] = rule
    end
    return rule
end

-- Let's add the rules to the rules table!
AddRule('points.start','StartOfFile') -- start of file.
AddRule('points.end','EndOfFile') -- end of file.
AddRule('points.unknown','Unknown') -- Unknown Character
AddRule('layout.indentation') -- indentation.
AddRule('layout.space') -- spaces/tabs.
AddRule('layout.semicolon') -- semicolon.
AddRule('layout.comment.long') -- long comment.
AddRule('layout.comment.short') -- short comment.
AddRule('literal.identifier') -- identifier/keyword.
AddRule('literal.numeric.binary') -- an binary.
AddRule('literal.numeric.hexadecimal') -- an hexadecimal.
AddRule('literal.numeric.integer') -- an integer.
AddRule('literal.numeric.float') -- an float.
AddRule('literal.parentesis') -- parentesis/curly bracket/square bracket.
AddRule('literal.wildcard') -- Wildcard.
AddRule('directive') -- directive.
AddRule('operator') -- operator.

-- Export
return Rules