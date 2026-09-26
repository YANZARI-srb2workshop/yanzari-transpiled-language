-- Scanner's Rules
--- Indentation
--- 
--- 
--- This module handles indentation.
--> By Yanzari

-- Module that handles Scanner Enums
local Enum = require('src.Scanner.enum')

-- Enum Module
local enum = require('src.libs.enum')

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.rules')

-- Module that handles Scanner Tokens
local Token = require('src.Scanner.token')

-- Module that handles space rules.
local Space = require('src.Scanner.rules.layout.space')

-- Module that is shared across the rules
local Shared = require('src.Scanner.rules.shared')

-- List of WhiteSpaces
---@type table<byte,boolean>
local ListOfWhiteSpaces = Space.exportable.ListOfWhiteSpaces

-- the number for the space character
local SpaceChar = Shared.Space

-- the number for the tab character
local TabChar = Shared.Tab

-- Types of indentation
local typesOfIndentation = enum.new(
	'None',
	'Tabs',
	'Spaces',
	'Mixed'
)

-- Indent
local Indent = Enum.TokenKinds:getvalue('Indent')

-- Dedent
local Dedent = Enum.TokenKinds:getvalue('Dedent')

-- the indentation type that represents neither.
local TypeOfIndentation_None = typesOfIndentation:getvalue('None')

-- the indentation type that represents tabs.
local TypeOfIndentation_Tabs = typesOfIndentation:getvalue('Tabs')

-- the indentation type that represents spaces.
local TypeOfIndentation_Spaces = typesOfIndentation:getvalue('Spaces')

-- the indentation type that represents a mixture of tabs and spaces.
local TypeOfIndentation_Mixed = typesOfIndentation:getvalue('Mixed')

-- Check Scanner.extra to see if everything is correct.
---@param self Scanner the Scanner
---@return boolean correct Is everything correct?
local function CheckExtra(self)
	return (type(self.extra)=='table' -- self.extra == table
			and type(self.extra.indentation)=='table' -- self.extra.indentation == table
			and type(self.extra.indentation.spaces)=='number' -- self.extra.indentation.spaces == number
			and type(self.extra.indentation.tabs)=='number' -- self.extra.indentation.tabs == number
			and type(self.extra.indentation.stack)=='table' -- self.extra.indentation.stack == number[]
			and type(self.extra.indentation.type)=='number') -- self.extra.indentation.type == enum value
end

-- Export
return Rules.new({
	enter=function(self)
		if type(self.extra)=="table"
		and self.extra.indentation == nil then
			return true
		end
		if self:isEOL() then
			return true
		end
		return false
	end,
	loop=function(self)
		-- Skip EOL
		--#region SkipEOL
		do
			-- This variable holds a boolean value and is used to skip the line break.
			local skipEOL = self:isEOL()
			if skipEOL==true then
				self:advance()
			end
		end
		--#endregion SkipEOL

		-- initializes `self.extra.indentation`
		--#region initIndentation
		do
			if CheckExtra(self)~=true then
				self.extra.indentation = {
					spaces=0, -- space count
					tabs=0, -- tab count
					stack={0}, -- the Indentation Stack
					type=TypeOfIndentation_None
				}
			end
		end
		--#endregion initIndentation

		-- Reads spaces or tabs
		--#region readSpacesOrTabs

		-- the current indentation
		local IndentationCount = 0
		local Start = self:newSpanBasedOnCurrentPosition()
		do
			while true do
				if self:isEOF() then break end
				if ListOfWhiteSpaces[self.current] ~= true then break end
				if self.current==SpaceChar then
					self.extra.indentation.spaces = self.extra.indentation.spaces+1
				end
				if self.current==TabChar then
					self.extra.indentation.tabs = self.extra.indentation.tabs+1
					IndentationCount = IndentationCount+3
				end
				IndentationCount = IndentationCount+1
				self:advance()
			end
		end
		local End = self:newSpanBasedOnCurrentPosition()
		--#endregion readSpacesOrTabs

		-- Emits indentation tokens.
		--#region emitIndentationTokens
		do
			-- the old indentation
			local OldIndentation = self.extra.indentation.stack[#self.extra.indentation.stack]
			if OldIndentation < IndentationCount then
				table.insert(self.extra.indentation.stack,IndentationCount)
				self:emitToken(Token.new({
					kind={
						category=Indent
					},
					location={
						start=Start,
						['end']=End
					}
				}))
			elseif OldIndentation > IndentationCount then
				while true do
					-- the indentation of the first item on the stack
					local OldIndentationNow = self.extra.indentation.stack[#self.extra.indentation.stack]

					if OldIndentationNow==IndentationCount then
						break
					end
					if IndentationCount>self.extra.indentation.stack[#self.extra.indentation.stack-1] then
						self:emitError({
							text='Inconsistent indentation.',
							location={
								start=Start,
								['end']=End
							}
						})
						break
					end
					self:emitToken(Token.new({
						kind={
							category=Dedent
						},
						location={
							start=Start,
							['end']=End
						}
					}))
					table.remove(self.extra.indentation.stack)
				end
			end
		end
		--#endregion emitIndentationTokens

		-- Finally, update the indentation type.
		--#region updateTheIndentationType
		do
			if self.extra.indentation.spaces==0
			and self.extra.indentation.tabs==0 then
				self.extra.indentation.type=TypeOfIndentation_None
			elseif self.extra.indentation.spaces>self.extra.indentation.tabs then
				self.extra.indentation.type=TypeOfIndentation_Spaces
			elseif self.extra.indentation.spaces<self.extra.indentation.tabs then
				self.extra.indentation.type=TypeOfIndentation_Tabs
			elseif self.extra.indentation.spaces==self.extra.indentation.tabs then
				self.extra.indentation.type=TypeOfIndentation_Mixed
			end
		end
		--#endregion updateTheIndentationType
		return nil
	end
})