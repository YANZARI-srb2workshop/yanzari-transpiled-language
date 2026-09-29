-- A module that handles intervals.
local Span = require('src.Scanner.utils.span')

-- Error Interface
---@class ErrorInterface
---@field text string error message
---@field location {start: Span, end: Span} error span

-- Scanner Error Bucket
---@class ScannerErrorBucket
---@field bucket ErrorInterface[] a bucket that stores all the errors issued
local Errors = {}
Errors.__index = Errors

-- Create a Error Bucket
function Errors.new()
    local self = setmetatable({},Errors)
    self.bucket = {}
    return self
end

-- Emit a Error
---@param options ErrorInterface a Error Interface
function Errors:emit(options)
	-- Runtime Type Checking
	assert(type(options)=='table','options must be a ErrorInterface')
	assert(type(options.text)=='string','options.text must be a string')
	assert(type(options.location)=='table','options.location must be a span group')
	assert(getmetatable(options.location.start)==Span,'options.location.start must be a span')
	assert(getmetatable(options.location['end'])==Span,'options.location.end must be a span')
	--------------------------------------------------------------------------------

	table.insert(self.bucket,{
		text=options.text,
		location=options.location
	})
end

-- Export
return Errors