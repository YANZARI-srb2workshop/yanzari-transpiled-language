-- Scanner
--- Marker
--- 
--- This module handles Scanner markers, in case it needs to return to a specific character.
--> By Yanzari

-- a marker to make the scanner cursor backtrack.
---@class ScannerMarker: Span
local Marker = {}
Marker.__index = Marker

-- creates a marker for the Scanner Cursor.
---@param line number the line for the scanner to perform backtracking.
---@param col number the column for the scanner to backtrack.
---@return ScannerMarker self a marker to make the scanner cursor backtrack.
function Marker.new(line,col)
	-- Type Checking
	assert(type(col)=='number','column must be a number')
	assert(type(line)=='number','line must be a number')
	----------------------------------------------------

	local self = setmetatable({},Marker)
	self.col = col
	self.line = line
	return self
end

-- Export
return Marker