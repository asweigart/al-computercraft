-- Dance program
-- By Al Sweigart
-- turtleappstore.com/AlSweigart
-- Make the turtle dance!

print('Hold Ctrl+T to stop dancing.')
while true do
  -- turn based on random number
  if math.random(1, 2) == 1 then
    turtle.turnLeft()
  end
  if math.random(1, 2) == 1 then
    turtle.turnRight()
  end
end

