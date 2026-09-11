-- Scanner
--- 
--- This module will read the content of a text and convert it into tokens.
--- (I will implement the tokenization part soon)
--- 
--- This part is a work in progress.
--> By Yanzari

-- A module that handles intervals.
local Span = require('src.Scanner.span')

-- A module that handles tokens.
local Token = require('src.Scanner.token')

-- Scanner
---@class Scanner
---@field source SourceCode The Source Code
---@field tokens Token[] a buffer containing all the stored tokens
---@field token byte[]? The Token Content
---@field next byte? The Next Character
---@field current byte? The Current Character
---@field previous byte? The Previous Character
---@field location Span Cursor location
---@field extra any? Expandable content in the Scanner.
local Scanner = {}
Scanner.__index = Scanner

-- Create a New Scanner
---@param source SourceCode The Source Code
---@return Scanner self
function Scanner.new(source)
    local self = setmetatable({},Scanner)
    self.source = source
    self.tokens = {}
    self.token = {}
    self.location = Span.new(1,1)
    if #source>=1 then
        self.previous = self.source[self.location.line][self.location.col-1]
        self.current = self.source[self.location.line][self.location.col]
        self.next = self.source[self.location.line][self.location.col+1]
    end
    return self
end

-- Advance a Token
---@param limit number? the Advance Limit
function Scanner:advance(limit)
    if self.current==nil then
        return nil
    end
    limit = limit or 1
    for _=1,limit do
        local cur = self.current
        local jumplines = 0
        if cur==nil then
            if self.source[self.location.line+1]==nil then
                break
            end
            jumplines = 1
        end
        self.location = Span.new(self.location.line+jumplines,self.location.col+1)
        self.previous = self.source[self.location.line][self.location.col-1]
        self.current = self.source[self.location.line][self.location.col]
        self.next = self.source[self.location.line][self.location.col+1]
    end
end

-- Insert a char
---@param char byte? the character to be inserted.
function Scanner:insertChar(char)
    -- Typing Check
    if char~=nil then
        assert(type(char)=='number','char is not a number')
        assert(char < 255 and char > 0, "Invalid Byte")
    end
    ------

    if char==nil then
        char = self.current
    end
    table.insert(self.token,char)
end

-- Remove a Inserted char
function Scanner:removeInsertedChar()
    table.remove(self.token)
end

-- Get a Inserted char
---@param offset number? the offset to get the character.
function Scanner:getInsertedChar(offset)
    -- Typing Check
    if offset~=nil then
        assert(type(offset)=='number','offset is not a number')
    end
    ------
    if offset == nil then
        return self.token
    end
    return self.token[offset]
end

-- Emit a Token
---@param kind TokenKind the Token Type.
---@param start_location Span a Location Marker for the Start of Token Insertion
---@param end_location Span a Location Marker for the End of Token Insertion
---@param extra any? Content extendable to a token.
function Scanner:emitTokens(kind,start_location,end_location,extra)
    ---@type Token
    local TokenNode = Token.new({
        kind=kind,
        token=self.token,
        location={start=start_location,['end']=end_location},
        extra=extra
    })
    table.insert(self.tokens,TokenNode)
end

-- Get a Inserted Token
---@param offset number? the offset to get the Token.
function Scanner:getInsertedToken(offset)
    -- Typing Check
    if offset~=nil then
        assert(type(offset)=='number','offset is not a number')
    end
    ------
    if offset == nil then
        return self.tokens
    end
    return self.tokens[offset]
end

-- return the current location of the token.
---@return Span currentLocation current location of the token.
function Scanner:returnLocation()
    return Span.new(self.location.line,self.location.col+1)
end

-- Export
return Scanner