-- Scanner's Rules
--- Semicolon
--- 
--- 
--- This module handles Semicolon rules.
--> By Yanzari

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.utils.scanning.rules')

-- Module that handles Scanner Tokens
local Token = require('src.Scanner.utils.token')

-- Module that handles Scanner Enums
local Enum = require('src.Scanner.utils.enum')

-- the value for the Miscellaneous category found in the enum.
local Miscellaneous = Enum.TokenKinds:getvalue('Miscellaneous')

-- value corresponding to Semicolon in the Miscellaneous token category
local Semicolon = Enum.MiscellaneousTokenKinds:getvalue('Semicolon')

-- Export
return Rules.new({
    enter=function(self)
        if self.cursor:matchAChar(nil,59) then -- ; = 59
            return true
        end
        return false
    end,
    loop=function(self)
        local Start = self.cursor:newSpan()
        self:insertChar()
        self.cursor:advance()
        local End = self.cursor:newSpan()
        return Token.new({
            kind={
                category=Miscellaneous,
                miscellaneous=Semicolon
            },
            token=self.token,
            location={
                start=Start,
                ['end']=End
            }
        })
    end,
    exportable = {
        Semicolon=Semicolon
    }
})