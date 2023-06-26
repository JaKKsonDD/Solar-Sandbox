sun = {}

function sun.load()
    suns = {}
end

function sun.update()
    
end

function sun.mousepressed(x, y, button, istouch)
    if button == 1 then
        table.insert(suns, 
        {
        rate = 0.01,
        velX = 0,
        velY = 0,
        x = x,
        y = y,
        mass = 40
        })
    end
end

function sun.draw()
    for -, sun in ipairs(suns) do
        
    end
end