sun = {}

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
  
local function updateObject(list, dt)
    for i, object in ipairs(list) do
        object.x = object.x + object.velX * dt
        object.y = object.y + object.velY * dt
    end
end

-- MERGING FUNCTIONS ----------------------

function calculateVol(r)
-- convert radius to volume
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
    end
    if grabbed_thing ~= nil then
        startX, startY = grabbed_thing.x, grabbed_thing.y
        grabbed_thing.x, grabbed_thing.y = mx, my
    end
    if didStopGrab() then
        local time = timer - startT
        grabbed_thing.velX, grabbed_thing.velY = ((mx - startX)/time), ((my - startY)/time)*2
        grabbed_thing = nil
    end
    updateObject(suns, dt) -- add velocity*dt to position

    for i, sun in ipairs(suns) do
        changeGrowthRate(sun, dt)
        sun.r = sun.r + sun.rate

        local distance = getDistance(sun.x, sun.y, 400, 300)
        if distance > 1600 then
            table.insert(garbage, sun)
        end
    end

    for object in ipairs(garbage) do
        table.remove(suns, object)
    end

    timer = timer + dt
end

function sun.mousepressed(x, y, button, istouch)
    if button == 1 then
        print('pressed')
        table.insert(suns, 
        {
        rate = 0.01,
        velX = 0,
        velY = 0,
        r = 40,
        x = x,
        y = y
        })
    end
    
end

function sun.draw()
    for i, sun in ipairs(suns) do
        love.graphics.setColor(1, .4, .1)
        love.graphics.circle("fill", sun.x, sun.y, sun.r)
    end
end