-- Generate Keywords.
---
--- This module calls the Test
--- and performs a complete test.
--> By Yanzari

-- the keyword list.
---@generic TableKey: number represents the key type of a table.
---@generic TableValue: string represents the value type of a table.
---@type {[TableKey]: TableValue}
local Keywords = {
	"alignas",
	"alignof",
	"and",
	"and_eq",
	"auto",
	"bitand",
	"bitor",
	"bitxor",
	"bool",
	"break",
	"case",
	"catch",
	"char",
	"char8_t",
	"char16_t",
	"char32_t",
	"class",
	"compl",
	"concept",
	"const",
	"const_cast",
	"continue",
	"co_await",
	"co_yield",
	"co_return",
	"decltype",
	"default",
	"delete",
	"do",
	"double",
	"dynamic_cast",
	"else",
	"enum",
	"explicit",
	"export",
	"extern",
	"false",
	"float",
	"for",
	"friend",
	"if",
	"inline",
	"import",
	"int",
	"long",
	"mutable",
	"namespace",
	"new",
	"noexcept",
	"not",
	"not_eq",
	"nullptr",
	"operator",
	"or",
	"or_eq",
	"private",
	"protected",
	"public",
	"reinterpret_cast",
	"return",
	"short",
	"signed",
	"sizeof",
	"static",
	"static_assert",
	"static_cast",
	"string",
	"struct",
	"switch",
	"template",
	"this",
	"throw",
	"true",
	"try",
	"typedef",
	"typeid",
	"typename",
	"union",
	"unsigned",
	"using",
	"virtual",
	"void",
	"volatile",
	"wchar_t",
	"while",
	"xor",
	"xor_eq"
}
-- This transforms a key-to-value table into a value-to-key table.
---@generic TableKey represents the key type of a table.
---@generic TableValue represents the value type of a table.
---@param tbl {[TableKey]:TableValue} a key-value table
---@return {[TableValue]:TableKey} reversed_tbl a value-key table
local function ReverseTable(tbl)
    local output = {}
    for k,v in pairs(tbl) do
        output[v] = k
    end
    return output
end
-- This function converts a object into a string.
---@param obj any the object that will become a string.
---@param depth number? the depth at which the Serializer is currently operating.
---@return string obj_serialized a string representing the serialized object
local function Serialize(obj,depth)
    depth = depth or 1
    local typ = type(obj)
    if typ == "number" then
        return tostring(obj)
    elseif typ=="string" then
        return '"'..obj..'"'
    elseif typ == "boolean" then
        if obj==true then
            return "true"
        elseif obj==false then
            return "false"
        end
    elseif typ=="nil" then
        return "nil"
    elseif typ=="table" then
        local output = "{\n"
        for k,v in pairs(obj) do
            output = output..string.rep("\t",depth).."["..Serialize(k,depth+1).."] = "..Serialize(v,depth+1)..",\n"
        end
        local result = output..string.rep("\t",depth-1)
        return result.."}"
    end
    return typ
end
-- This generates a Trie<br>
--- a huge table containing all the keyword IDs.
---@param tbl table<string,number> a string-to-number table.
---@return table trie a huge table of all possible byte combinations to form a keyword.
local function Trie(tbl)
    local trie = {}
    for word, id in pairs(tbl) do
        local node = trie
        for i = 1, #word-1 do
            local byte = word:byte(i,i)
            node[byte] = node[byte] or {}
            node = node[byte]
        end
        node.id = id
    end
    return trie
end

-- Now generate the file content.

-- The content of the file for generating the keywords.
---@type string[]
local FileContent = {
    "-- Scanner",
    "--- Keyword Table",
    "--- ",
    "--- ",
    "--- This file contains a keyword Trie.",
    "--- It is a more optimized way to check whether a group of bytes is a keyword.",
    "--- It does not require creating a temporary string.",
    "--- ",
    "--- This was generated automatically.",
    "--> By Yanzari",
    "",
    "return {",
    "\t".."-- a list of IDs for keywords",
    "\t".."list = ".. Serialize(Keywords,2) .. ",",
    "\t".."-- a huge table full of combinations for each keyword",
    "\t".."trie = ".. Serialize(Trie(ReverseTable(Keywords)),2),
    "}"
}
-- file name
---@type string
local FileName = "src/Scanner/utils/keyword_table.lua"
local File = io.open(FileName,"w")
if File~=nil then
    File:write(table.concat(FileContent,"\n"))
    File:flush()
    File:close()
end