-- Dance program
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Make the turtle dance!

print('Hold Ctrl+T to stop dancing.')
while true do
  -- turn based on random number
  if math.random(1, 2) == 1 then
  	print('Turn to the left!')
    turtle.turnLeft()
  else
  	print('Turn to the right!')
    turtle.turnRight()
  end
end
