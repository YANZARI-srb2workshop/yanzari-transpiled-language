-- Source Code
---  Arrayizer
---
--- A module that can convert a string into a byte array
--- and also a byte array into a string.
--> By Yanzari

-- Arrayizer Module
local Module = {}

-- String To Byte Array
---@param text string
---@return number[] array
function Module.StringToByteArray(text)
    local output = {}
    for i=1,#text do
        output[#output+1] = string.byte(text,i,i)
    end
    return output
end

-- String To Byte Array
---@param array number[]
---@return string text
function Module.ByteArrayToString(array)
    local output = {}
    for _,v in ipairs(array) do
        output[#output+1] = string.char(v)
    end
    return table.concat(output)
end

-- Export
return Module