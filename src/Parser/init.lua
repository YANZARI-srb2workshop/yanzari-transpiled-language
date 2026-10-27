-- Parser
--- 
--- One of the most complex modules;
--- it is responsible for transforming multiple tokens into a Concrete Syntax Tree.
--- 
--- WIP
--> By Yanzari

-- The class that takes the tokens from the Scanner and transforms them into a Concrete Syntax Tree.<br />
--- (WIP)
---@see ParserCST
---@class Parser
---@field cst ParserCST[] each ParserCST is more or less one line.
---@field tokenBuffer_pos number the current token buffer's position, in case you want to switch to another token buffer.
---@field source SourceCode the source code.
---@field tokens Token[][] the tokens produced by the scanner.
---@field position number Parser cursor position
local Parser = {}
Parser.__index = Parser

-- Create a Parser Instance
---@param options context_shared<Token[][]> The source code and the scanner tokens.
function Parser.new(options)
    local self = setmetatable({},Parser)
    self.cst = {
        {
            kind=1,
            childerns={}
        }
    }
    self.tokenBuffer_pos = 1
    self.source = options.Source
    self.tokens = options.Context
    self.position = 1
    return self
end

-- parser position advances.
function Parser:advance()
    self.position = self.position+1
end

-- parser position moves backward.
function Parser:back()
    self.position = self.position-1
end

-- returns the next token.
function Parser:next()
    return self.tokens[self.tokenBuffer_pos][self.position+1]
end

-- returns the current token.
function Parser:current()
    return self.tokens[self.tokenBuffer_pos][self.position]
end

-- returns the previous token.
function Parser:previous()
    return self.tokens[self.tokenBuffer_pos][self.position-1]
end

-- Export
return Parser