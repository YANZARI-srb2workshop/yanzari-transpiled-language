# Enum

 Enums

## __index


```lua
Enum
```

 Enums

## getkey


```lua
fun(self: Enum, value: number):<EnumValue>
```

## getvalue


```lua
fun(self: Enum, key: <EnumValue>):number
```

## key


```lua
table<number, EnumValue>
```

key-to-value map

## new


```lua
fun(...<EnumValue>):Enum<EnumValue>
```

## value


```lua
table<EnumValue, number>
```

value-to-key map


---

# ErrorInterface

 Error Interface

## location


```lua
{ start: Span, end: Span }
```

error span

## text


```lua
string
```

error message


---

# File

 File

## __index


```lua
File
```

 File

## close


```lua
(method) File:close()
  -> success: boolean?
  2. error_message: string?
  3. error_code: number?
```

 Closing a File

@*return* `success` — Was the attempt to close the file successful?

@*return* `error_message` — a Error Message

@*return* `error_code` — a Error Code

## file


```lua
file*?
```

a File

## filename


```lua
string
```

a File Name

## flush


```lua
(method) File:flush()
  -> success: boolean?
  2. error_message: string?
  3. error_code: number?
```

 Flushing a File

@*return* `success` — Was the attempt to flush the file successful?

@*return* `error_message` — a Error Message

@*return* `error_code` — a Error Code

## lines


```lua
(method) File:lines(...(number|'*L'|'*a'|'*l'|'*n')?)
  -> iterator: fun():(string|number)?
```

 Read Lines of a File

@*return* `iterator` — an iterator to iterate over the lines of the file.

## mode


```lua
'a'|'a+'|'a+b'|'ab'|'r'...(+7)
```

the File's Mode

## read


```lua
(method) File:read(...(number|'*L'|'*a'|'*l'|'*n')?)
  -> ...(string|number)?
```

 Read a File

@*return* `...` — Content

## seek


```lua
(method) File:seek(whence?: 'cur'|'end'|'set', offset?: number)
  -> offset: number
  2. error_message: string?
```

 Seek a File

@*param* `whence` — a Whence

@*param* `offset` — a Offset

@*return* `offset` — a Offset

@*return* `error_message` — a Error Message

```lua
whence:
    | 'set'
    | 'cur'
    | 'end'
```

## type


```lua
(method) File:type()
  -> ('closed file'|'file')?
```

 Type of File

```lua
return #1:
    | 'file'
    | 'closed file'
```

## write


```lua
(method) File:write(...string|number)
  -> file: file*?
  2. error_message: string?
```

 Write Content to a File

@*return* `file` — a new File

@*return* `error_message` — a Error Message


---

# LuaLS


---

# Node

 Node

## children


```lua
table?
```

## new


```lua
function Node.new(value: any, children?: table)
  -> self: Node
```

 Create a Node

@*param* `value` — the value of the node.

@*param* `children` — the children belonging to the node.

@*return* `self` — a Node

## value


```lua
any
```


---

# Scanner

 Scanner

## __index


```lua
Scanner
```

 Scanner

## current_output_pos


```lua
number
```

the output buffer position.

## cursor


```lua
ScannerCursor
```

The Scanner Cursor

## emitToken


```lua
(method) Scanner:emitToken(token: Token)
```

 Emit a Token

@*param* `token` — Token to Emit

## errors


```lua
ScannerErrorBucket
```

a bucket that stores all the warnings issued.

## extra


```lua
any
```

Expandable content in the Scanner.

## getInsertedChar


```lua
(method) Scanner:getInsertedChar(offset?: number)
  -> number|number[]
```

 Get a Inserted char

@*param* `offset` — the offset to get the character.

## getInsertedToken


```lua
(method) Scanner:getInsertedToken(offset?: number)
  -> Token|Token[]
```

 Get a Inserted Token

@*param* `offset` — the offset to get the Token.

## insertChar


```lua
(method) Scanner:insertChar(char?: number)
```

 Insert a char

@*param* `char` — the character to be inserted.

## new


```lua
function Scanner.new(source: SourceCode)
  -> self: Scanner
```

 Create a New Scanner

@*param* `source` — The Source Code

## removeInsertedChar


```lua
(method) Scanner:removeInsertedChar()
```

 Remove a Inserted char

## rules


```lua
ScannerRule[]
```

 Scanner Rules

