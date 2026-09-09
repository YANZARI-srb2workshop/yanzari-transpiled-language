-- Scanner
--- 
--- This module will read the content of a text and convert it into tokens.
--- (I will implement the tokenization part soon)
--- 
--- This part is a work in progress.
--> By Yanzari

-- A module that handles intervals.
local Span = require('src.Scanner.span')

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
        else
            self.location = Span.new(self.location.line+jumplines,self.location.col+1)
        end
        self.previous = self.source[self.location.line][self.location.col-1]
        self.current = self.source[self.location.line][self.location.col]
        self.next = self.source[self.location.line][self.location.col+1]
    end
end

-- Export
return Scanner