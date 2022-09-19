-- Requires Advanced Peripherals
-- https://www.curseforge.com/minecraft/mc-mods/advanced-peripherals

tablepunch = require('tablepunch') -- poly-cc/lib/tablepunch.lua
bigfont = require("bigfont") -- https://pastebin.com/3LfWxRWh (bigfont by Wojbie)

xmid = 0
ymid = 0
xmax = 0
ymax = 0
WORLD_BORDER = 25000

chars = {}
oldpositions = {}

function findByType(type)
    local peripherals = peripheral.getNames()

    for k,v in pairs(peripherals) do 
        if peripheral.getType(v) == type then
            return peripheral.wrap(v)
        end
    end
    print("Found nothing matching "..type)
    return nil
end

function screenInit()
    screen = findByType("monitor")
    screen.setTextScale(0.5)
end

function clearScreen()
    screen.setBackgroundColor(colors.black)
    screen.clear()
end

function updateScreenSize()
    local x,y = screen.getSize()
    xmid = math.floor(x/2)
    ymid = math.floor(y/2)
    xmax = x
    ymax = y 
end

function drawText(x,y,text)
    screen.setBackgroundColor(colors.black)
    screen.setCursorPos(x,y)
    screen.write(text)
end

function drawText2(x,y,text)
    screen.setBackgroundColor(colors.black)
    bigfont.writeOn(screen,1,text,x,y)
end

function drawName(x,y,str)
    --print("drawing "..str.." at "..x.." "..y)
    screen.setBackgroundColor(colors.black)
    screen.setCursorPos(x-math.floor((#str)/2),y+1)
    screen.write(str)

    local tbl = tablepunch.Explode("",str)
    for k,v in pairs(tbl) do
        key = (x-math.floor((#str)/2)+k-1)..'_'..y+1
        --print(key,v)
        chars[key] = v
    end
end

detector = findByType("playerDetector")
screenInit()
clearScreen()
updateScreenSize()

while true do 
    clearScreen()
    updateScreenSize()
    chars = {}
    
    players = detector.getOnlinePlayers()
    
    local xmargin = xmid + math.floor(xmid*0.50) -- shift over 50%
    
    for i=0, ymax do
        screen.setCursorPos(xmid - math.floor(xmid*0.125),i)
        screen.setBackgroundColor(colors.white)
        screen.write(" ")
    end

    local string = "ORANGE - SPAWN,BLUE - YOU,"
    local occupied = {}

    for k,v in pairs(players) do
        local name = v 
        local detectorpos = detector.getPlayerPos(v)
        if (detectorpos == nil) then detectorpos = {"other dimension"} end 

        --quickPrint(detectorpos)
        
        --print(detectorpos == {"other dimension"})
        if not (detectorpos['x']==nil) then
            
            local x = detectorpos['x'] 
            local z = detectorpos['z']
            local relx = x/WORLD_BORDER
            local relz = z/WORLD_BORDER

            local scrx = xmargin+math.floor(xmid*relx*0.5)
            local scry = ymid+math.floor(ymid*relz)

            screen.setBackgroundColor(colors.red)
            screen.setCursorPos(scrx,scry)
            local key = scrx.."_"..scry
            local char = chars[key] or " "
            screen.write(char)

            local key = ''..scrx..''..scry
            local value = occupied[key]
            if value == nil then 
                drawName(scrx,scry,v)
                value = 1
            elseif (value > 0) then 
                drawName(scrx,scry+value,v)
                value = value + 1
            end 
            occupied[key] = value

            detectorpos['yaw'] = nil
            detectorpos['pitch'] = nil 
            detectorpos['eyeHeight'] = nil

            if oldpositions[v..'_x'] == nil then oldpositions[v..'_x'] = x end 
            if oldpositions[v..'_z'] == nil then oldpositions[v..'_z'] = z end 

            detectorpos['dx'] = math.abs(oldpositions[v..'_x']-x)
            detectorpos['dz'] = math.abs(oldpositions[v..'_z']-z)

            oldpositions[v..'_x'] = x 
            oldpositions[v..'_z'] = z

        end

        local pos = tablepunch.TableToString(detectorpos,"",true)
        string = string..", "..name..", "..pos
    end

    str = tablepunch.Explode(",",string)
    for k,v in pairs(str) do
        drawText(1,k,v)
    end


    local x,z,y = gps.locate() or 0,0,0
    --print("GPS LOCATION ",x,y,z)
    local relx = x/WORLD_BORDER
    local relz = z/WORLD_BORDER
    local scrx = xmargin+math.floor(xmid*relx*0.5)
    local scry = ymid+math.floor(ymid*relz*0.5)

    screen.setBackgroundColor(colors.blue)
    screen.setCursorPos(scrx,scry)
    local key = scrx.."_"..scry
    local char = chars[key] or " "
    screen.write(char)

    screen.setBackgroundColor(colors.orange)
    screen.setCursorPos(xmargin,ymid)
    local key = xmargin.."_"..ymid
    local char = chars[key] or " "
    screen.write(char)

    sleep(10)
end