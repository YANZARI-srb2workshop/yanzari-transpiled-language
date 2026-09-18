-- Scanner's Rules
--- Html Tag
---
--- This module scans HTML tags.
--- 
--- Example:
--- <example> This is an example </example>
---
--- This module is a work in progress.
--> By Yanzari

-- A module that handles rules.
local Rules = require('src.Scanner.rules')

-- Enum Module
local enum = require("src.libs.enum")

-- A module that contains the Scanner's enums.
local ScannerEnums = require('src.Scanner.enum')

-- Types of HTML Tags
local HTMLTagsTypes = {
    Start=1,
    End=2
}

-- value of the JSX tag for the Scanner's Enum.
local JSXTags = ScannerEnums.TokenKinds:getvalue('JSXTag')

-- Export
return Rules.new({
    enter = function(base)
        local cur = base.current
        local next = base.next
        if base:matchAChar(cur,60) -- cur == <
        and base:matchAChar(next,47) -- next == /
        then
            table.insert(base.states,{
                type=JSXTags,
                kind=HTMLTagsTypes.End,
                ended=false
            })
            return true
        end
        if base:matchAChar(cur,60) -- cur == <
        then
            table.insert(base.states,{
                type=JSXTags,
                kind=HTMLTagsTypes.Start,
                ended=false
            })
            return true
        end
        return false
    end,
    loop = function(base)
        local State = base.states[#base.states]
        local Start = base:newSpanBasedOnCurrentPosition()
        base:advance()
        if State.kind==HTMLTagsTypes.End then
            base:advance()
        end

        -- Coming Soon
        -- ...

        local End = base:newSpanBasedOnCurrentPosition()
        base:emitToken({
            category=JSXTags
        },
        Start,
        End)
    end,
    exportable={
        JSXTags=JSXTags, -- value of the JSX tag for the Scanner's Enum.
        HTMLTagsTypes=HTMLTagsTypes -- Types of HTML Tags
    }
})