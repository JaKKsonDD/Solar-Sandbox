home = {}
love.graphics.setFont(love.graphics.newFont('assets/fonts/cour.ttf'))

function home.load()
    square = {
        x = 412,
        y = 9,
        w = 7,
        h = 14,
        mode = "fill"
    }   
    timer = 0
end

function home.update(dt)
    timer = timer + dt

    if timer >= .5 then
        timer = 0
        if square.mode == "fill" then
            square.mode = "line"
        else
            square.mode = "fill"
        end
    end
end

function home.draw()
    love.graphics.print('This is a main menu, obviously. Press any button to start',10,10)
    love.graphics.rectangle(square.mode,square.x,square.y,square.w,square.h)
end