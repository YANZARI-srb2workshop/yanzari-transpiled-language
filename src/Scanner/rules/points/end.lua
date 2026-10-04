-- Scanner's Rules
--- Identifier
--- 
--- 
--- This module handles end rules.
--> By Yanzari

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.utils.scanning.rules')

-- Module that handles Scanner Tokens
local Token = require('src.Scanner.utils.token')

-- Module that handles Scanner Enums
local Enum = require('src.Scanner.utils.enum')

-- End Of File
local EndOfFile = Enum.TokenKinds:getvalue('EndOfFile')

-- Export
return Rules.new({
    enter=function(self)
        if self.cursor:isEOF() then
            return true
        end
        return false
    end,
    loop=function(self)
        local Position = self.cursor:newSpan()
        return Token.new({
            kind={
                category=EndOfFile
            },
            location={
                start=Position,
                ['end']=Position
            }
        })
    end,
    exportable={
        EndOfFile
    }
})