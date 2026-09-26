-- Libarys
--- Enum
--- 
--- This class creates enums.
--- They map keys to values ​​and values ​​to keys.
--> By Yanzari

-- Enums
---@class Enum<EnumValue>
---@field key table<number,EnumValue> key-to-value map
---@field value table<EnumValue,number> value-to-key map
---@field new fun(...: EnumValue): Enum<EnumValue>
---@field getvalue fun(self:Enum,key:EnumValue):number
---@field getkey fun(self:Enum,value:number):EnumValue
local Enum = {}
Enum.__index = Enum

-- Create a Enum
---@generic EnumValue: any
---@vararg EnumValue
---@return Enum<EnumValue> self
function Enum.new(...)
	local args = {...}
	local output = {}
	for k,v in ipairs(args) do
		output[v] = k
	end
	local self = setmetatable({},Enum)
	self.key = output
	self.value = args
	return self
end

-- Get a Value from a Key
---@generic EnumKey: any
---@param key EnumKey the Key for getting the Value
---@return number value the Value returned
function Enum:getvalue(key)
	return self.key[key]
end

-- Get a Key from a Value
---@generic EnumKey: any
---@param value number the Value for getting a Key
---@return EnumKey key the Key returned
function Enum:getkey(value)
	return self.value[value]
end

-- Export
return Enum