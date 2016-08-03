-- Maze Running program
-- By Al Sweigart
-- turtleappstore.com/AlSweigart
-- Moves through a maze.

print('Starting to run the maze...')

-- this block marks the end goal
GOAL_BLOCK = 'minecraft:gold_block'

steps = 0
while true do
  if turtle.getFuelLevel() == 0 then
    print('I ran out of fuel!')
    return
  end

  while true do
    -- check if at the goal
    result, block = turtle.inspectDown()
    if result ~= nil and block['name'] == GOAL_BLOCK then
      print('Solved the maze in ' .. steps .. ' steps!')
      return
    end

    -- check if left side is open
    turtle.turnLeft()
    if not turtle.detect() then
      print('Moving left.')
      break
    end
    
    -- face forward again
    turtle.turnRight()
    
    -- check if front is open
    if not turtle.detect() then
      print('Moving forward.')
      break
    end

    -- check if right side is open
    turtle.turnRight()
    if not turtle.detect() then
      print('Moving right.')
      break
    end

    -- face back
    turtle.turnRight()
    print('Moving back.')
    break
  end
  
  -- move forward
  turtle.forward()
  steps = steps + 1
end
