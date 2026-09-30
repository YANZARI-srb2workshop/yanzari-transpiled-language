-- Scanner
--- Cursor
--- 
--- This module handles the scanner cursor.
--> By Yanzari

-- A module that handles intervals.
local Span = require('src.Scanner.utils.span')

-- a module that handles markers.
local Marker = require('src.Scanner.utils.backtracking.marker')

-- the module containing the object representation of the source code.
local SourceCode = require('src.SourceCode')

-- the cursor used by the Scanner to read the text and advance.
---@class ScannerCursor
---@field source SourceCode the source code that allows the scanner cursor to advance and capture characters from it.
---@field location Span the current location of the cursor.
---@field next byte? the next character the cursor will pass over.
---@field current byte? the current character the cursor is on.
---@field previous byte? the previous character that the cursor has already passed.
local Cursor = {}
Cursor.__index = Cursor

-- creates a new instance of the cursor
---@param source SourceCode the source code that allows the scanner cursor to advance and capture characters from it.
---@return ScannerCursor an instance of the Cursor.
function Cursor.new(source)
	-- Type Checking

	assert(getmetatable(source)==SourceCode,"The source must be a Source Code object.")
	----------------------------------------------------------------------------------
    
    local self = setmetatable({},Cursor)
    self.source = source
    self.location = Span.new(1,1)
    if #self.source.content.normalized>=1 then
		self.previous = self.source.content.normalized[self.location.line][self.location.col-1]
		self.current = self.source.content.normalized[self.location.line][self.location.col]
		self.next = self.source.content.normalized[self.location.line][self.location.col+1]
	end
    return self
end

-- Gets the current cursor location.
function Cursor:getLocation()
    return self.location
end

-- Gets the previous character at the cursor's current position.
function Cursor:getPreviousCharacter()
    return self.previous
end

-- Gets the character at the cursor's current position.
function Cursor:getCurrentCharacter()
    return self.current
end

-- Gets the next character at the cursor's current position.
function Cursor:getNextCharacter()
    return self.next
end

-- Advances several characters.
---@param limit number? the character advance limit; it stops when it reaches this limit. The default value is 1.
function Cursor:advance(limit)
	if self.current==nil and self.source.content.normalized[self.location.line+1]==nil then
		return nil
	end
	if limit==nil then
		limit = 1
	end
	assert(type(limit)=='number','limit must be a number')
	for _=1,limit do
		local cur = self.current
		local jumplines = 0
		if cur==nil then
			if self.source.content.normalized[self.location.line+1]==nil then
				break
			end
			jumplines = 1
		end
		if jumplines>=1 then
			self.location = Span.new(self.location.line+jumplines,1)
		else
			self.location = Span.new(self.location.line,self.location.col+1)
		end
		self.previous = self.source.content.normalized[self.location.line][self.location.col-1]
		self.current = self.source.content.normalized[self.location.line][self.location.col]
		self.next = self.source.content.normalized[self.location.line][self.location.col+1]
	end
end

