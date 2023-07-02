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
end

function love.update(dt)
  sun.update(dt)
end

function love.mousepressed(x, y, button, istouch)
  
  sun.mousepressed(x, y, button, istouch)
  
end

function love.draw()
  sun.draw()
end