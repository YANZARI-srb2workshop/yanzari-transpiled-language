-- Scanner's Rules
--- Directive
--- 
--- 
--- This module handles directive rules.
--> By Yanzari

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.utils.scanning.rules')

-- Module that handles Scanner Tokens
local Token = require('src.Scanner.utils.token')

-- Module that handles Scanner Enums
local Enum = require('src.Scanner.utils.enum')

-- the value for the Directives category found in the enum.
local Directive = Enum.TokenKinds:getvalue('Directive')

-- This function is used to validate the starting character
--- of the directive.
---@param char byte? a character, to check whether it is the start of an identifier.
---@param scanner Scanner the scanner to validate the characters.
local function Identifier_Start(char,scanner)
    local current = char
    if current==nil then
        current = scanner.cursor:getCurrentCharacter()
    end
    return (scanner.cursor:matchRangeAChar(current,65,90) -- 65 = A, 90 = Z
        or scanner.cursor:matchRangeAChar(current,97,122) -- 97 = a, 122 = z
        or scanner.cursor:matchAChar(current,95) -- 95 = _
        or current>127) -- 127 = DEL
end

-- This function is used to validate the character
--- following the start of the directive.
---@param char byte? a character used to check whether it follows the start of an identifier.
---@param scanner Scanner the scanner to validate the characters.
local function Identifier_Loop(char,scanner)
    local current = char
    if current==nil then
        current = scanner.cursor:getCurrentCharacter()
    end
    return (Identifier_Start(char,scanner)==true
    or scanner.cursor:matchRangeAChar(current,48,57)) -- 48 = 0, 57 = 9
end

-- Export
return Rules.new({
    enter=function(self)
        if self.cursor:getCurrentCharacter()==35 and Identifier_Start(self.cursor:getNextCharacter(),self) then
            return true
        end
        return false
    end,
    loop=function(self)
        local Start = self.cursor:newSpan()
        self:insertChar()
        self.cursor:advance()
        ---------------------
        
        -- directive name
        ---@type byte[]
        local name = {}
        self:insertChar()
        name[#name+1] = self.cursor:getCurrentCharacter()
        self.cursor:advance()
        while true do
			if self.cursor:isEOF() then break end
			if self.cursor:isEOL() then break end
			if not Identifier_Loop(nil,self) then break end
			self:insertChar()
            name[#name+1] = self.cursor:getCurrentCharacter()
			self.cursor:advance()
		end

        -- the directive's arguments
        ---@type byte[][]
        local args = {}
        while true do
            if self.cursor:isEOF() then break end
            if self.cursor:isEOL() then break end
            if self.cursor:matchAChar(nil,32) then
                self:insertChar()
                self.cursor:advance()
            elseif self.cursor:matchRangeAChar(nil,33,126) or self.cursor:getCurrentCharacter()>127 then
                args[#args+1] = {}
                local arg_variable = args[#args]
                arg_variable[#arg_variable+1] = self.cursor:getCurrentCharacter()
                self:insertChar()
                self.cursor:advance()
                while true do
                    if self.cursor:isEOF() then break end
                    if self.cursor:isEOL() then break end
                    if not (self.cursor:matchRangeAChar(nil,33,126))
                    or not (self.cursor:getCurrentCharacter()>127) then
                        break
                    end
                    arg_variable[#arg_variable+1] = self.cursor:getCurrentCharacter()
                    self:insertChar()
                    self.cursor:advance()
                end
            else
                local currentPosition = self.cursor:newSpan()
                self.errors:emit({
                    text='Invalid Directive.',
                    location={
                        start=currentPosition,
                        ['end']=currentPosition
                    }
                })
            end
        end
        local End = self.cursor:newSpan()
        return Token.new({
            kind={
                category=Directive
            },
            token=self.token,
            location={
                start=Start,
                ['end']=End
            },
            extra={
                name=name,
                args=args
            }
        })
    end,
    exportable = {
        Identifier_Loop=Identifier_Loop,
        Directive=Directive,
        Identifier_Start=Identifier_Start
    }
})