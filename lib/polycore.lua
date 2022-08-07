require('table')
local polycore = {}

-- Poly's multi-use cc library, 100% organically sourced 


-- PERIPHERALS
polycore.findByType = function(type)
    local peripherals = peripheral.getNames()

    for k,v in pairs(peripherals) do 
        if peripheral.getType(v) == type then
            return peripheral.wrap(v)
        end
    end
    print("Found nothing matching "..type)
    return nil
end

-- SCREEN/MONITOR
local screen

polycore.setScreen = function(_screen)
    screen = _screen
end

polycore.screenInit = function(_screen)
    screen = _screen
    screen.setTextScale(0.5)
    screen.setBackgroundColor(colors.black)
    screen.clear()
end

polycore.clearScreen = function()
    if not screen then print("No Screen!") return false end
    screen.setBackgroundColor(colors.black)
    screen.clear()
end

polycore.getScreenSize = function()
    if not screen then print("No Screen!") return false end
    local x,y = screen.getSize()
    xmid = math.floor(x/2)
    ymid = math.floor(y/2)

    return {xmid,ymid,x,y}
end

polycore.drawText = function(x,y,text,x)
    if not screen then print("No Screen!") return false end
    if not x then screen.setBackgroundColor(colors.black) end
    screen.setTextColor(colors.white)
    screen.setCursorPos(x,y)
    screen.write(text)
end

polycore.drawLine = function(x, y, length)
    if not screen then print("No Screen!") return false end
    screen.setBackgroundColor(colors.white)
    screen.setCursorPos(x,y)
    screen.write(string.rep(" ",length))
end

polycore.drawLineVertical = function (x, y, length)
    if not screen then print("No Screen!") return false end
    screen.setBackgroundColor(colors.white)
    for i=y, length do
        screen.setCursorPos(x,i)
        screen.write(" ")
    end
end

polycore.percentBar = function(x,y,x2,min,max,value)
    if not screen then print("No Screen!") return false end
    p = value/max -- percent
    d = math.floor((x2-x)*p) -- fill
    screen.setBackgroundColor(colors.white)
    screen.setCursorPos(x,y)
    screen.write(string.rep(" ",x+(x2-x)))
    if value>0 then
        screen.setBackgroundColor(colors.red)
        screen.setCursorPos(x,y)
        screen.write(string.rep(" ",x+d))
    end
end


-- TABLES
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
