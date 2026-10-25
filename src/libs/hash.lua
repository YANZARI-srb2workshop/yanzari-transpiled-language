-- Libarys
--- Hash
--- 
--- Creates and updates a hash.
--- Can be used for identifiers or other purposes.
--> By Yanzari

-- Creates and updates a hash.
local Hash = {}

-- initializes or updates the hash
--
-- #define HT_HASHSTEP(r, c) ((r) * 67 + ((c) - 113));
---@source https://github.com/gcc-mirror/gcc/blob/master/libcpp/include/symtab.h
---@param hash number the previous hash (or 0, if creating the hash)
---@param var1 number the variable used to create the hash
---@return number hash new hash
function Hash.Step(hash,var1)
    return ((hash) * 67 + ((var1) - 113))
end

-- end the hash.
--
-- #define HT_HASHFINISH(r, len) ((r) + (len))
---@source https://github.com/gcc-mirror/gcc/blob/master/libcpp/include/symtab.h
---@param hash number the previous hash (or 0, if creating the hash)
---@param length number the size of the variable.
---@return number hash new hash
function Hash.Finish(hash,length)
    return (hash) + (length)
end

-- Export
return Hash