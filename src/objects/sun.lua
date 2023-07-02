sun = {}

--

local function getDistance(x1, y1, x2, y2)
    local horizontal_distance = x1 - x2
    local vertical_distance = y1 - y2
  
    local a = horizontal_distance ^2
    local b = vertical_distance ^2
  
    local c = a + b
    local distance = math.sqrt(c)
    return distance
end
  
local function tryGrabASun(list)
    local mouse_x, mouse_y = love.mouse.getPosition()
    
    for i,sun in ipairs(list) do
        local distance = getDistance(mouse_x, mouse_y, sun.x, sun.y)
        if distance < sun.r then
            return sun
        end
    end
end
  
local function changeGrowthRate(sun, dt)
    if sun.r < 75 then
      sun.rate = 0.01
    else
      sun.rate = sun.r/50
    end
end
  
local function didStartGrab()
    return love.mouse.isDown(2) and grabbed_thing == nil
end
  
local function didStopGrab()
    return not love.mouse.isDown(2) and grabbed_thing ~= nil
end
  
local function updateObject(object, dt)
    object.x = object.x + object.velX * dt
    object.y = object.y + object.velY * dt
end

--

function calculateVol(r)
-- convert radius to volume
    local vol = 4/3 * math.pi * r^3
    return vol
end

local function circlify(objOne, objTwo)
    local objVolOne = calculateVol(objOne.r)
    local objVolTwo = calculateVol(objTwo.r)
    
    objVolOne = objVolOne + objVolTwo
    objVolTwo = 0
    
    local rOne = (objVolOne/(4/3*math.pi))^(1/3)

    return rOne, objVolTwo
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

--

function sun.load()
    suns = {}
    timer = 0
end

function sun.update(dt)
    if #suns > 1 then
        for i, sun in ipairs(suns) do
            for v, sun2 in ipairs(suns) do
                local one, two = radOrder(sun, sun2)
                if canMerge(sun, sun2) then
                    sun.r, sun2.r = circlify(one, two)
                end
            end
        end
    end


    local mx, my = love.mouse.getPosition()
  
    if didStartGrab() then
        grabbed_thing = tryGrabASun(suns)
        startX, startY = mx, my
        startT = timer
    elseif didStopGrab() then
        local time = timer - startT
        grabbed_thing.velX, grabbed_thing.velY = (mx - startX)/(time), (my - startY)/(time)
        grabbed_thing = nil
    end
  
    for i, sun in ipairs(suns) do
        updateObject(sun, dt) -- add velocity*dt to position
        if love.mouse.isDown(2) then
            if getDistance(mx, my, sun.x, sun.y) < sun.r then
            sun.x, sun.y = mx, my
            end
        end
    end   
    for i, sun in ipairs(suns) do
        if sun.typ == "sun" then
            changeGrowthRate(sun, dt)
        end
    end

    timer = timer + dt
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
        r = 40
        })
    end
    
end

function sun.draw()
    for i, sun in ipairs(suns) do
        love.graphics.setColor(1, .4, .1)
        love.graphics.circle("fill", sun.x, sun.y, sun.r)
    end
end