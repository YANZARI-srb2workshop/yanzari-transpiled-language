-- Scanner's Rules
--- Long Comment
--- 
--- 
--- This module handles long comment rules.
--> By Yanzari

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.utils.scanning.rules')

-- Module that handles Scanner Tokens
local Token = require('src.Scanner.utils.token')

-- Module that handles Scanner Enums
local Enum = require('src.Scanner.utils.enum')

-- the value for the Comment category found in the enum.
local Comment = Enum.TokenKinds:getvalue('Comment')

-- the value for the size category that represents long
local Long = Enum.CommentSize:getvalue('Long')

-- returns a boolean indicating whether it is the start of a comment.
---@param curchar byte? the current character.
---@param nextchar byte? the next character.
---@return boolean is_start
local function Start_Comment(curchar,nextchar)
    if curchar==47 -- /
    and nextchar==42 then -- *
        return true
    end
    return false
end

-- returns a boolean indicating whether it is the end of a comment.
---@param curchar byte? the current character.
---@param nextchar byte? the next character.
---@return boolean is_end
local function End_Comment(curchar,nextchar)
    if curchar==42 -- /
    and nextchar==47 then -- *
        return true
    end
    return false
end

-- Export
return Rules.new({
    enter=function(self)
        local curchar = self.cursor:getCurrentCharacter()
        local nextchar = self.cursor:getNextCharacter()
        return Start_Comment(curchar,nextchar)
    end,
    loop=function(self)
        local Start = self.cursor:newSpan()

        -- Skip /*
        self:insertChar()
        self.cursor:advance()
        self:insertChar()
        self.cursor:advance()
        ---------------------
        
        -- The words of a comment.
        ---@type byte[][][]
        local words = {[1]={}}
        while true do
            if self.cursor:isEOF() then break end
            if End_Comment(self.cursor:getCurrentCharacter(),self.cursor:getNextCharacter()) then break end
            if self.cursor:isEOL() then
                words[#words+1] = {}
                self.cursor:advance()
            elseif self.cursor:matchAChar(nil,32) then
                self:insertChar()
                self.cursor:advance()
            else
                local line = words[#words]
                line[#line+1] = {}

                local word = line[#line]
                word[#word+1] = self.cursor:getCurrentCharacter()
                self:insertChar()
                self.cursor:advance()
                while true do
                    if self.cursor:isEOF() then break end
                    if self.cursor:isEOL() then break end
                    if End_Comment(self.cursor:getCurrentCharacter(),self.cursor:getNextCharacter()) then break end
                    if self.cursor:matchAChar(nil,32) then
                        break
                    end
                    word[#word+1] = self.cursor:getCurrentCharacter()
                    self:insertChar()
                    self.cursor:advance()
                end
            end
        end

        -- Skip */
        self:insertChar()
        self.cursor:advance()
        self:insertChar()
        self.cursor:advance()
        ---------------------
        
        local End = self.cursor:newSpan()
        return Token.new({
            kind={
                category=Comment,
                size=Long
            },
            token=self.token,
            location={
                start=Start,
                ['end']=End
            },
            extra={
                words=words
            }
        })
    end,
    exportable = {
        Comment=Comment
    }
})