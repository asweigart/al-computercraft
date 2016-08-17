-- Dance program, version 2
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Make the turtle dance!

local isUp, isBack, randomNum
isUp = false
isBack = false

print('Hold Ctrl+T to stop dancing.')
while true do
  randomNum = math.random(1, 5)

  if randomNum == 1 then
    -- turn left
    print('Turn to the left!')
    turtle.turnLeft()

  elseif randomNum == 2 then
    -- turn right
    print('Turn to the right!')
    turtle.turnRight()

  elseif randomNum == 3 then
    -- forward/back moves
    if isBack then
      print('Move forward!')
      turtle.forward()
      isBack = false
    else
      print('Move back!')
      turtle.back()
      isBack = true
    end

  elseif randomNum == 4 then
    -- up/down moves
    if isUp then
      print('Get up!')
      turtle.down()
      isUp = false
    else
      print('Get down!')
      turtle.up()
      isUp = true
    end

  elseif randomNum == 5 then
    -- spin around
    print('Spin!')
    for i = 1, 4 do
      turtle.turnLeft()
    end
  end
end
