local sun = {}
love.graphics.setDefaultFilter('nearest', 'nearest')

local function getDistance(x1, y1, x2, y2)
    local horizontal_distance = x1 - x2
    local vertical_distance = y1 - y2
  
    local a = horizontal_distance ^2
    local b = vertical_distance ^2
  
    local c = a + b
    local distance = math.sqrt(c)
    return distance
end

local function changeGrowthRate(sun, dt)
    if sun.r < 75 then
      sun.rate = 0.01
    --else
      --sun.rate = sun.r / 50
    end
    return sun.r -- Return the updated value of sun.r
end

local function drawOrbitButton(button)
    love.graphics.setColor(220/255,131/225,20/225)
    love.graphics.circle('fill', button.x + button.r + 40,button.y + button.r + 40,20)
    love.graphics.setColor(1,1,1)
    -- love.graphics.setLineWidth(3)
    -- love.graphics.circle('line', button.x + button.r + 40,button.y + button.r + 40,21)
    -- love.graphics.setLineWidth(1)
    love.graphics.draw(orbitSym,button.x + button.r + 40,button.y + button.r + 40,0,1.4,1.4,orbitSym:getWidth()/2,orbitSym:getHeight()/2)
    return true
end

-- GRABBING FUNCTIONS ------------------------

local function tryGrabASun(list)
    local mouse_x, mouse_y = love.mouse.getPosition()
    
    for i,sun in ipairs(list) do
        local distance = getDistance(mouse_x, mouse_y, sun.x, sun.y)
        if distance < sun.r then
            return sun
        end
    end
end
  
local function didStartGrab()
    return love.mouse.isDown(2) and grabbed_thing == nil
end
  
local function didStopGrab()
    return not love.mouse.isDown(2) and grabbed_thing ~= nil
end

local function calculateVel(list, timer)
    recentps = {}
    for i, point in ipairs(list) do
        if point.time > (timer - 0.1) then
            table.insert(recentps, point)
        end
    end

    startp, endp = recentps[1], recentps[#recentps]
    dx, dy, dt = endp.x - startp.x, endp.y - startp.y, endp.time - startp.time
    return dx/dt, dy/dt
end
  
local function updateObject(list, dt)
    for i, object in ipairs(list) do
        object.x = object.x + object.velX * dt
        object.y = object.y + object.velY * dt
    end
end

local function moveAlongCircle(obj1, obj2, distance, speed, dt)
    -- Calculate the angular velocity based on the speed
    local angularVelocity = speed / distance

    -- Update the angle of obj1 based on the angular velocity and time
    obj1.angle = (obj1.angle + angularVelocity * dt) % (2 * math.pi)

    -- Calculate the position of obj1 based on the angle and distance
    obj1.x = obj2.x + distance * math.cos(obj1.angle)
    obj1.y = obj2.y + distance * math.sin(obj1.angle)
end

-- MERGING FUNCTIONS ----------------------

function calculateVol(r)
    local vol = 4/3 * math.pi * r^3
    return vol
end

local function circlify(objOne, objTwo)
    local objVolOne = calculateVol(objOne.r)
    local objVolTwo = calculateVol(objTwo.r)
    
    objVolOne = objVolOne + objVolTwo
    
    local rOne = (objVolOne/(4/3*math.pi))^(1/3)

    return rOne, 0
end

local function canMerge(objOne, objTwo)
    local distance = getDistance(objOne.x, objOne.y, objTwo.x, objTwo.y)
    if distance < objOne.r + objTwo.r then
        return true
    end
end

local function radOrder(one, two)
    if one.r >= two.r then
        return one, two
    else
        return two, one
    end
end

-----------------------------------------

function sun.load()
    suns = {}
    timer = 0
    drawButtons = nil
    orbitSym = love.graphics.newImage('assets/images/orbitSym.png')
end

function sun.update(dt)
    local garbage = {}

    for i, sun in ipairs(suns) do
        for v, sun2 in ipairs(suns) do
            local one, two = radOrder(sun, sun2)
            if canMerge(sun, sun2) then
                -- #sun.r, sun2.r = circlify(one, two)
                -- table.insert(garbage, sun2)
            end
        end
    end

    local mx, my = love.mouse.getPosition()
    if didStartGrab() then --grab
        grabbed_thing = tryGrabASun(suns)
        startT = timer
        points = {}
    end
    if grabbed_thing ~= nil then
        table.insert(points, {x = mx, y = my, time = timer})
        startX, startY = grabbed_thing.x, grabbed_thing.y
        if love.keyboard.isDown('tab') then
            drawButtons = grabbed_thing
        else
            grabbed_thing.x, grabbed_thing.y = mx, my
        -- select = true
        --     if select then
        --         --the moment tab is released
        --         love.mouse.setPosition(grabbed_thing.x, grabbed_thing.y)
        --         select = false
        --     end
        end
    else
        drawButtons = nil
    end
    if didStopGrab() then
        local time = timer - startT
        grabbed_thing.velX, grabbed_thing.velY = calculateVel(points, timer)--((mx - startX)/time), ((my - startY)/time)*2
        grabbed_thing = nil
    end
    updateObject(suns, dt) -- add velocity*dt to position

    for _, sun in ipairs(suns) do
        changeGrowthRate(sun, dt)
        sun.r = sun.r + sun.rate

        local distance = getDistance(sun.x, sun.y, 400, 300)
        if distance > 1600 then
            table.insert(garbage, _)
        end
    end

    for i, object in ipairs(garbage) do
        table.remove(suns, i)
    end

    if drawButtons ~= nil then
        if drawOrbitButton(drawButtons) then
        end
    end

    timer = timer + dt
end

function sun.mousepressed(x, y, button, istouch)
    if button == 1 then
        table.insert(suns, 
        {
        rate = 0.01,
        angle = 0,
        velX = 0,
        velY = 0,
        r = 40,
        x = x,
        y = y
        })
    end
end

function sun.draw()
    for i = 1, 3 do
        for _, sun in ipairs(suns) do
            if i == 1 then
                love.graphics.setColor(.9,.3,0,.2)
                love.graphics.circle("fill", sun.x, sun.y, sun.r*2)
            elseif i == 2 then
                love.graphics.setColor(.9,.3,0,.7)
                love.graphics.circle("fill", sun.x, sun.y, sun.r*1.5)
            elseif i == 3 then
                love.graphics.setColor(1,1,1)
                love.graphics.circle("fill", sun.x, sun.y, sun.r)
            end
        end
    end
    if drawButtons ~= nil then
        drawOrbitButton(drawButtons)
    end
end

return sun