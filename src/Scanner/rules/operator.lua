-- Scanner's Rules
--- Operator
--- 
--- 
--- This module handles operator rules.
--> By Yanzari

-- Module that handles Scanner Enums
local Enum = require('src.Scanner.enum')

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.rules')

-- Module that handles Scanner Tokens
local Token = require('src.Scanner.token')

-- The operator value in the Enum related to token types
local Operator = Enum.TokenKinds:getvalue('Operator')

-- module creates nodes.
local Node = require('src.libs.node')

-- List of Operators
local ListOfOperators = {
    -- Single Character.
    Single = {
        [43]=Enum.OperatorsTokenKinds:getvalue('Plus'), -- +
        [45]=Enum.OperatorsTokenKinds:getvalue('Minus'), -- -
        [42]=Enum.OperatorsTokenKinds:getvalue('Asterisk'), -- *
        [47]=Enum.OperatorsTokenKinds:getvalue('Slash'), -- /
        [37]=Enum.OperatorsTokenKinds:getvalue('Percent'), -- %
        [46]=Enum.OperatorsTokenKinds:getvalue('Dot'), -- .
        [44]=Enum.OperatorsTokenKinds:getvalue('Comma'), -- ,
        [33]=Enum.OperatorsTokenKinds:getvalue('Exclamation'), -- !
        [58]=Enum.OperatorsTokenKinds:getvalue('Colon'), -- :
        [62]=Enum.OperatorsTokenKinds:getvalue('GreaterThan'), -- >
        [60]=Enum.OperatorsTokenKinds:getvalue('LessThan'), -- <
        [61]=Enum.OperatorsTokenKinds:getvalue('Equals'), -- =
        [94]=Enum.OperatorsTokenKinds:getvalue('Circumflex'), -- ^
        [124]=Enum.OperatorsTokenKinds:getvalue('VerticalLine'), -- |
        [38]=Enum.OperatorsTokenKinds:getvalue('Ampersand'), -- &
        [126]=Enum.OperatorsTokenKinds:getvalue('Tilde'), -- ~
    },
    -- Two or More Characters.
    More = {
        [43]=true, -- +
        [45]=true, -- -
        [42]=true, -- *
        [58]=true, -- :
        [94]=true, -- ^
        [124]=true, -- |
        [38]=true, -- &
        [62]=true, -- >
        [60]=true, -- <
        [61]=true, -- =
    },
    -- A set of two or more characters that form valid operators.
    Set = {
        [43] = { -- +
            [43] = Enum.OperatorsTokenKinds:getvalue('Plus Plus'), -- ++
            [61] = Enum.OperatorsTokenKinds:getvalue('Plus Equals'), -- +=
        },
        [45] = { -- -
            [45] = Enum.OperatorsTokenKinds:getvalue('Minus Minus'), -- --
            [61] = Enum.OperatorsTokenKinds:getvalue('Minus Equals'), -- -=
        },
        [47] = { -- /
            [61] = Enum.OperatorsTokenKinds:getvalue('Slash Equals'), -- /=
        },
        [42] = { -- *
            [42] = Node.new(Enum.OperatorsTokenKinds:getvalue('Asterisk Asterisk'),{ -- **
                [61] = Enum.OperatorsTokenKinds:getvalue('Asterisk Asterisk Equals'), -- **=
            }),
            [61] = Enum.OperatorsTokenKinds:getvalue('Asterisk Equals'), -- *=
        },
        [58] = { -- :
            [58] = Enum.OperatorsTokenKinds:getvalue('Colon Colon'), -- ::
        },
        [124] = { -- |
            [124] = Enum.OperatorsTokenKinds:getvalue('VerticalLine VerticalLine'), -- ||
            [61] = Enum.OperatorsTokenKinds:getvalue('VerticalLine Equals'), -- |=
        },
        [38] = { -- &
            [38] = Enum.OperatorsTokenKinds:getvalue('Ampersand Ampersand'), -- &&
            [61] = Enum.OperatorsTokenKinds:getvalue('Ampersand Equals'), -- &=
        },
        [60] = { -- <
            [61] = Node.new(Enum.OperatorsTokenKinds:getvalue('LessThan Equals'),{ -- <=
                [62] = Enum.OperatorsTokenKinds:getvalue('LessThan Equals GreaterThan') -- <=>
            }),
            [60] = Node.new(Enum.OperatorsTokenKinds:getvalue('LessThan LessThan'),{ -- <<
                [61] = Enum.OperatorsTokenKinds:getvalue('LessThan LessThan Equals') -- <<=
            })
        },
        [61] = { -- =
            [61] = Enum.OperatorsTokenKinds:getvalue('Equals Equals') -- ==
        },
        [62] = { -- >
            [61] = Enum.OperatorsTokenKinds:getvalue('GreaterThan Equals'), -- >=
            [62] = Node.new(Enum.OperatorsTokenKinds:getvalue('GreaterThan GreaterThan'),{ -- >>
                [61] = Enum.OperatorsTokenKinds:getvalue('GreaterThan GreaterThan Equals') -- >>=
            })
        },
        [33] = { -- !
            [61] = Enum.OperatorsTokenKinds:getvalue('Exclamation Equals'), -- !=
        }
    }
}
local CustomOperator = Enum.OperatorsTokenKinds:getvalue('Custom')

