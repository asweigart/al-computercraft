isUp = false
isBack = false

print('Hold Ctrl+T to stop dancing.')
while true do
  move = math.random(1, 4)
  if move == 1 then
    turtle.turnLeft()
  end
  if move == 2 then
    turtle.turnRight()
  end
  if move == 3 then
    if isBack == true then
      turtle.forward()
      isBack = false
    else
      turtle.back()
      isBack = true
    end
  end
  if move == 4 and isUp == true then
    turtle.down()
    isUp = false
  elseif move == 4 and isUp == false then
    turtle.up()
    isUp = true
  end
end

