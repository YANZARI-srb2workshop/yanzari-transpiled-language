-- Source Code
---  Liner
---
--- A module that transforms a byte array into a 2D array of byte arrays.
--- and it also transforms a 2D array of byte arrays into a byte array.
--> By Yanzari

-- Liner Module
local Liner = {}

-- Carriage Return
local CR = 13
-- Line Feed
local LF = 10

-- Byte Array To 2D Byte Array
---@param array string[]
---@return string[][] array
function Liner.ByteArrayTo2DByteArray(array)
    local output = {[1]={}}
    local lines = 1
    do
        local k = 1
        while true do
            if k==#array then
                break
            end
            local v1 = array[k]
            local v2 = array[k+1]
            if v1==CR then
                if v2==LF then
                    k = k + 1
                end
                lines = lines + 1
            elseif v1==LF then
                lines = lines + 1
            else
                output[lines][#output+1] = v1
            end
            k = k + 1
        end
    end
    return output
end

-- 2D Byte Array To Byte Array
---@param array string[][]
---@return string[] array
function Liner.ByteArrayFrom2DByteArray(array)
    local output = {}
    for k1,_ in ipairs(array) do
        for _,v2 in ipairs(array[k1]) do
            output[#output+1] = v2
        end
        if k1~=#array then
            output[#output+1] = 10
        end
    end
    return output
end

-- Export
return Liner