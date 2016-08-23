--[[ Dance program
By Al Sweigart
turtleappstore.com/users/AlSweigart
Make the turtle dance! ]]

print('Hello world!')
for i = 1, 8 do
  -- turn based on random number
  if math.random(1, 2) == 1 then
  	print('Turn to the left!')
    turtle.turnLeft()
  else
  	print('Turn to the right!')
    turtle.turnRight()
  end
end
print('Done.')