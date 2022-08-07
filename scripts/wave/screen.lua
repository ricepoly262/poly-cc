xmid, ymid, xmax, ymax = nil

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

function pointred(x,y)
    screen.setBackgroundColor(colors.red)
    screen.setCursorPos(x,y)
    screen.write(" ")
end 
function pointblue(x,y)
    screen.setBackgroundColor(colors.blue)
    screen.setCursorPos(x,y)
    screen.write(" ")
end
function f(x,n,rot) return rot*(x)+math.sin(0.2*(x+n))*10 end 

function generate(n,r)
    local vals = {}
    for i = -xmid, xmid do
        local y = f(i,n,r) 
        --print("generating value for x:"..i.." y:"..y)
        vals[i]=y 
    end
    return vals 
end

function draw(t)
    for k,v in pairs(t) do 
        local x = k+xmid 
        local y = ymax-v-ymid 
        --print("drawing point at x:"..x.." y:"..y)
        if (k%10 == 0) then 
            pointblue(x,y)
        else pointred(x,y)
        end 

    end

end 


monitor = findByType("monitor")
screenInit()
clearScreen()
updateScreenSize()

local iter = 0
local r = 0

while true do 
    sleep(0)
    clearScreen()
    draw(generate(iter,r))
    iter = iter+1

    r = math.cos(iter*0.025)*0.5
    print(r)
end
