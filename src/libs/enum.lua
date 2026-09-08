-- Libarys
--- Enum
--- 
--- This class creates enums.
--- They map keys to values ​​and values ​​to keys.
--> By Yanzari

-- Enums
---@class Enum
---@field key table
---@field value any[]
---@field new fun(...): Enum
---@field getvalue fun(self:Enum,key:any):number
---@field getkey fun(self:Enum,value:number):any
local Enum = {}
Enum.__index = Enum

-- Create a Enum
---@vararg any
function Enum.new(...)
    local args,output = {...},{...}
    for k,v in ipairs(args) do
        output[v] = k
    end
    local self = setmetatable({},Enum)
    self.key = output
    self.value = args
    return self
end

-- Get a Value from a Key
---@param key any the Key for getting the Value
---@return number value the Value returned
function Enum:getvalue(key)
    return self.value[key]
end

-- Get a Key from a Value
---@param value number the Value for getting a Key
---@return any key the Key returned
function Enum:getkey(value)
    return self.key[value]
end

-- Export
return Enum