## runRules


```lua
(async) function Scanner.runRules(self: Scanner)
  -> thread: thread
```

@*param* `self` — self

@*return* `thread` — A thread you can use to scan the text asynchronously.

 Run Scanner Rules

 You must run the returned thread without any arguments.

## skipToTheNextOutputBuffer


```lua
(method) Scanner:skipToTheNextOutputBuffer()
```

 Skip to the Next Output Buffer

## skipToThePreviousOutputBuffer


```lua
(method) Scanner:skipToThePreviousOutputBuffer()
```

 Skip to the Previous Output Buffer

## source


```lua
SourceCode
```

The Source Code

## states


```lua
{ [number]: string|table }
```

Scanner states

## token


```lua
number[]?
```

The Token Content

## tokens


```lua
Token[][]
```

a buffer containing all the stored tokens

## warnings


```lua
ScannerErrorBucket
```

a bucket that stores all the errors issued.


---

# ScannerCursor

 Scanner Cursor

## __index


```lua
ScannerCursor
```

 Scanner Cursor

## advance


```lua
(method) ScannerCursor:advance(limit?: number)
  -> nil
```

 Advance a Token

@*param* `limit` — the Advance Limit

## back


```lua
(method) ScannerCursor:back(marker: ScannerMarker)
  -> char: number
```

 turn back

@*param* `marker` — a marker to be able to go back

@*return* `char` — the current character before returning.

## current


```lua
number?
```

The Current Character

## getCharacter


```lua
(method) ScannerCursor:getCharacter(line: number, column: number)
  -> char: number
```

 Return character based on the `line` and `column` parameters.

 If the `line` parameter is greater than 1: returns the character in the column specified by
 the `column` parameter + 1, where the line is the current line + `line` parameter.
 
 If the `line` parameter is 0: returns the character in the column is
 the `column` parameter + current column and the line is the
 current line.

@*param* `line` — line relative to the current line.

@*param* `column` — column relative to the current column.

@*return* `char` — the line-related character.

## getCurrentCharacter


```lua
(method) ScannerCursor:getCurrentCharacter()
  -> number
```

 Get the Current Character

## getLocation


```lua
(method) ScannerCursor:getLocation()
  -> Span
```

 Get the Cursor Location

## getNextCharacter


```lua
(method) ScannerCursor:getNextCharacter()
  -> number
```

 Get the Next Character

## getPreviousCharacter


```lua
(method) ScannerCursor:getPreviousCharacter()
  -> number
```

 Get the Previous Character

## isEOF


```lua
(method) ScannerCursor:isEOF()
  -> EOF: boolean
```

 Is this the end of the file or not?

@*return* `EOF` — Is it the end of the file?

## isEOL


```lua
(method) ScannerCursor:isEOL()
  -> EOL: boolean
```

 Is this the end of the line or not?

@*return* `EOL` — Is it the end of the line?

## location


```lua
Span
```

Cursor location

## matchAChar


```lua
(method) ScannerCursor:matchAChar(the_char_used_for_match?: number, the_char_to_match: number)
  -> result: boolean
```

 tries to compare whether two characters are equal

@*param* `the_char_used_for_match` — The Character Used For Matching

@*param* `the_char_to_match` — The Character to Matching

@*return* `result` — the result of the match.

## matchOutOfRangeAChar


```lua
(method) ScannerCursor:matchOutOfRangeAChar(the_char_used_for_match?: number, start_range: number, end_range: number)
  -> result: boolean
```

 tries to compare whether the character
 is outside the range between `start_range` and `end_range`

@*param* `the_char_used_for_match` — The Character Used For match

@*param* `start_range` — The start of the range

@*param* `end_range` — The end of the range

@*return* `result` — the result of the match.

## matchRangeAChar


```lua
(method) ScannerCursor:matchRangeAChar(the_char_used_for_match?: number, start_range: number, end_range: number)
  -> result: boolean
```

 tries to compare whether the character
 is within the range between `start_range` and `end_range`

@*param* `the_char_used_for_match` — The Character Used For match

@*param* `start_range` — The start of the range

@*param* `end_range` — The end of the range

@*return* `result` — the result of the match.

## new


```lua
function ScannerCursor.new(source: SourceCode)
  -> ScannerCursor
```

 Create a new Cursor

## newSpan


