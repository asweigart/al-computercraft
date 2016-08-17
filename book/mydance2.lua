-- Dance program, version 2
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Make the turtle dance!

local isUp, isBack, randomNum
isUp = false
isBack = false

print('Hold Ctrl+T to stop dancing.')
while true do
  randomNum = math.random(1, 4)

  if randomNum == 1 then
    -- turn moves
    if math.random(1, 2) == 1 then
      turtle.turnLeft()
    else
      turtle.turnRight()
    end

  elseif randomNum == 2 then
    -- forward/back moves
    if isBack then
      turtle.forward()
      isBack = false
    else
      turtle.back()
      isBack = true
    end

  elseif randomNum == 3 then
    -- up/down moves
    if isUp then
      turtle.down()
      isUp = false
    else
      turtle.up()
      isUp = true
    end

  elseif randomNum == 4 then
    -- spin around
    for i=1,4 do
      turtle.turnLeft()
    end
  end
end
