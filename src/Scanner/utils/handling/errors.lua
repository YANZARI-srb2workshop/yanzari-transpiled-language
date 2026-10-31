-- Scanner
--- Errors
--- 
--- handles scanner errors, for example:
--- Syntax Error.
--> By Yanzari

-- A module that handles intervals.
local Span = require('src.libs.span')

-- Error Interface
---@class ErrorInterface
---@field type string? error type
---@field text string error message
---@field location {start: Span, end: Span} error span

-- Scanner Error Bucket
---@class ScannerErrorBucket
---@field bucket ErrorInterface[] a bucket that stores all the errors issued
---@field default_type string? default error type.
local Errors = {}
Errors.__index = Errors

-- Create a Error Bucket
---@nodiscard
---@param default_type string? default error type.
function Errors.new(default_type)
	-- Type Checking
	if default_type~=nil then
		assert(type(default_type)=="string","default_type must be a string")
	end
	------------------------------------------------------------------------

    local self = setmetatable({},Errors)
    self.bucket = {}
	self.default_type = default_type or "SyntaxError"
    return self
end

-- Emit a Error
---@param options ErrorInterface a Error Interface
function Errors:emit(options)
	-- Runtime Type Checking
	assert(type(options)=='table','options must be a ErrorInterface')
	if options.type~=nil then
		assert(type(options.type)=='string','options.type must be a string')
	end
	assert(type(options.text)=='string','options.text must be a string')
	assert(type(options.location)=='table','options.location must be a span group')
	assert(getmetatable(options.location.start)==Span,'options.location.start must be a span')
	assert(getmetatable(options.location['end'])==Span,'options.location.end must be a span')
	--------------------------------------------------------------------------------

	table.insert(self.bucket,{
		type=options.type or self.default_type,
		text=options.text,
		location=options.location
	})
end

-- Export
return Errors