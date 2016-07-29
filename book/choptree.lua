-- Chop Tree program
-- By Al Sweigart
-- al@inventwithpython.com
-- Run with tree in front of turtle
-- to chop it down.

if not turtle.detect() then
  return -- nothing there, so exit
end

print('Chopping tree...')

turtle.dig() -- chop base
turtle.forward() -- move under tree
while turtle.compareUp() do
  -- keep chopping until no more wood
  turtle.digUp()
  turtle.up()  
end

-- move back to ground
while not turtle.detectDown() do
  turtle.down()
end

print('Done chopping tree.')