-- Scanner
--- Token
--- 
--- This module handles the tokens.
--> By Yanzari

-- Kind of a Token
---@class TokenKind
---@field category enum_value Token Category
---@field operator enum_value? Token Operator Category
---@field size enum_value? Comment Size (used only for Comment Token)
---@field direction enum_value? Token Direction (used only for parentheses, braces, and brackets)

-- Token
---@class Token
---@field kind TokenKind
---@field token byte[]? The Token Content
---@field location {start: Span, end: Span} the Token Location
---@field extra any? Extra content for Token
local Token = {}
Token.__index = Token

-- Create a Token
---@param options Token
---@return Token self
function Token.new(options)
    local self = setmetatable({},Token)
    self.kind = options.kind
    self.token = options.token
    self.location = options.location
    self.extra = options.extra
    return self
end

-- Export
return Token