-- Scanner's Rules
--- Space
--- 
--- 
--- This module handles space rules.
--> By Yanzari

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.rules')

-- Module that is shared across the rules
local Shared = require('src.Scanner.rules.shared')

-- List of WhiteSpaces
---@type table<byte,boolean>
local ListOfWhiteSpaces = {
	[Shared.Space]=true, -- space
	[Shared.Tab]=true -- tab
}

-- Export
return Rules.new(
	{
		enter=function(self)
			if ListOfWhiteSpaces[self.current] then
				return true
			end
			return false
		end,
		loop=function(self)
			while true do
				if self:isEOF() then break end
				if self:isEOL() then break end
				if ListOfWhiteSpaces[self.current]==nil then break end
				self:advance()
			end
			return nil
		end,
		exportable={
			ListOfWhiteSpaces=ListOfWhiteSpaces -- List of WhiteSpaces
		}
	}
)