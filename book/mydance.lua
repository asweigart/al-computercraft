-- Dance program
-- By Al Sweigart
-- al@inventwithpython.com
-- Make the turtle dance!

print('Hold Ctrl+T to stop dancing.')
while true do
  -- pick a random number
  move = math.random(1, 2)

  -- move based on random number
  if move == 1 then
    turtle.turnLeft()
  end
  if move == 2 then
    turtle.turnRight()
  end
end

