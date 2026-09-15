-- Scanner
--- Marker
--- 
--- This module handles Scanner markers, in case it needs to return to a specific character.
--> By Yanzari

-- a marker to be able to go back
---@class ScannerMarker
---@field col number the column for the scanner to move backward
---@field line number the line for the scanner to move backward
local Marker = {}
Marker.__index = Marker

-- Creates a marker so the scanner can backtrack.
---@param col number the column for the scanner to move backward
---@param line number the line for the scanner to move backward
function Marker.new(col,line)
    -- Type Checking
    assert(type(col)=='number','column is not a number')
    assert(type(line)=='number','line is not a number')
    ----------------------------------------------------

    local self = setmetatable({},Marker)
    self.col = col
    self.line = line
    return self
end

-- Export
return Marker