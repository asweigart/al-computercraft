print('Hold Ctrl+T to stop dancing.')
while true do
  move = math.random(1, 4)
  if move == 1 then
    turtle.turnLeft()
  end
  if move == 2 then
    turtle.turnRight()
  end
end

