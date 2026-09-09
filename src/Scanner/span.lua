-- Scanner
--- Span
--- 
--- a module that implements a class called Span,
--- which contains the position relative to the cursor,
--- the text line, and the text column.
--> By Yanzari

-- Span
---@class Span
---@field line number Line
---@field col number Column
local Span = {}
Span.__index = Span

-- Create a Span
---@param line number Text's Line
---@param col number Text's Column
---@return Span self
function Span.new(line,col)
    local self = setmetatable({},Span)
    self.line = line
    self.col = col
    return self
end

-- Export
return Span