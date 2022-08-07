screen = peripheral.find("monitor")
screen.setTextScale(0.5)
screen.setBackgroundColor(colors.black)
screen.clear()
xmax,ymax = screen.getSize()
xmid = math.floor(xmax/2)
ymid = math.floor(ymax/2)

iter = 0
r = 0

function f(x,n,rot) return rot*(x)+math.sin(0.2*(x+n))*10 end 

while true do 
    sleep(0)
    screen.setBackgroundColor(colors.black)
    screen.clear()
    for i = -xmid, xmid do 
        if (i%10 == 0) then 
            screen.setBackgroundColor(colors.blue)
        else 
            screen.setBackgroundColor(colors.red)
        end 
        screen.setCursorPos(i+xmid ,ymax-f(i,iter,r) -ymid)
        screen.write(" ")
    end
    iter = iter+1
    r = math.cos(iter*0.025)*0.5
end
