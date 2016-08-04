-- Chop Tree program
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Chops down the tree in front of turtle.

if not turtle.detect() then
  print('ERROR: Could not find tree!')
  return  -- no tree there, so exit
end

print('Chopping tree...')

turtle.dig()  -- chop base of tree
turtle.forward()  -- move under tree
while turtle.compareUp() do
  -- keep chopping until no more wood
  turtle.digUp()
  turtle.up()  
end

-- move back down to ground
while not turtle.detectDown() do
  turtle.down()
end

print('Done chopping tree.')