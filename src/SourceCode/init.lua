-- Source Code
---
--- A module representing the source code of a script.
--> By Yanzari

-- A module that can convert a string into a byte array
--- and also a byte array into a string.
local Arrayizer = require('src.SourceCode.utils.Arrayizer')

-- A module that transforms a byte array into a 2D array of byte arrays.
--- and it also transforms a 2D array of byte arrays into a byte array.
local Liner = require('src.SourceCode.utils.Liner')

-- Source Code Interface
---@class SourceCodeInterface
---@field filename string? File's Name
---@field content string File's Content

-- Source Code's Content
---@class SourceCodeContent
---@field raw string the raw content of the file
---@field normalized byte[][] the normalized content of the file

-- Source Code
---@class SourceCode
---@field new fun(options: SourceCodeInterface): SourceCode
---@field filename string? File's Name
---@field content SourceCodeContent
local SourceCode = {}
SourceCode.__index = SourceCode

-- Create a New Source Code
---@param options SourceCodeInterface
---@return SourceCode self
function SourceCode.new(options)
    -- Typing Check
    assert(type(options)=='table','Option\'s is not a Table')
    assert(type(options.content)=='string','Option\'s content is not a string')
    if options.filename~=nil then
        assert(type(options.filename)=='string','Option\'s filename is not a string')
    end
    
    local self = setmetatable({},SourceCode)
    self.filename = options.filename

    -- a byte array containing the file's content.
    local ByteArray = Arrayizer.StringToByteArray(options.content)

    -- a 2D array containing byte arrays, derived from the byte array; this 2D array contains each line of the file.
    local LineByteArray = Liner.ByteArrayTo2DByteArray(ByteArray)

    self.content = {
        raw=options.content, -- the raw content of the file
        normalized=LineByteArray -- the normalized content of the file
    }
    return self
end

-- Export
return SourceCode