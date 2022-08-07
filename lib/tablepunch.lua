local expect = require "cc.expect"
local expect, field = expect.expect, expect.field

-- Sourced from Facepunch's libraries for Garry's Mod, edited to work with CC.

local tablepunch = {}
    local isnumber = function(n) return type(n)=="number" end
    local isbool = function(b) return type(b)=="boolean" end
    local isstring = function(s) return type(s)=="string" end
    local istable = function(t) return type(t)=="table" end

    local tostring = function(v)
        if istable(v) then return "[TABLE]" end
        return v
    end
    
    --[[----------------------------------------------------------------------
    Source: https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/string.lua#L8-L16=
    (Modified)
    -------------------------------------------------------------------------]]
    tablepunch.ToTable = function(v)
        if isstring(v) then
            local ret = {}
            for i=1, #v do
                ret[i] = string.sub(v, i, i)
            end
            return ret
        end
        return {v}
    end

    --[[----------------------------------------------------------------------
    Name: IsSequential( table )
    Desc: Returns true if the table's keys are sequential
    Source: https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/table.lua#L192-L199=
    -------------------------------------------------------------------------]]
    tablepunch.IsSequential = function(t)
        expect(1, t, "table")

        local i = 1
        for k,v in pairs(t) do
            if (t[i] == nil) then return false end
            i = i + 1
        end
        return true
    end

    --[[---------------------------------------------------------
    Source: https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/table.lua#L208-L263=
    -----------------------------------------------------------]]
    MakeTable = function(t, nice, indent, done)
        local str = ""
        local done = done or {}
        local indent = indent or 0
        local idt = ""
        if nice then idt = string.rep( "\t", indent ) end
        local nl, tab  = "", ""
        if ( nice ) then nl, tab = "\n", "\t" end

        local sequential = tablepunch.IsSequential( t )

        for key, value in pairs(t) do

            str = str .. idt .. tab .. tab

            if not sequential then
                if ( isnumber( key ) or isbool( key ) ) then
                    key = "[" .. tostring( key ) .. "]" .. tab .. "="
                else
                    key = tostring( key ) .. tab .. "="
                end
            else
                key = ""
            end

            if ( istable( value ) and not done[ value ] ) then
                done[ value ] = true
                str = str .. key .. tab .. '{' .. nl .. MakeTable (value, nice, indent + 1, done)
                str = str .. idt .. tab .. tab ..tab .. tab .."},".. nl
            else
                
                if ( isstring( value ) ) then
                    value = '"' .. tostring( value ) .. '"'
                else
                    value = tostring( value )
                end

                str = str .. key .. tab .. value .. "," .. nl

            end

        end
        return str
    end

    --[[----------------------------------------------------------------------
    Name: ToString( table,name,nice )
	Desc: Convert a simple table to a string
	Parameters: 
        table = the table you want to convert (table)
		name  = the name of the table (string)
		nice  = whether to add line breaks and indents (bool)
    Source: https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/table.lua#L265-L272=
    -------------------------------------------------------------------------]]
    tablepunch.TableToString = function( t, n, nice )
        expect(1, t, "table")
        expect(2, n, "string", "nil")
        expect(3, nice, "boolean", "nil")

        local nl, tab  = "", ""
        if ( nice ) then nl, tab = "\n", "\t" end

        local str = ""
        if ( n ) then str = n .. tab .. "=" .. tab end
        return str .. "{" .. nl .. MakeTable( t, nice ) .. "}"
    end

    --[[---------------------------------------------------------
    Name: explode(seperator, string)
    Desc: Takes a string and turns it into a table
    Source: https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/string.lua#L81-L98=
    -----------------------------------------------------------]]
    tablepunch.Explode = function(separator, str, withpattern)
        expect(1, separator, "string")
        expect(2, str, "string")
        expect(3, withpattern, "boolean", "nil")

        if ( separator == "" ) then return tablepunch.ToTable( str ) end
        if ( withpattern == nil ) then withpattern = false end

        local ret = {}
        local current_pos = 1

        for i = 1, #str do
            local start_pos, end_pos = string.find( str, separator, current_pos, not withpattern )
            if ( not start_pos ) then break end
            ret[ i ] = string.sub( str, current_pos, start_pos - 1 )
            current_pos = end_pos + 1
        end

        ret[ #ret + 1 ] = string.sub( str, current_pos )

        return ret
    end