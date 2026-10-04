-- Scanner's Rules
--- Identifier
--- 
--- 
--- This module handles start rules.
--> By Yanzari

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.utils.scanning.rules')

-- Module that handles Scanner Tokens
local Token = require('src.Scanner.utils.token')

-- Module that handles Scanner Enums
local Enum = require('src.Scanner.utils.enum')

-- Start Of File
local StartOfFile = Enum.TokenKinds:getvalue('StartOfFile')

-- Export
return Rules.new({
    enter=function(self)
        return true
    end,
    loop=function(self)
        local Position = self.cursor:newSpan()
        return Token.new({
            kind={
                category=StartOfFile
            },
            location={
                start=Position,
                ['end']=Position
            }
        })
    end,
    exportable={
        StartOfFile
    }
})