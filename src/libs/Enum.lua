local Enum = {}
Enum.__index = Enum
function Enum.new(...)
    local args,output = {...},{...}
    for k,v in ipairs(args) do
        output[v] = k
    end
    local self = setmetatable({},Enum)
    self.key = output
    self.value = args
    return self
end
return Enum