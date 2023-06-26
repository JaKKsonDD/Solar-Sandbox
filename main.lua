---------------------------------------------------------------------------------------------------------
-- to do
-- 
-- 1 -- make suns and planets grabbable
-- 2 -- make suns and planets mergeable
-- 3 -- make suns grow
-- 4 -- orbit planets and suns around near objects
-- 5 -- 
---------------------------------------------------------------------------------------------------------
require('src/objects/sun')

function love.load()
  sun.load()
end

function love.update()
  sun.update()
end

function love.draw()
  sun.draw()
end