return Rules.new(
    {
        enter=function(self)
            if ListOfOperators.Single[self.current] then
                return true
            end
            return false
        end,
        loop=function(self)
            local Start = self:newSpanBasedOnCurrentPosition()
            self:insertChar(self.current)
            self:advance()
            while true do
                if self:isEOF() then break end
                if self:isEOL() then break end
                if ListOfOperators.More[self.current]==nil then break end
                if #self.token>=64 then break end
                self:insertChar(self.current)
                self:advance()
            end
            local End = self:newSpanBasedOnCurrentPosition()
            if #self.token == 1 then
                local SingleCharacter = ListOfOperators.Single[self.token[1]]
                if type(SingleCharacter)=='number' then
                    return Token.new({
                        kind={
                            category=Operator,
                            operator=SingleCharacter
                        },
                        token=self.token,
                        location={
                            start=Start,
                            ["end"]=End
                        }
                    })
                end
            elseif #self.token <= 3 then
                -- First Character In The Set
                ---@type table
                local FirstCharacterInTheSet = ListOfOperators.Set[self.token[1]]
                if FirstCharacterInTheSet~=nil then
                    -- Second Character In The Set
                    ---@type Node|enum_value
                    local SecondCharacterInTheSet = FirstCharacterInTheSet[self.token[2]]
                    if type(SecondCharacterInTheSet)=='number' then
                        if #self.token>=3 then
                            return Token.new({
                                kind={
                                    category=Operator,
                                    operator=CustomOperator
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
                                category=Operator,
                                operator=SecondCharacterInTheSet
                            },
                            token=self.token,
                            location={
                                start=Start,
                                ["end"]=End
                            }
                        })
                    elseif getmetatable(SecondCharacterInTheSet)==Node then
                        if #self.token == 2 then
                            return Token.new({
                                kind={
                                    category=Operator,
                                    operator=SecondCharacterInTheSet.value
                                },
                                token=self.token,
                                location={
                                    start=Start,
                                    ["end"]=End
                                }
                            })
                        end
                        if SecondCharacterInTheSet.children~=nil then
                            local ThirdCharacterInTheSet = SecondCharacterInTheSet.children[self.token[3]]
                            if type(ThirdCharacterInTheSet)=='number' then
                                return Token.new({
                                    kind={
                                        category=Operator,
                                        operator=ThirdCharacterInTheSet
                                    },
                                    token=self.token,
                                    location={
                                        start=Start,
                                        ["end"]=End
                                    }
                                })
                            else
                                return Token.new({
                                    kind={
                                        category=Operator,
                                        operator=CustomOperator
                                    },
                                    token=self.token,
                                    location={
                                        start=Start,
                                        ['end']=End
                                    }
                                })
                            end
                        end
                    end
                end
            end
            return Token.new({
                kind={
                    category=Operator,
                    operator=CustomOperator
                },
                token=self.token,
                location={
                    start=Start,
                    ['end']=End
                }
            })
        end,
        exportable={
            Operator=Operator,
            ListOfOperators=ListOfOperators
        }
    }
)