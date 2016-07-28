-- Dance program, version 2
-- By Al Sweigart
-- al@inventwithpython.com
-- Make the turtle dance!

isUp = false
isBack = false

print('Hold Ctrl+T to stop dancing.')
while true do
  -- pick random number
  move = math.random(1, 4)

  -- turn moves:
  if move == 1 then
    turtle.turnLeft()
  end
  if move == 2 then
    turtle.turnRight()
  end

  -- move forward/back:
  if move == 3 then
    if isBack == true then
      turtle.forward()
      isBack = false
    else
      turtle.back()
      isBack = true
    end
  end

  -- move up/down:
  if move == 4 and isUp == true then
    turtle.down()
    isUp = false
  elseif move == 4 and isUp == false then
    turtle.up()
    isUp = true
  end
end

