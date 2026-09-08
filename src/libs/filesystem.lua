-- Libarys
--- FileSystem
--- 
--- This class creates files, reads file content,
--- writes content to files, and appends content to files.
--- 
--> By Yanzari

-- File System
local FileSystem = {}

-- File
---@class File
---@field filename string a File Name
---@field file file*? a File
---@field mode 'r'|'w'|'a'|'r+'|'w+'|'r+'|'a+'|'rb'|'wb'|'ab'|'r+b'|'w+b'|'r+b'|'a+b' the File's Mode
local File = {}
File.__index = File

-- Available Modes for Opening Files
local AvailableOpenModes = {
    ['r']=true, -- Read Mode
    ['w']=true, -- Write Mode
    ['a']=true, -- Append Mode
    ['r+']=true, -- Update mode, all previous data is preserved
    ['w+']=true, -- Update mode, all previous data is erased
    ['a+']=true, -- Append update mode, previous data is preserved, writing is only allowed at the end of file

    ['rb']=true, -- Read Mode (Binary)
    ['wb']=true, -- Write Mode (Binary)
    ['ab']=true, -- Append Mode (Binary)
    ['r+b']=true, -- Update mode, all previous data is preserved (Binary)
    ['w+b']=true, -- Update mode, all previous data is erased (Binary)
    ['a+b']=true -- Append update mode, previous data is preserved, writing is only allowed at the end of file (Binary)
}

-- Open a File
---@param filename string the File's Name
---@param mode 'r'|'w'|'a'|'r+'|'w+'|'r+'|'a+'|'rb'|'wb'|'ab'|'r+b'|'w+b'|'r+b'|'a+b'? the File's Mode
---@return File file a File
function FileSystem.open(filename,mode)
    -- Typing Check
    if mode==nil then
        mode = "r"
    end
    assert(type(mode)=='string','Mode is not a string')
    assert(AvailableOpenModes[mode]==true,"Mode's value is not a Valid value")

    local file,err = io.open(filename,mode)
    assert(file~=nil and type(err)==nil,err)

    local self = setmetatable({},File)
    self.filename = filename
    self.mode = mode
    self.file = file
    return self
end

-- Available Modes for Reading Files
local AvailableReadModes = {
    ['*n']=true, -- reads a numeral and returns it as a float or an integer, following the lexical conventions of Lua.
    ['*a']=true, -- reads the whole file, starting at the current position.
    ['*l']=true, -- reads the next line skipping the end of line, returning fail on end of file.
    ['*L']=true -- reads the next line keeping the end-of-line character (if present), returning fail on end of file.
}

-- Read a File
---@vararg number|'*n'|'*a'|'*l'|'*L'? the Mode for Reading
---@return string|number? ... Content
function File:read(...)
    -- Typing Check
    local args = {...}
    for _,mode in ipairs(args) do
        if mode==nil then
            mode = "*l"
        end
        assert(type(mode)=='string' or type(mode)=='number','Mode is not a string or number')
        if type(mode)=='string' then
            assert(AvailableReadModes[mode]==true,"Mode's value is not a Valid value")
        end
    end
    return self.file:read(...)
end

-- Read Lines of a File
---@vararg number|'*n'|'*a'|'*l'|'*L'? the Mode for Reading
---@return fun():string|number? iterator
function File:lines(...)
    -- Typing Check
    local args = {...}
    for _,mode in ipairs(args) do
        if mode==nil then
            mode = "*l"
        end
        assert(type(mode)=='string' or type(mode)=='number','Mode is not a string or number')
        if type(mode)=='string' then
            assert(AvailableReadModes[mode]==true,"Mode's value is not a Valid value")
        end
    end
    return self.file:lines(...)
end

-- Available Modes for Seeking Files
local AvailableSeekModes = {
    ['set']=true, -- base is position 0 (beginning of the file)
    ['cur']=true, -- base is current position
    ['end']=true -- base is end of file
}

-- Seek a File
---@param whence 'set'|'cur'|'end'? a Whence
---@param offset number? a Offset
---@return number offset a Offset
---@return string? error_message a Error Message
function File:seek(whence,offset)
    -- Typing Check
    if whence==nil then
        whence = 'cur'
    end
    if offset==nil then
        offset = 0
    end
    if whence~=nil then
        assert(type(whence)=='string','Whence is not a string')
        assert(AvailableSeekModes[whence]==true,"Whence's value is not a Valid value")
    end
    if offset~=nil then
        assert(type(offset)=='number','Offset is not a number')
    end
    return self.file:seek(whence,offset)
end

-- Write Content to a File
---@vararg string|number The Content to Write
---@return file*? file a new File
---@return string? error_message a Error Message
function File:write(...)
    return self.file:write(...)
end

-- Closing a File
---@return boolean? success Was the attempt to close the file successful?
---@return string? error_message a Error Message
---@return number? error_code a Error Code
function File:close()
    return self.file:close()
end

-- Flushing a File
---@return boolean? success Was the attempt to flush the file successful?
---@return string? error_message a Error Message
---@return number? error_code a Error Code
function File:flush()
    return self.file:flush()
end

-- Type of File
---@return 'file'|'closed file'?
function File:type()
    return io.type(self.file)
end

-- Export
return FileSystem