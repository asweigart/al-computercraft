-- Dance program, version 2
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Make the turtle dance!

local isUp = false
local isBack = false

print('Hold Ctrl+T to stop dancing.')
while true do
  -- turn moves
  if math.random(1, 2) == 1 then
    turtle.turnLeft()
  end
  if math.random(1, 2) == 1 then
    turtle.turnRight()
  end

  -- forward/back moves
  if math.random(1, 2) == 1 then
    if isBack then
      turtle.forward()
      isBack = false
    else
      turtle.back()
      isBack = true
    end
  end

  -- up/down moves
  if math.random(1, 2) == 1 then
    if isUp then
      turtle.down()
      isUp = false
    else
      turtle.up()
      isUp = true
    end
  end

  -- spin around
  if math.random(1, 2) == 1 then
    local i
    for i=1,4 do
      turtle.turnLeft()
    end
    for i=1,4 do
      turtle.turnRight()
    end
  end
end
