-- Scanner's Rules
--- Short String
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

-- the value for the String category found in the enum.
local String = Enum.TokenKinds:getvalue('String')

-- the value for the size category that represents small
local Short = Enum.CommentSize:getvalue('Short')

-- the value that represents the slash character.
local Slash = 92 -- \

-- Escape sequences
---
--- If the value is a byte,<br/>
--- use the value directly.
--- 
--- if the value is a function<br/>
--- execute the function to apply the characters.
--- 
--- if the key is a byte<br/>
--- use it directly for the check.
--- 
--- if the key is "number",<br/>
--- use any numeric digit.
---@type table<byte|"number",byte|fun(self: Scanner,text: byte[]): nil>
local Escape_sequences = {
	[Slash]=Slash, -- Backslash
	[34]=34, -- Double Quote
	[39]=39, -- Single Quote
	[63]=63, -- Question Mark
	[97]=0x07, -- Audible Bell
	[98]=0x08, -- Backspace
	[102]=0x0c, -- Form Feed
	[110]=0x0a, -- Line Feed
	[114]=0x0d, -- Carriage return
	[116]=0x09, -- Horizontal tab
	[118]=0x0b -- Vertical tab
}
-- Export
return Rules.new({
	enter=function(self)
		if self.cursor:matchAChar(nil,34) then -- 34 = "
			return true
		end
		if self.cursor:matchAChar(nil,39) then -- 39 = '
			return true
		end
		return false
	end,
	loop=function(self)
		local Start = self.cursor:newSpan()
		---@type 34|39
		local symbol = self.cursor:getCurrentCharacter()
		self:insertChar()
		self.cursor:advance()
		local text = {}
		while true do
			if self.cursor:isEOF() then break end
			if self.cursor:isEOL() then break end
			local curchar = self.cursor:getCurrentCharacter()
			if curchar==Slash then
				local nextchar = self.cursor:getNextCharacter()
				local escapechar
				if self.cursor:matchRangeAChar(nextchar,48,57) then
					escapechar = Escape_sequences.number
				else
					escapechar = Escape_sequences[nextchar]
				end
				if type(escapechar)=="number" then
					self:insertChar()
					self.cursor:advance()
					self:insertChar()
					text[#text+1] = escapechar
					self.cursor:advance()
				elseif type(escapechar)=="function" then
					self:insertChar()
					self.cursor:advance()
					escapechar(self,text)
				else
					local Position = self.cursor:newSpan()
					self.errors:emit({
						text='Invalid Escape Sequence.',
						location={
							start=Position,
							['end']=Position
						}
					})
					self:insertChar()
					self.cursor:advance()
				end
			elseif curchar==symbol then
				self:insertChar()
				self.cursor:advance()
				break
			else
				self:insertChar(curchar)
				text[#text+1] = curchar
				self.cursor:advance()
			end
		end
		local End = self.cursor:newSpan()
		return Token.new({
			kind={
				category=String,
				size=Short
			},
			location={
				start=Start,
				["end"]=End
			},
			token=self.token,
			extra={
				text=text
			}
		})
	end,
	exportable={}
})