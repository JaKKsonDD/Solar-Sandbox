local home = {}
love.graphics.setFont(love.graphics.newFont('assets/fonts/cour.ttf'))

function home.load()
    square = {
        x = 9,
        y = 9,
        w = 7,
        h = 14,
        mode = "fill"
    }   
    timer1 = 0
    timer2 = 0
end

function home.update(dt)
    timer1, timer2 = timer1 + dt, timer2 + dt

    if timer1 >= .5 then
        timer1 = 0
        if square.mode == "fill" then
            square.mode = "line"
        else
            square.mode = "fill"
        end
    end
    if timer >= love.math.random(0, 1) then
        timer2 = 0
        if square.x < 412 then
            square.x = square.x + 7
        else
            square.x = 412
        end
    end
end

function home.draw()
    love.graphics.print('This is a main menu, obviously. Press any button to start',10,10)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill',square.x,square.y,700,square.h)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle(square.mode,square.x,square.y,square.w,square.h)
end

return home