-- This function causes the cursor to perform a backtracking.
---@param marker ScannerMarker a marker to make the cursor perform backtracking.
---@return byte char the current character before backtracking.
function Cursor:backtrack(marker)
	-- Type Checking
	assert(getmetatable(marker)==Marker,'marker must be a Marker')
	assert(marker.line<=#self.source.content.normalized,"attempt to break out of the line boundaries")
	assert(marker.line>0,"attempt to break out of the line boundaries")
	assert(marker.col<=#self.source.content.normalized[marker.line],"attempt to break out of the column boundaries")
	assert(marker.col>0,"attempt to break out of the column boundaries")
	-------------------------------------------------------------
	
	self.location = Span.new(marker.line,marker.col)

	-- the current character before backtracking.
	---@type byte
	local old = self.source.content.normalized[self.location.line][self.location.col]

	self.previous = self.source.content.normalized[self.location.line][self.location.col-1]
	self.current = self.source.content.normalized[self.location.line][self.location.col]
	self.next = self.source.content.normalized[self.location.line][self.location.col+1]
	return old
end

-- Is this the end of the line or not?
---@return boolean EOL Is it the end of the line?
function Cursor:isEOL()
	if self.current==nil and self.source.content.normalized[self.location.line+1]~=nil then
		return true
	end
	return false
end

-- Is this the end of the file or not?
---@return boolean EOF Is it the end of the file?
function Cursor:isEOF()
	if self.current==nil and self.source.content.normalized[self.location.line+1]==nil then
		return true
	end
	return false
end

-- Return character based on the `line` and `column` parameters.
---
--- If the `line` parameter is greater than 1: returns the character in the column specified by
--- the `column` parameter + 1, where the line is the current line + `line` parameter.
--- 
--- If the `line` parameter is 0: returns the character in the column is
--- the `column` parameter + current column and the line is the
--- current line.
---@param line number line relative to the current line.
---@param column number column relative to the current column.
---@return byte char the line-related character.
function Cursor:getCharacter(line,column)
	if line==nil then
		line = 0
	end
	if column==nil then
		column = 0
	end

	-- Type Checking
	assert(type(line)=='number','line must be a number')
	assert(type(column)=='number','column must be a number')
	assert(line>=0,'line is negative')
	assert(column>=0,'column is negative')
	-------------------------------------------------------
	if line>=1 then
		-- Type Checking
		assert(self.location.line+line<=#self.source.content.normalized,'line is invalid')
		assert(type(self.source.content.normalized[self.location.line+line])=='table','column is invalid')
		assert(column+1<=#self.source.content.normalized[self.location.line+line],'column is invalid')
		-------------------------------------
		
		return self.source.content.normalized[self.location.line+line][column+1]
	end
	-- Type Checking
	assert(self.location.line<=#self.source.content.normalized,'line is invalid')
	assert(self.location.col+column<=#self.source.content.normalized[self.location.line],'column is invalid')
	---------------------------------------------------------------------------------------
	return self.source.content.normalized[self.location.line][self.location.col+column]
end

-- tries to compare whether two characters are equal
---@param the_char_used_for_match byte?  The Character Used For Matching
---@param the_char_to_match byte The Character to Matching
---@return boolean result the result of the match.
function Cursor:matchAChar(the_char_used_for_match,the_char_to_match)
	if the_char_used_for_match==nil then
		the_char_used_for_match = self.current
	end
	if the_char_used_for_match==nil then
		if the_char_to_match==nil then
			return true
		end
		return false
	end
	-- Type Checking
	assert(type(the_char_to_match)=='number' and (the_char_to_match>=0 and the_char_to_match<=255),'the_char_to_match must be a byte')
	assert(type(the_char_used_for_match)=='number' and (the_char_used_for_match>=0 and the_char_used_for_match<=255),'the_char_used_for_match must be a byte')

	return (the_char_to_match==the_char_used_for_match)
end

-- tries to compare whether the character
-- is within the range between `start_range` and `end_range`
---@param the_char_used_for_match byte? The Character Used For match
---@param start_range byte The start of the range
---@param end_range byte The end of the range
---@return boolean result the result of the match.
function Cursor:matchRangeAChar(the_char_used_for_match,start_range,end_range)
	-- Type Checking
	if the_char_used_for_match==nil then
		the_char_used_for_match = self.current
	end
	if the_char_used_for_match==nil then
		return false
	end

	assert(type(the_char_used_for_match)=='number' and (the_char_used_for_match>=0 and the_char_used_for_match<=255),'the_char_used_for_match must be a byte')
	assert(type(start_range)=='number' and (start_range>=0 and start_range<=255),'start_range must be a byte')
	assert(type(end_range)=='number' and (end_range>=0 and end_range<=255),'end_range must be a byte')

	return (the_char_used_for_match>=start_range) and (the_char_used_for_match<=end_range)
end

-- tries to compare whether the character
-- is outside the range between `start_range` and `end_range`
---@param the_char_used_for_match byte? The Character Used For match
---@param start_range byte The start of the range
---@param end_range byte The end of the range
---@return boolean result the result of the match.
function Cursor:matchOutOfRangeAChar(the_char_used_for_match,start_range,end_range)
	-- Type Checking
	if the_char_used_for_match==nil then
		the_char_used_for_match = self.current
	end
	if the_char_used_for_match==nil then
		return false
	end

	assert(type(the_char_used_for_match)=='number' and (the_char_used_for_match>=0 and the_char_used_for_match<=255),'the_char_used_for_match must be a byte')
	assert(type(start_range)=='number' and (start_range>=0 and start_range<=255),'start_range must be a byte')
	assert(type(end_range)=='number' and (end_range>=0 and end_range<=255),'end_range must be a byte')

	return (the_char_used_for_match<start_range) or (the_char_used_for_match>end_range)
end

-- creates a Span based on the current Cursor location.
function Cursor:newSpan()
	return Span.new(self.location.line,self.location.col)
end

-- Export
return Cursor