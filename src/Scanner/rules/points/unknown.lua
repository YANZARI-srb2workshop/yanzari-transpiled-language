-- Scanner's Rules
--- Unknown Character
--- 
--- 
--- This module handles Unknowed rules.
--> By Yanzari

-- Module that handles Scanner Rules
local Rules = require('src.Scanner.utils.scanning.rules')

-- Export
return Rules.new({
    enter=function(self)
        return true
    end,
    loop=function(self)
        local Position = self.cursor:newSpan()
        self.errors:emit({
            text='Unknown character.',
            location={
                start=Position,
                ['end']=Position
            }
        })
        self.cursor:advance()
        return false
    end
})