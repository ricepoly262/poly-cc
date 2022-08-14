require('table')
local polytable = {}

-- Poly's multi-use table library for cc, 100% organically sourced 

local function istable(t) return type(t)=="table" end
local function isstring(s) return type(s)=="string" end

local function generatespacer(l)
    local str = ""
    for i=0,l do
        str = str.."        "
    end
    return str
end

local function valuetostring(t,l)
    local spacer = generatespacer(l)
    if istable(t) then
        local s = " {\n"
        for k,v in pairs(t) do
            s = s..spacer.."["..k..", "..type(v).."] = "..valuetostring(v,l+1).."\n"
        end
        return (s..generatespacer(l-1).."}")
    else
        if isstring(t) then
            return "'"..t.."'"
        else
            return t
        end
    end
end


polycore.TableToString = function(t)
    local spacer = "        "
    local s = "table {\n"

    if istable(t) then
        for k,v in pairs(t) do
            s = s..spacer.."["..k..", "..type(v).."] = "..valuetostring(v,1).."\n"
        end
        return (s.."}")
    else
        if isstring(t) then
            return "'"..t.."'"
        else
            return t
        end
    end
end

polycore.printTable = function(t) print(polycore.TableToString(t)) end