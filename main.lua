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
--- fix grabbing system so the sun doesn't fall off the mouse
--- fix throwing system so the suns velocity resets when it doesn't move
---------------------------------------------------------------------------------------------------------
require('src/objects/sun')

function love.load()
  sun.load()
  gamestate = 0 --LEGEND; 0.Home menu, 1.Main game, 2.Pause menu
  typ = nil
end

function love.update(dt)
  if gamestate == 0 then
    
  elseif gamestate == 1 then
    sun.update(dt)
  elseif gamestate == 2 then

  end
end

function love.mousepressed(x, y, button, istouch)
  if gamestate == 1 then
    sun.mousepressed(x, y, button, istouch)
  end
end

function love.draw()
  sun.draw()
end