```lua
(method) ScannerCursor:newSpan()
  -> Span
```

 the Cursor's current position in a new Span.

## next


```lua
number?
```

The Next Character

## previous


```lua
number?
```

The Previous Character

## source


```lua
SourceCode
```

The Source Code


---

# ScannerErrorBucket

 Scanner Error Bucket

## __index


```lua
ScannerErrorBucket
```

 Scanner Error Bucket

## bucket


```lua
ErrorInterface[]
```

a bucket that stores all the errors issued

## emit


```lua
(method) ScannerErrorBucket:emit(options: ErrorInterface)
```

 Emit a Error

@*param* `options` — a Error Interface

## new


```lua
function ScannerErrorBucket.new()
  -> ScannerErrorBucket
```

 Create a Error Bucket


---

# ScannerMarker

 a marker to be able to go back

## __index


```lua
ScannerMarker
```

 a marker to be able to go back

## col


```lua
number
```

Column

## line


```lua
number
```

Line

## new


```lua
function ScannerMarker.new(line: number, col: number)
  -> ScannerMarker
```

 Creates a marker so the scanner can backtrack.

@*param* `line` — the line for the scanner to move backward

@*param* `col` — the column for the scanner to move backward


---

# ScannerRule

 Rule Class

## __index


```lua
ScannerRule
```

 Rule Class

## enter


```lua
fun(base: Scanner):boolean
```

when you call the rule's scanning function.

## exit


```lua
(fun(base: Scanner):nil)?
```

when the rule scan is complete.

## exportable


```lua
table?
```

exportable content.

## loop


```lua
fun(base: Scanner):Token?
```

when the rule scan was accepted.

## new


```lua
function ScannerRule.new(options: ScannerRuleInterface)
  -> ScannerRule
```

 Create a new Rules

## run


```lua
(method) ScannerRule:run(base: Scanner)
  -> entered: boolean
  2. token: Token?
```

 Run the Rule

 The first returned argument, `entered`
 indicates whether the rule found at least one match;
 
 the second returned argument, `token`
 is the token produced by the rule.

@*param* `base` — an instance of the Scanner.


---

# ScannerRuleInterface

 Rule Class Interface

## enter


```lua
fun(base: Scanner):boolean
```

when you call the rule's scanning function.

## exit


```lua
(fun(base: Scanner):nil)?
```

when the rule scan is complete.

## exportable


```lua
table?
```

exportable content.

## loop


```lua
fun(base: Scanner):Token?
```

when the rule scan was accepted.


---

# SourceCode

 Source Code

## __index


```lua
SourceCode
```

 Source Code

## content


```lua
SourceCodeContent
```

 Source Code's Content

## filename


```lua
string?
```

File's Name

## new


```lua
fun(options: SourceCodeInterface):SourceCode
```


---

# SourceCodeContent

 Source Code's Content

## normalized


```lua
number[][]
```

the normalized content of the file

## raw


```lua
string
```

the raw content of the file


---

# SourceCodeInterface

 Source Code Interface

## content


```lua
string
```

File's Content

## filename


```lua
string?
```

File's Name


---

# Span

 Span

## __index


```lua
Span
```

 Span

## col


```lua
number
```

Column

## line


```lua
number
```

Line

## new


```lua
function Span.new(line: number, col: number)
  -> self: Span
```

 Create a Span

@*param* `line` — Text's Line

@*param* `col` — Text's Column


---

# Token

 Token

## __index


```lua
Token
```

 Token

## extra


```lua
any
```

Extra content for Token

## kind


```lua
TokenKind
```

 Kind of a Token

## location


```lua
{ start: Span, end: Span }
```

the Token Location

## new


```lua
function Token.new(options: Token)
  -> self: Token
```

 Create a Token

## token


```lua
number[]?
```

The Token Content


---

# TokenKind

 Kind of a Token

## category


```lua
number
```

Token Category

## direction


```lua
number?
```

Token Direction (used only for parentheses, braces, and brackets)

## keyword


```lua
number?
```

the keyword category for a Token (for keywords only).

## miscellaneous


```lua
number?
```

Miscellaneous token category.

## operator


```lua
number?
```

Token Operator Category

## size


```lua
number?
```

Comment Size (used only for Comment Token)


---

# byte

 a byte of a string.


---

# enum_value

 a enum value.


---

# error

 a error message.


---

# error_code

 a error code.