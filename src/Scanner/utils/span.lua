-- Scanner
--- Span
--- 
--- a module that implements a class called Span,
--- which contains the position relative to the cursor,
--- the text line, and the text column.
--> By Yanzari

-- Span
---@class Span
---@field line number Span's line.
---@field col number Span's column.
local Span = {}
Span.__index = Span

-- create a Span
---@param line number the text line to construct the Span.
---@param col number the text column to construct the Span.
---@return Span self a Span that stores position.
function Span.new(line,col)
	-- Type Checking
	assert(type(line)=='number','line must be a number')
	assert(type(col)=='number','col must be a number')
	---------------------------------------------------

	local self = setmetatable({},Span)
	self.line = line
	self.col = col
	return self
end

-- Export
return Span