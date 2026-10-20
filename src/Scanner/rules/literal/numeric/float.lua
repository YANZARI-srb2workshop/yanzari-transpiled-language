-- Scanner's Rules
--- Float
--- 
--- 
--- This module handles float rules.
--> By Yanzari

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.utils.scanning.rules')

-- Module that handles Scanner Tokens
local Token = require('src.Scanner.utils.token')

-- Module that handles Scanner Enums
local Enum = require('src.Scanner.utils.enum')

-- Float
local Float = Enum.TokenKinds:getvalue("Float")

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
        local nextchar = self.cursor:getNextCharacter()
        if self.cursor:matchAChar(char,46) and IsDigit(nextchar,self) then
            return true
        end
        ---@type (string|table)?
        local state = self.states[#self.states]
        if state~=nil
        and type(state)=="table"
        and state.id==2
        and state.category==1 then
            if self.cursor:matchAChar(char,46) then
                return true
            end
        end
        return false
    end,
    loop=function(self)
        ---@type (string|table)?
        local state = self.states[#self.states]
        if state~=nil
        and type(state)=="table"
        and state.id==2
        and state.category==1 then
            ---@type {id: 2, category: 1, start: Span, token: number[]}
            state = table.remove(self.states)
        else
            ---@type nil
            state = nil
        end
        -------------------------

        local Start
        if state~=nil then
            Start = state.start
            for k,v in ipairs(state.token) do
                self.token[k] = v
            end
        else
            Start = self.cursor:newSpan()
        end
        -- the integer part of the number
        ---@type number[]
        local integer
        if state~=nil then
            for k,v in ipairs(state.token) do
                if integer==nil then
                    integer = {}
                end
                integer[k] = v
            end
        end
        -- the decimal part of the number
        ---@type number[]
        local decimal

        if self.cursor:matchAChar(self.cursor:getPreviousCharacter(),95) then
            self.errors:emit({
                text='Malformed Float.',
                location={
                    start=self.cursor:newSpan(),
                    ['end']=self.cursor:newSpan()
                }
            })
        end

        self:insertChar()
        self.cursor:advance()

        if not self.cursor:isEOF()
        and not self.cursor:isEOL()
        and IsDigit(self.cursor:getCurrentCharacter(),self) then
            self:insertChar()

            decimal = {}
            table.insert(decimal,self.cursor:getCurrentCharacter())
            
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
                                text='Malformed Float.',
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
                table.insert(decimal,currentChar)
                self.cursor:advance()
            end
        end
        local End = self.cursor:newSpan()
        if self.cursor:matchAChar(nil,46) then
            self.errors:emit({
                text='Malformed Float.',
                location={
                    start=End,
                    ['end']=End
                }
            })
        end
        return Token.new({
            kind={
                category=Float
            },
            token=self.token,
            location={
                start=Start,
                ['end']=End
            },
            extra={
                base=10,
                details={
                    integer=integer,
                    decimal=decimal
                }
            }
        })
    end,
    exportable = {
    }
})