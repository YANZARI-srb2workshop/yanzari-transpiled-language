-- Libarys
--- Node
--- 
--- This module creates nodes.
--- They can have children and a value.
--> By Yanzari

-- Node
---@class Node
---@field children table?
---@field value any
local Node = {}

-- Create a Node
---@param value any the value of the node.
---@param children table? the children belonging to the node.
---@return Node self a Node
function Node.new(value,children)
	-- Type Checking
	assert(type(value)~='nil','value is nil')
	if children~=nil then
		assert(type(children)=='table','value is not a table')
	end
	----------------------------------------------------------

	local self = setmetatable({},Node)
	self.children = children
	self.value = value
	return self
end

-- Export
return Node