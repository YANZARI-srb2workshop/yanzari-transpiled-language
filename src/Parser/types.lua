-- Parser
--- Types
---
--- All Parser types are static, and this module returns nothing.
--- This module exists solely to define types for LuaLS to understand.
--> By Yanzari

-- the enum used by the Concrete Syntax Tree.
---@alias ParserCSTEnum
---| 1 # Program
---| 2 # Atom

-- Parser nodes used in the CST.
---@see ParserCSTEnum
---@class ParserNode
---@field kind ParserCSTEnum the node type.
---@field childerns table the children of the node.

-- CST
---@see ParserNode
---@see ParserCSTEnum
---@class ParserCST: ParserNode
---@field kind 1 the Node type being the type corresponding to Program.
---@field childerns any[] the program statements.