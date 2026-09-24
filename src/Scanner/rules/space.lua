-- Scanner's Rules
--- Space
--- 
--- 
--- This module handles space rules.
--> By Yanzari

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.rules')

-- Module that handles Scanner Tokens
local Token = require('src.Scanner.token')

-- List of WhiteSpaces
local ListOfWhiteSpaces = {
    [32]=true, -- space
    [9]=true -- tab
}

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
            ListOfWhiteSpaces=ListOfWhiteSpaces
        }
    }
)