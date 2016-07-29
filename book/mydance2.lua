-- Dance program, version 2
-- By Al Sweigart
-- al@inventwithpython.com
-- Make the turtle dance!

local isUp = false
local isBack = false

print('Hold Ctrl+T to stop dancing.')
while true do
  -- turn moves:
  if math.random(1, 2) == 1 then
    turtle.turnLeft()
  end
  if math.random(1, 2) == 1 then
    turtle.turnRight()
  end

  -- move forward/back:
  if math.random(1, 2) == 1 then
    if isBack == true then
      turtle.forward()
      isBack = false
    else
      turtle.back()
      isBack = true
    end
  end

  -- move up/down:
  if math.random(1, 2) == 1 then
    if isUp == true then
      turtle.down()
      isUp = false
    else
      turtle.up()
      isUp = true
    end
  end
end

