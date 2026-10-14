-- Scanner's Rules
--- WildCard
--- 
--- 
--- This module handles wildcard rules.
--> By Yanzari

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.utils.scanning.rules')

-- Module that handles Scanner Tokens
local Token = require('src.Scanner.utils.token')

-- Module that handles Scanner Enums
local Enum = require('src.Scanner.utils.enum')

-- the value for the WildCards category found in the enum.
local WildCard = Enum.TokenKinds:getvalue('WildCard')

-- Export
return Rules.new({
    enter=function(self)
        if self.cursor:matchAChar(nil,63) then -- ? = 63
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
                category=WildCard
            },
            token=self.token,
            location={
                start=Start,
                ['end']=End
            }
        })
    end,
    exportable = {
        WildCard=WildCard
    }
})