---------------------------------------------------------------------------------------------------------
-- to do
-- 
-- 1 -- Get planets working the same as suns (21/7/13)
-- 2 -- Get planets to orbit around suns when tab is held ()
-- 3 -- Get planets to change color rigidly based on a feild around each sun ()
-- 5 -- Get planets to change color gradually based on a feild around each sun ()
-- 6 -- Get the feilds of suns to stack up ()
-- 7 -- Get planets to evolve basic life when they are in goldilocks zone ()
-- 8 -- Get basic life to evolve into more complex life ()
-- 9 -- Get complex life to evolve into space age ()
---------------------------------------------------------------------------------------------------------
-- bugg
--
--- removing suns that are too far away makes multiple, unrelated suns vanish
--- can't unpause the pause menu
---------------------------------------------------------------------------------------------------------
sun = require('src/objects/sun')
home = require('src/home')
planet = require('src/objects/planet')

function love.load()
  myShader = love.graphics.newShader[[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );

      if(screen_coords.x > 400){
        return vec4(pixel.r,pixel.g,pixel.b,pixel.a);//red
      }
      else
      {
        return vec4(pixel.g,pixel.b,pixel.r,pixel.a);//blue
      }
    }
  ]]

  sun.load()
  planet.load()
  home.load()
  gamestate = 0 --LEGEND; 0.Home menu, 1.Main game, 2.Pause menu
  typ = 1
  keypressed = false
end

function love.update(dt)
  if gamestate == 0 then
    home.update(dt)
  elseif gamestate == 1 then
    sun.update(dt)
    planet.update(dt)
    if love.keyboard.isDown("escape") and keypressed == false then
      gamestate = 2
      keypressed = true
    end
  elseif gamestate == 2 then
    if love.keyboard.isDown("escape") and keypressed == false then
      gamestate = 1
      keypress = true
    end
    -- sun.update(dt)
    -- planet.update(dt)
  end
end

function love.mousepressed(x, y, button, istouch)
  if gamestate == 0 then
    gamestate = 1
  elseif gamestate == 1 then
    if typ == 1 then
      sun.mousepressed(x, y, button, istouch)
    elseif typ == 2 then
      planet.mousepressed(x, y, button, istouch)
    end
  end
end

function love.keypressed(key)
  if gamestate == 0 then
    gamestate = 1
  elseif gamestate == 1 then
    if key == "1" then
      typ = 1
    elseif key == "2" then
      typ = 2
    end
  end
end

function love.keyreleased(key)
  if key == "escape" then
    keypress = false
  end
end

function love.draw()
  love.graphics.setShader()
  if gamestate == 0 then
    home.draw()
  elseif gamestate == 1 then
    sun.draw()
    planet.draw()
  elseif gamestate == 2 then
    love.graphics.setShader(myShader)
    sun.draw()
    planet.draw()
  end
end