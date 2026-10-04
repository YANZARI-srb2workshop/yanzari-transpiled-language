-- Scanner's Rules
--- Identifier
--- 
--- 
--- This module handles identifier rules.
--> By Yanzari

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.utils.scanning.rules')

-- Module that handles Scanner Tokens
local Token = require('src.Scanner.utils.token')

-- Module that handles Scanner Enums
local Enum = require('src.Scanner.utils.enum')

-- A module that can convert a string into a byte array
--- and also a byte array into a string.
local Arrayizer = require('src.SourceCode.utils.Arrayizer')

-- Trie of Keywords
local Keywords = require('src.Scanner.utils.keyword_table').trie

-- the value for the Identifiers category found in the enum.
local Identifier = Enum.TokenKinds:getvalue('Identifier')

-- the value for the Keywords category found in the enum.
local Keyword = Enum.TokenKinds:getvalue('Keyword')

-- This function is used to validate the starting character
--- of the identifier.
---@param scanner Scanner the scanner to validate the characters.
local function Identifier_Start(scanner)
    local current = scanner.cursor:getCurrentCharacter()
    return (scanner.cursor:matchRangeAChar(current,65,90) -- 65 = A, 90 = Z
        or scanner.cursor:matchRangeAChar(current,97,122) -- 97 = a, 122 = z
        or scanner.cursor:matchAChar(current,95) -- 95 = _
        or current>127) -- 127 = DEL
end

-- This function is used to validate the character
--- following the start of the identifier.
---@param scanner Scanner the scanner to validate the characters.
local function Identifier_Loop(scanner)
    local current = scanner.cursor:getCurrentCharacter()
    return (Identifier_Start(scanner)==true
    or scanner.cursor:matchRangeAChar(current,48,57)) -- 48 = 0, 57 = 9
end

-- This function checks if it is a keyword.
---@param bytes byte[] a byte array.
---@return boolean is_a_keyword,number? id Returns a boolean and the Keyword ID: `true` and a `number` if it is a keyword, or `false` and `nil` if it is not.
local function Is_A_Keyword(bytes)
    local node = Keywords
    for i=1,#bytes do
        node = node[bytes[i]]
        if node==nil then
            return false,nil
        end
    end
    if type(node.id)=="number" then
        return true,node.id
    end
    return false,nil
end

-- Export
return Rules.new({
    enter=function(self)
        if Identifier_Start(self) then
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
			if not Identifier_Loop(self) then break end
			self:insertChar()
			self.cursor:advance()
		end
        local End = self.cursor:newSpan()
        local IsAKeyword,KeywordID = Is_A_Keyword(self.token)
        if IsAKeyword==true then
            return Token.new({
                kind={
                    category=Keyword,
                    keyword=KeywordID
                },
                token=self.token,
                location={
                    start=Start,
                    ['end']=End
                }
            })
        end
        return Token.new({
            kind={
                category=Identifier
            },
            token=self.token,
            location={
                start=Start,
                ['end']=End
            }
        })
    end,
    exportable = {
        Identifier_Loop=Identifier_Loop,
        Identifier=Identifier,
        Identifier_Start=Identifier_Start,
        Keywords=Keywords
    }
})