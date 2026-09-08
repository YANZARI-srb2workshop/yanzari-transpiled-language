-- Source Code
---
--- A module representing the source code of a script.
--> By Yanzari

-- Source Code Interface
---@class SourceCodeInterface
---@field filename string? File's Name
---@field content string File's Content

-- Source Code
---@class SourceCode
---@field new fun(options: SourceCodeInterface): SourceCode
---@field filename string?
---@field content string
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
    self.content = options.content
    return self
end

-- Export
return SourceCode