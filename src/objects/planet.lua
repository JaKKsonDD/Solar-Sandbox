local planet = {}

-- GENERAL ------------------------
local function getDistance(x1, y1, x2, y2)
    local horizontal_distance = x1 - x2
    local vertical_distance = y1 - y2
  
    local a = horizontal_distance ^2
    local b = vertical_distance ^2
  
    local c = a + b
    local distance = math.sqrt(c)
    return distance
end
-- PLANET SPECIFIC ------------------------
-- local function drawPlanet(plnt)
--     love.graphics.setColor(.5, .5, .5)
--     love.graphics.circle("fill",plnt.x,plnt.y,plnt.r )
--     love.graphics.setColor(1, 1, 1)
-- end
-- -- GRABBING ------------------------
local function tryGrabAPlanet(list)
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
-- MERGING ------------------------
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
-----------------------------------

local suns = sun
function planet.load()
    planets = {}
    timer = 0
end

function planet.update(dt)
    local garbage = {}

    for i, plnt in ipairs(planets) do
        for v, plnt2 in ipairs(planets) do
            local one, two = radOrder(plnt, plnt2)
            if canMerge(plnt, plnt2) then
                -- #plnt.r, plnt2.r = circlify(one, two)
                -- table.insert(garbage, plnt2)
            end
        end
    end

    local mx, my = love.mouse.getPosition()
    if didStartGrab() then --grab
        grabbed_thing = tryGrabAPlanet(planets)
        startT = timer
        points = {}
    end
    if grabbed_thing ~= nil then
        table.insert(points, {x = mx, y = my, time = timer})
        startX, startY = grabbed_thing.x, grabbed_thing.y
        if not love.keyboard.isDown('tab') then
            grabbed_thing.x, grabbed_thing.y = mx, my
        end
    end
    if didStopGrab() then
        local time = timer - startT
        grabbed_thing.velX, grabbed_thing.velY = calculateVel(points, timer)--((mx - startX)/time), ((my - startY)/time)*2
        grabbed_thing = nil
    end
    updateObject(planets, dt) -- add velocity*dt to position

    for i, plnt in ipairs(planets) do
        local distance = getDistance(plnt.x, plnt.y, 400, 300)
        if distance > 1600 then
            table.insert(garbage, plnt)
        end
    end

    for object in ipairs(garbage) do
        table.remove(planets, object)
    end

    timer = timer + dt
end

function planet.mousepressed(x, y, button, istouch)
    if button == 1 then
        table.insert(planets, 
        {
        temp = -500,
        red = .5,
        grn = .5,
        blu = .5,
        velX = 0,
        velY = 0,
        r = 20,
        x = x,
        y = y
        })
    end
end

function planet.draw()
    for i, plnt in ipairs(planets) do
        love.graphics.setColor(plnt.red, plnt.grn, plnt.blu)
        -- print('r ' .. plnt.r)
        -- print('g ' .. plnt.g)
        -- print('b ' .. plnt.b)
        love.graphics.circle('fill',plnt.x,plnt.y,plnt.r)
        love.graphics.setColor(1,1,1)
    end
end

return planet