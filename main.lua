---------------------------------------------------------------------------------------------------------
-- to do
-- 
-- 1 -- make suns grabbable (jun 26) .
-- 2 -- make suns mergeable (jun 27) 
-- 3 -- make suns throwable (jun 28)
-- 5 -- orbit suns around near objects (jun 29+)
-- 6 -- 
---------------------------------------------------------------------------------------------------------
-- bugg
--
--
--
---------------------------------------------------------------------------------------------------------
require('src/objects/sun')
require('src/home')
require('src/objects/planet')

function love.load()
  darken = love.graphics.newShader[[
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
    {
      vec4 pixel = Texel(texture, texture_coords);
      pixel.rgb -= vec3(0.1);
      return pixel;
    }
  ]]

  sun.load()
  home.load()
  gamestate = 0 --LEGEND; 0.Home menu, 1.Main game, 2.Pause menu
  typ = nil
  keypressed = false
end

function love.update(dt)
  if gamestate == 0 then
    home.update(dt)
  elseif gamestate == 1 then
    sun.update(dt)
    if love.keyboard.isDown("escape") and keypressed == false then
      gamestate = 2
      keypressed = true
    end
  elseif gamestate == 2 then
    if love.keyboard.isDown("escape") and keypressed == false then
      gamestate = 2
      keypress = true
    end
  end
end

function love.mousepressed(x, y, button, istouch)
  if gamestate == 0 then
    gamestate = 1
  elseif gamestate == 1 then
    sun.mousepressed(x, y, button, istouch)
  end
end

function love.keypressed(key)
  if gamestate == 0 then
    gamestate = 1
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
  elseif gamestate == 2 then
    love.graphics.setShader(darken)
    sun.draw()
  end
end