-- Scanner's Rules
--- Hexadecimal
--- 
--- 
--- This module handles hexadecimal rules.
--> By Yanzari

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.utils.scanning.rules')

-- Module that handles Scanner Tokens
local Token = require('src.Scanner.utils.token')

-- Module that handles Scanner Enums
local Enum = require('src.Scanner.utils.enum')

-- Hexadecimal
local Hexadecimal = Enum.TokenKinds:getvalue("Hexadecimal")

-- checks if the character at the current position is a hexadecimal digit.
---@param char? byte the character to check.
---@param scanner Scanner the scanner to check.
---@return boolean is_a_digit Indicates whether the value is a hexadecimal digit or not.
local function IsDigit(char,scanner)
    if char==nil then
        return false
    end
    if scanner.cursor:matchRangeAChar(char,48,57) -- 48 = 0, 57 = 9
    or (scanner.cursor:matchRangeAChar(char,65,70) -- 65 = A, 70 = F
    or scanner.cursor:matchRangeAChar(char,97,102)) -- 97 = a, 102 = f
    then
        return true
    end
    return false
end

-- Export
return Rules.new({
    enter=function(self)
        local curchar = self.cursor:getCurrentCharacter()
        local nextchar = self.cursor:getNextCharacter()
        local nextestchar = self.cursor:getCharacter(0,2)
        if nextestchar == nil then
            return false
        end
        if self.cursor:matchAChar(curchar,48) -- 48 = 0
        and (
            self.cursor:matchAChar(nextchar,88) or -- 88 = X
            self.cursor:matchAChar(nextchar,120) -- 120 = x
        )
        and IsDigit(nextestchar,self) then
            return true
        end
        return false
    end,
    loop=function(self)
        local Start = self.cursor:newSpan()
        self:insertChar()
        self.cursor:advance()
        self:insertChar()
        self.cursor:advance()

        local digits = {}
        self:insertChar()
        digits[#digits+1] = self.cursor:getCurrentCharacter()
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
                            text='Malformed Hexadecimal.',
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
            digits[#digits+1] = currentChar
			self.cursor:advance()
		end
        local End = self.cursor:newSpan()
        return Token.new({
            kind={
                category=Hexadecimal
            },
            token=self.token,
            location={
                start=Start,
                ['end']=End
            },
            extra={
                base=16,
                digits=digits
            }
        })
    end,
    exportable = {
        IsDigit=IsDigit,
        Hexadecimal=Hexadecimal
    }
})