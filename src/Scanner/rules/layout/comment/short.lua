-- Scanner's Rules
--- Short Comment
--- 
--- 
--- This module handles short comment rules.
--> By Yanzari

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.utils.scanning.rules')

-- Module that handles Scanner Tokens
local Token = require('src.Scanner.utils.token')

-- Module that handles Scanner Enums
local Enum = require('src.Scanner.utils.enum')

-- the value for the Comment category found in the enum.
local Comment = Enum.TokenKinds:getvalue('Comment')

-- the value for the size category that represents small
local Short = Enum.CommentSize:getvalue('Short')

-- Export
return Rules.new({
    enter=function(self)
        local curchar = self.cursor:getCurrentCharacter()
        local nextchar = self.cursor:getNextCharacter()
        if curchar==47 -- /
        and nextchar==47 then -- /
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
        ---------------------
        
        -- The words of a comment.
        ---@type byte[][]
        local words = {}
        while true do
            if self.cursor:isEOF() then break end
            if self.cursor:isEOL() then break end
            if self.cursor:matchAChar(nil,32) then
                self:insertChar()
                self.cursor:advance()
            else
                words[#words+1] = {}

                local word = words[#words]
                word[#word+1] = self.cursor:getCurrentCharacter()
                self:insertChar()
                self.cursor:advance()
                while true do
                    if self.cursor:isEOF() then break end
                    if self.cursor:isEOL() then break end
                    if self.cursor:matchAChar(nil,32) then
                        break
                    end
                    word[#word+1] = self.cursor:getCurrentCharacter()
                    self:insertChar()
                    self.cursor:advance()
                end
            end
        end
        local End = self.cursor:newSpan()
        return Token.new({
            kind={
                category=Comment,
                size=Short
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