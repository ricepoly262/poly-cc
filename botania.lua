peripherals = peripheral.getNames()
screen = peripheral.find("monitor")
readers = {}
poolcount = 9
maxmana = 1000000*poolcount


ax,ay = screen.getSize()
xmargin_min = math.floor(ax*0.1)
xmargin_max = math.floor(ax-2*(ax*0.1))

-- filter the peripherals
for k,v in pairs(peripherals) do
    if peripheral.getType(v) == "blockReader" then
        table.insert(readers,peripheral.wrap(v))
    end
end

function drawText(x,y,text)
    screen.setBackgroundColor(colors.black)
    screen.setCursorPos(x,y)
    screen.write(text)
end

function drawRedText(x,y,text)
    screen.setBackgroundColor(colors.red)
    screen.setCursorPos(x,y)
    screen.write(text)
end

function drawGreenText(x,y,text)
    screen.setBackgroundColor(colors.green)
    screen.setCursorPos(x,y)
    screen.write(text)
end

function percentBar(x,y,x2,min,max,value)
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

function comma_value(amount) -- stackoverflow 
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

screen.setBackgroundColor(colors.black)
screen.clear()

mana = 0

while true do

    local change = 0
    if mana then change = mana end

    mana = 0


    for k,v in pairs(readers) do
        local reader = v
        local data = reader.getBlockData()
        local m = data.mana

        mana = mana+m
    end

    local delta = mana-change


    --Including lots of trailing whitespace so I don't have to clear the screen every time

    drawText(xmargin_min,ay/2-2,"MANA - "..comma_value(mana).." / "..comma_value(maxmana).."  ("..math.floor((mana/maxmana)*100).."%)                                                       ")

    local pools = math.floor(mana/1000000)
    if pools>0 then
        drawText(xmargin_min,ay/2-1,pools.." pool(s)                                                                            ")
    else
        drawText(xmargin_min,ay/2-1,"                                                                                           ")
    end

    percentBar(xmargin_min,ay/2,xmargin_max,0,maxmana,mana)

    local c = #("+"..comma_value(delta))
    drawText(xmargin_min+c,ay/2+2,"                                                     ")

    if (delta>0) then
        drawGreenText(xmargin_min,ay/2+2,"+"..comma_value(delta))
    elseif(delta<0) then
        drawRedText(xmargin_min,ay/2+2,""..comma_value(delta))
    else
        drawText(xmargin_min,ay/2+2,"                                                                                                        ")
    end
end
