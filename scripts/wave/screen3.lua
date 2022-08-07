function f(x,n,rot) return rot*(x)+math.sin(0.2*(x+n))*10 end 
screen = peripheral.find("monitor") screen.setTextScale(0.5)
function a() screen.setBackgroundColor(colors.black) screen.clear() end
xmax,ymax = screen.getSize() iter,r = 0,0
while true do 
    sleep(0) a()
    for i = -xmax/2, xmax/2 do 
        if ((i+xmax/2)%10 == 0) then g = colors.blue else g = colors.red end 
        screen.setBackgroundColor(g)
        screen.setCursorPos(i+xmax/2 ,ymax-f(i,iter,math.cos(iter*0.025)*0.5) -ymax/2)
        screen.write(" ")
    end
    iter = iter+1
end
