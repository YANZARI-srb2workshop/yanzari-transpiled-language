-- Scanner's Rules
--- WildCard
--- 
--- 
--- This module handles Parentesis, Curly Bracket & Square Bracket rules.
--> By Yanzari

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.utils.scanning.rules')

-- Module that handles Scanner Tokens
local Token = require('src.Scanner.utils.token')

-- Module that handles Scanner Enums
local Enum = require('src.Scanner.utils.enum')

-- the value for the Miscellaneous category found in the enum.
local Miscellaneous = Enum.TokenKinds:getvalue('Miscellaneous')

-- value corresponding to Parentesis in the Miscellaneous token category
local Parentesis = Enum.MiscellaneousTokenKinds:getvalue('Parentesis')

-- value corresponding to CurlyBracket in the Miscellaneous token category
local CurlyBracket = Enum.MiscellaneousTokenKinds:getvalue('CurlyBracket')

-- value corresponding to SquareBracket in the Miscellaneous token category
local SquareBracket = Enum.MiscellaneousTokenKinds:getvalue('SquareBracket')

-- values ​​corresponding to the Right and Left directions of parentheses.
local Directions = {
    Right = Enum.TokenDirection:getvalue("Right"), -- Right: )
    Left = Enum.TokenDirection:getvalue("Left") -- Left: (
}
-- Export
return Rules.new({
    enter=function(self)
        if self.cursor:matchAChar(nil,40) -- ( = 40
        or self.cursor:matchAChar(nil,41) then -- ) = 41
            table.insert(self.states,{
                id=1,
                category=Parentesis,
                is_right=self.cursor:matchAChar(nil,41)
            })
            return true
        end
        if self.cursor:matchAChar(nil,91) -- [ = 91
        or self.cursor:matchAChar(nil,93) then -- ] = 93
            table.insert(self.states,{
                id=1,
                category=SquareBracket,
                is_right=self.cursor:matchAChar(nil,93)
            })
            return true
        end
        if self.cursor:matchAChar(nil,123) -- { = 123
        or self.cursor:matchAChar(nil,125) then -- } = 125
            table.insert(self.states,{
                id=1,
                category=CurlyBracket,
                is_right=self.cursor:matchAChar(nil,125)
            })
            return true
        end
        return false
    end,
    loop=function(self)
        -- State information obtained via self.state
        ---@type {id: number,category: enum_value,is_right: boolean}
        local StateInfo = table.remove(self.states)

        --#region TypeCheckStateInfo
        assert(type(StateInfo)=='table',"state must be a table")
        assert(type(StateInfo.id)=='number',"state.id must be a number")
        assert(type(StateInfo.category)=='number',"state.category must be a number")
        assert(type(StateInfo.is_right)=='boolean',"state.is_right must be a boolean")
        assert(StateInfo.id==1,'invalid state. id must be 1.')
        --#endregion TypeCheckStateInfo
        --#region DeterminingCharacterDirection
        local Direction = Directions.Left
        if StateInfo.is_right==true then
            Direction = Directions.Right
        end
        --#endregion DeterminingCharacterDirection

        local Start = self.cursor:newSpan()
        self:insertChar()
        self.cursor:advance()
        local End = self.cursor:newSpan()
        return Token.new({
            kind={
                category=Miscellaneous,
                miscellaneous=StateInfo.category,
                direction=Direction
            },
            token=self.token,
            location={
                start=Start,
                ['end']=End
            }
        })
    end,
    exportable = {
        Directions=Directions,
        SquareBracket=SquareBracket,
        CurlyBracket=CurlyBracket,
        Parentesis=Parentesis
    }
})