-- Scanner's Rules
--- Integer
--- 
--- 
--- This module handles integer rules.
--> By Yanzari

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.utils.scanning.rules')

-- Module that handles Scanner Tokens
local Token = require('src.Scanner.utils.token')

-- Module that handles Scanner Enums
local Enum = require('src.Scanner.utils.enum')

-- Integer
local Integer = Enum.TokenKinds:getvalue("Integer")

-- checks if the character at the current position is a numeric digit.
---@param char? byte the character to check.
---@param scanner Scanner the scanner to check.
---@return boolean is_a_digit Indicates whether the value is a numeric digit or not.
local function IsDigit(char,scanner)
    if char==nil then
        return false
    end
    if scanner.cursor:matchRangeAChar(char,48,57) then -- 48 = 0, 57 = 9
        return true
    end
    return false
end

-- Export
return Rules.new({
    enter=function(self)
        local char = self.cursor:getCurrentCharacter()
        if IsDigit(char,self) then
            return true
        end
        return false
    end,
    loop=function(self)
        local Start = self.cursor:newSpan()
        self:insertChar()
        self.cursor:advance()
        while true do
			if self.cursor:isEOF() then break end
			if self.cursor:isEOL() then break end
            local currentChar = self.cursor:getCurrentCharacter()
            local nextChar = self.cursor:getNextCharacter()
			if not IsDigit(currentChar,self) then
                if not IsDigit(nextChar,self) then
                    if self.cursor:matchAChar(currentChar,95) then
                        local currentPosition = self.cursor:newSpan()
                        self.warnings:emit({
                            text='Malformed Number.',
                            location={
                                start=currentPosition,
                                ['end']=currentPosition
                            }
                        })
                    end
                end
                if not self.cursor:matchAChar(currentChar,95) then
                    break
                end
            end
			self:insertChar()
			self.cursor:advance()
		end
        local End = self.cursor:newSpan()
        return Token.new({
            kind={
                category=Integer
            },
            token=self.token,
            location={
                start=Start,
                ['end']=End
            },
            extra={
                base=10
            }
        })
    end,
    exportable = {
    }
})