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
table<EnumValue, number>
```

key-to-value map

## new


```lua
fun(...<EnumValue>):Enum<EnumValue>
```

## value


```lua
table<number, EnumValue>
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

 This class handles text tokenization.<br>
 It transforms the text into tokens so that the parser<br>
 can convert them into a Concrete Syntax Tree.

## __index


```lua
Scanner
```

 This class handles text tokenization.<br>
 It transforms the text into tokens so that the parser<br>
 can convert them into a Concrete Syntax Tree.

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

 emits a token and places it in the `tokens` buffer<br>
 at the buffer position determined by "self.current_output_pos".

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

 gets a character inserted into the `token` buffer.

@*param* `offset` — the offset to get the character.

## getInsertedToken


```lua
(method) Scanner:getInsertedToken(offset?: number)
  -> Token|Token[]
```

 get a token already present in the output.

 If the `offset` is not provided,<br>
 it returns all inserted tokens.

@*param* `offset` — the offset to get the Token.

## insertChar


```lua
(method) Scanner:insertChar(char?: number)
```

 inserts a character into the `token` buffer.<br>

 If the `byte` parameter has not been provided,<br>
 it inserts the character at the scanner's current position.

@*param* `char` — the character to be inserted.

## moveToTheNextOutputBuffer


```lua
(method) Scanner:moveToTheNextOutputBuffer()
```

 moves to the next output buffer.

## moveToThePreviousOutputBuffer


```lua
(method) Scanner:moveToThePreviousOutputBuffer()
```

 moves to the previous output buffer.

## new


```lua
function Scanner.new(source: SourceCode)
  -> self: Scanner
```

 Create a New Scanner

@*param* `source` — the source code. for the scanner to be able to read the source code.

@*return* `self` — an instance of the Scanner.

## removeInsertedChar


```lua
(method) Scanner:removeInsertedChar()
```

 removes the most recently inserted character from the `token` buffer.

## rules


```lua
{ [number|'EndOfFile'|'StartOfFile'|'Unknown']: ScannerRule }
```

 The Scanner rules are per instance.

 `StartOfFile`: A rule that triggers when the scanner starts scanning.
 
 `EndOfFile`: A rule that triggers when the scanner finishes scanning.

 `Unknown`: a rule that is called when the scanner encounters an unknown character.<br>
 It can be nil or not.
 
 If `Unknown` returns `true`,<br>
 it stops the scanner, and the scanner returns the final result.

 If `Unknown` returns `false`,<br>
 the scanner continues even with the unknown character.
 
 If `Unknown` is `nil`,<br>
 it stops the scanner, and the scanner returns the final result.

## runRules


```lua
(async) function Scanner.runRules(self: Scanner)
  -> thread: thread
```

@*param* `self` — self

@*return* `thread` — A thread you can use to scan the text asynchronously.

 Run Scanner Rules

 You must run the returned thread without any arguments. <br>
 the thread returns:
 ```lua
 {
   output?: Token[][] -- the final output, with the tokens produced by the scanner. This field only appears when the scanner finishes.
   token?: Token -- the token produced by the scanner, while the scanner has not yet finished. This field only appears when the scanner has not yet finished.
   number_of_tokens?: number -- number of tokens produced by the scanner. This field only appears when the scanner finishes.
   number_of_unknown_characters?: number -- number of unknown characters found by the scanner. This field only appears when the scanner finishes.
   ended: boolean -- if the scanner has finished producing the tokens.
 }
 ```

## source


```lua
SourceCode
```

the source code. for the scanner to be able to read the source code.

## states


```lua
{ [number]: string|table }
```

The scanner states; they can be used to store state information.

## token


```lua
number[]?
```

The content of a token; it contains multiple bytes.

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

 the cursor used by the Scanner to read the text and advance.

## __index


```lua
ScannerCursor
```

 the cursor used by the Scanner to read the text and advance.

## advance


```lua
(method) ScannerCursor:advance(limit?: number)
  -> nil
```

 Advances several characters.

@*param* `limit` — the character advance limit; it stops when it reaches this limit. The default value is 1.

## backtrack


```lua
(method) ScannerCursor:backtrack(marker: ScannerMarker)
  -> char: number
```

 This function causes the cursor to perform a backtracking.

@*param* `marker` — a marker to make the cursor perform backtracking.

@*return* `char` — the current character before backtracking.

## current


```lua
number?
```

the current character the cursor is on.

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

 Gets the character at the cursor's current position.

## getLocation


```lua
(method) ScannerCursor:getLocation()
  -> Span
```

 Gets the current cursor location.

## getNextCharacter


```lua
(method) ScannerCursor:getNextCharacter()
  -> number
```

 Gets the next character at the cursor's current position.

## getPreviousCharacter


```lua
(method) ScannerCursor:getPreviousCharacter()
  -> number
```

 Gets the previous character at the cursor's current position.

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

the current location of the cursor.

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
  -> an: ScannerCursor
```

 creates a new instance of the cursor

@*param* `source` — the source code that allows the scanner cursor to advance and capture characters from it.

@*return* `an` — instance of the Cursor.

## newSpan


```lua
(method) ScannerCursor:newSpan()
  -> Span
```

 creates a Span based on the current Cursor location.

## next


```lua
number?
```

the next character the cursor will pass over.

## previous


```lua
number?
```

the previous character that the cursor has already passed.

## source


```lua
SourceCode
```

the source code that allows the scanner cursor to advance and capture characters from it.


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

 a marker to make the scanner cursor backtrack.

## __index


```lua
ScannerMarker
```

 a marker to make the scanner cursor backtrack.

## col


```lua
number
```

Span's column.

## line


```lua
number
```

Span's line.

## new


```lua
function ScannerMarker.new(line: number, col: number)
  -> self: ScannerMarker
```

 creates a marker for the Scanner Cursor.

@*param* `line` — the line for the scanner to perform backtracking.

@*param* `col` — the column for the scanner to backtrack.

@*return* `self` — a marker to make the scanner cursor backtrack.


---

# ScannerRule

 the class for creating rules for the scanner.

## __index


```lua
ScannerRule
```

 the class for creating rules for the scanner.

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
  -> rule: ScannerRule
```

 Create a rule for the scanner.

@*param* `options` — an interface to create the rule.

@*return* `rule` — a rule for the scanner

## run


```lua
(method) ScannerRule:run(base: Scanner)
  -> entered: boolean
  2. token: Token?
```

 run the Rule

 The first returned argument, `entered`
 indicates whether the rule found at least one match;
 
 the second returned argument, `token`
 is the token produced by the rule.

@*param* `base` — an instance of the Scanner.


---

# ScannerRuleInterface

 the interface for the `ScannerRule` to create a Rule.

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

Span's column.

## line


```lua
number
```

Span's line.

## new


```lua
function Span.new(line: number, col: number)
  -> self: Span
```

 create a Span

@*param* `line` — the text line to construct the Span.

@*param* `col` — the text column to construct the Span.

@*return* `self` — a Span that stores position.


---

# Token

 a class that handles Scanner tokens.

## __index


```lua
Token
```

 a class that handles Scanner tokens.

## extra


```lua
any
```

Extra content for a token; for cases requiring the storage of additional information that a standard token does not hold.

## kind


```lua
TokenKind
```

the token kind

## location


```lua
{ start: Span, end: Span }
```

the location of the token.

## new


```lua
function Token.new(options: Token)
  -> token: Token
```

 Create a Token

@*param* `options` — an interface that you pass to the function, which returns a token.

@*return* `token` — a token.

## token


```lua
number[]?
```

the token content


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