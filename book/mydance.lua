--[[ Dance program By Al Sweigart
Make the turtle dance! ]]

print('Hello world!')

-- Turtle starts dancing
turtle.forward()
turtle.back()
turtle.turnRight()
turtle.forward()
turtle.back()
turtle.back()
turtle.turnLeft()
turtle.turnLeft()
turtle.back()

-- Turtle spins around
local i
for i = 1, 5 do
  turtle.turnRight()
end
turtle.up()
turtle.down()
print('Done.')