-----WIP
-- --more planets, spawn dwarves, planets, gas giants, other ... index at the top, chose numbers to select type (moons?)
-- --suns explode and grow faster when bigger!  (BLACK HOLE)
-- --lock and orbit planets ... hold tab
-- --add debug and info, (population, heat, mass, only when sun pressed, circle appears around sun)
-- --add effects (explosion on collision, )
-- --planets get life and life evolves and goes in spaceships (go to spac early if planet is close?)
-- --add scaling about mouse position
-- --light feild showing where habitable zone is and how much pull of gravity from each object
-- --gravity -- calculate total movement based on average pull of every nearby object (within light feild)
-- --add home screen -- ALPHA RELEASED
-- --add preveiw (people on the planet doing things ?and info)

-----BUGS / ALTERATIONS(xx.xx.bugs) -- (fixed: 8) -------------------------------------------------------------------
-- add offset on grab so the objects dont teleport to offset (0, 0) of the mouse
-- draw every white circle before the other colors on the stars, for visuals
-- when two objects collide it can delete a totally different object or delete both objects
-- when two objects are the same size they both dissapear
-- craters on planets always spawn in the middle
-- gas giant turns everything blue
-----UPDATES / LARGE BUGS(xx.updates.xx) -- (fixed: 0) --------------------------------------------------------------
-- everything in wip counts as 1
---------------------------------------------------------------------------------------------------------------------
function love.load()
    objects = {}
    mode = 1
    timer = 0
    mouse_x, mouse_y = love.mouse.getPosition()
  end
  
  function getDistance(x1, y1, x2, y2)
    local horizontal_distance = x1 - x2
    local vertical_distance = y1 - y2
  
    local a = horizontal_distance ^2
    local b = vertical_distance ^2
  
    local c = a + b
    local distance = math.sqrt(c)
    return distance
  end
  
  function tryGrabASun(list)
    local mouse_x, mouse_y = love.mouse.getPosition()
    
    for i,sun in ipairs(list) do
      local distance = getDistance(mouse_x, mouse_y, sun.x, sun.y)
      if distance < sun.mass then
        return sun
      end
    end
  end
  
  function changeColor(objects, dt)
    -- for MAIN SEQUENCE STARS only
    -- main sequence stars will vary in color based on their energy, stars could just lose energy as they get larger
  end
  
  function changeGrowthRate(sun, dt)
    -- NEEDS REVAMPING, TERRIBLE FUNCTION
    if sun.mass < 75 then
      sun.rate = 0.1
    else
      sun.rate = sun.mass/50
    end
  end
  
  function didStartGrab()
    return love.mouse.isDown(2) and grabbed_thing == nil
  end
  
  function didStopGrab()
    return not love.mouse.isDown(2) and grabbed_thing ~= nil
  end
  
  function updateObject(object, dt)
    object.x = object.x + object.velX * dt
    object.y = object.y + object.velY * dt
  end
  
  function Scale()
  
  end
  
  -- START OF COLLISION FUNCTIONS
  function calculateVol(r)
    -- convert radius to volume
    local vol = 4/3 * math.pi * r^3
    return vol
  end
  
  function circlify(objOne, objTwo) -- again, one is larger
    local objVolOne = calculateVol(objOne.mass)
    local objVolTwo = calculateVol(objTwo.mass)
    -- give volume of Two to volume of One
    objVolOne = objVolOne + objVolTwo
    objVolTwo = 0
    -- -- convert volumes back into radii
    local rOne = (objVolOne/(4/3*math.pi))^(1/3)
    local rTwo = (objVolTwo/(4/3*math.pi))^(1/3)
  
    return rOne, rTwo
    -- return 1,2
  end
  
  --end
  
  function love.update(dt)
    for i,v in ipairs(objects) do
      v.mass = v.mass + v.rate * dt
    end
    if love.keyboard.isDown("0") then
      error("Player quit game, press ESC")
    elseif love.keyboard.isDown("1") then
      mode = 1
    elseif love.keyboard.isDown("2") then
      mode = 2
    elseif love.keyboard.isDown("3") then
      mode = 3
    end
  
    local objectsTrash = {} -- make trash can for consumed objects
    -- compare two objects in objects list
    for i,One in ipairs(objects) do
      for o,Two in ipairs(objects) do
        -- if they are not the same object
        if One ~= Two then
          local distance = getDistance(One.x, One.y, Two.x, Two.y) -- get distance between objects
          -- if the objects are colliding
          if distance < One.mass + Two.mass then
            -- convert radii to spherical volume
            local volOne, volTwo = calculateVol(One.mass), calculateVol(Two.mass)
            if One.mass > Two.mass then
              One.mass, Two.mass = circlify(One, Two)
              if Two.mass <= 0 then
                table.insert(objectsTrash, o) -- throw away objects at 0 mass
              end
            elseif One.mass == Two.mass then-- if they have the same mass
              One.mass, Two.mass = circlify(One, Two)
              table.insert(objectsTrash, o)
            else-- repeat but if Two is larger
              Two.mass, One.mass = circlify(Two, One)
              if One.mass <= 0 then
                table.insert(objectsTrash, i)
              end
            end 
          end
        end
      end
    end
  
    
    for i = #objectsTrash, 1, -1 do
      table.remove(objects, objectsTrash[i])
    end
    
    local mx, my = love.mouse.getPosition()
  
    if didStartGrab() then
      grabbed_thing = tryGrabASun(objects)
      startX, startY = mx, my
      startT = timer
    elseif didStopGrab() then
      local time = timer - startT
      grabbed_thing.velX, grabbed_thing.velY = (mx - startX)/(time), (my - startY)/(time)
      grabbed_thing = nil
    end
  
    for i, sun in ipairs(objects) do
      updateObject(sun, dt) -- add velocity*dt to position
      if love.mouse.isDown(2) then
        if getDistance(mx, my, sun.x, sun.y) < sun.mass then
          sun.x, sun.y = mx, my
        end
      end
    end   
    for i, sun in ipairs(objects) do
      if sun.typ == "sun" then
        changeGrowthRate(sun, dt)
      end
    end
  
    timer = timer + dt
  end
  
  function love.mousepressed(x, y, button, istouch)
    -- if mouse is clicked, spawn objects
    if button == 1 then
      if mode == 1 then
        table.insert(objects, 
        {
          typ = "sun",
          holeness = love.math.random(1, 3),
          rate = 0.01,
          velX = 0,
          velY = 0,
          x = x,
          y = y,
          mass = 40,
          density = 1
        }) 
      elseif mode == 2 then
        table.insert(objects, {
          typ = "planet",
          holeness = 0,
          rate = 0,
          velX = 0,
          velY = 0,
          x = x,
          y = y,
          mass = 15,
          density = 1
        }) 
      -- elseif mode == 3 then
      --   table.insert(objects, {
      --     typ = "giant",
      --     holeness = 0,
      --     rate = 0,
      --     velX = 0,
      --     velY = 0,
      --     x = x,
      --     y = y,
      --     mass = 20,
      --     density = 1
      --   })
      end
    end  
  end
  
  function love.wheelmoved(x, y)
    --put future scaling in here
  end
  
  function drawObjects(v)
    love.graphics.print("Rate: " .. math.floor(v.rate*10), v.x + v.mass + 10, v.y + v.mass + 10)
    love.graphics.print("☉: " .. math.floor(v.mass), v.x + v.mass + 8, v.y + v.mass - 5)
    for i = 1, 3 do
      if v.typ == "sun" then
        if i == 1 then
          love.graphics.setColor(1, .4, .2)
          love.graphics.circle("fill", v.x, v.y, v.mass + v.mass/3)
        elseif i == 2 then
          love.graphics.setColor(1, .1, .05)
          love.graphics.circle("fill", v.x, v.y, v.mass + v.mass/9)
        elseif i == 3 then
          love.graphics.setColor(1, 1, 1)
          love.graphics.circle("fill", v.x, v.y, v.mass * v.density)
        end
      elseif v.typ == "planet" then
        love.graphics.setColor(.66, .66, .66)
        love.graphics.circle("fill", v.x, v.y, v.mass * v.density)
      end
    love.graphics.setColor(1, 1, 1)
    end
  end
    
  function drawUI()
    love.graphics.print("PRESS 0 to exit", 10, 10)
    love.graphics.print("TYPE - " .. mode, 10, 30)
    love.graphics.polygon("line", 120,0, 160,80, 640,80, 680,0)
  end
  
  function love.draw()
    drawUI()
    for _,v in ipairs(objects) do
      drawObjects(v)
    end
  end