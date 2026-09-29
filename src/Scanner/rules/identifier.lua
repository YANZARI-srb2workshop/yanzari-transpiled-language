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

-- Enum Module
local enum = require('src.libs.enum')

-- A module that can convert a string into a byte array
--- and also a byte array into a string.
local Arrayizer = require('src.SourceCode.utils.Arrayizer')

-- List of Keywords
local Keywords = enum.new(
    -- C++
    'alignas','alignof', -- Align
    'and','and_eq', -- And
    'auto',
    'bitand','bitor','bitxor', -- Bit Operations
    'bool',
    'break',
    'case',
    'catch',
    'char','char8_t','char16_t','char32_t', -- Char Types
    'class', -- SRB2 Lua doesn't have classes, but you can easily simulate them.
    'compl',
    'concept',
    'const','const_cast',
    'continue',
    'co_await','co_yield','co_return', -- Coroutine
    'decltype',
    'default',
    'delete',
    'do',
    'double',
    'dynamic_cast',
    'else',
    'enum',
    'explicit',
    'export',
    'extern', -- This is a C++ keyword for external entities.
    'false',
    'float', -- I like floating-point numbers. They can be useful.
    'for',
    'friend', -- I have no idea how to do this.
    -- without goto, SRB2 does not support it
    'if',
    'inline',
    'int',
    'long',
    'mutable',
    'namespace',
    'new',
    'noexcept',
    'not',
    'not_eq',
    'nullptr', -- Here, this means a null reference, because SRB2 Lua doesn't have pointers.
    'operator',
    'or','or_eq',
    'private', -- I'll come up with something for that.
    'protected', -- That depends on the metatable.
    'public',
    -- SRB2 Lua does not have registers.
    'reinterpret_cast',
    'return',
    'short',
    'signed',
    'sizeof', -- I'm going to do something cool for this keyword.
    'static',
    'static_assert',
    'static_cast',
    'struct', -- Very useful😈
    'switch',
    'template',
    'this',
    'throw',
    'true',
    'try',
    'typedef',
    'typeid',
    'typename',
    'union',
    'unsigned',
    'using',
    'virtual',
    'void',
    'volatile',
    'wchar_t',
    'while',
    'xor','xor_eq'
)

-- the value for the Identifiers category found in the enum.
local Identifier = Enum.TokenKinds:getvalue('Identifier')

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
        local IdentifierString = Arrayizer.ByteArrayToString(self.token) -- convert this byte array into strings.
        local Keyword = Keywords:getvalue(IdentifierString)
        if Keyword~=nil then
            return Token.new({
                kind={
                    category=Identifier,
                    keyword=Keyword
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