-- Stair Miner program
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Mines in a stair pattern.

os.loadAPI('hare')
local MINIMUM_FUEL = 500 -- stops refueling after reaching this minimum

local cliArgs = {...}
local maxDepth = tonumber(cliArgs[1])

if maxDepth == nil then
  print('Usage: stairminer <maxDepth>')
  return
end

-- ensure there is at least some fuel at the start
if turtle.getFuelLevel() < 50 then
  print('Load 50 fuel before starting.')
  return
end

local i
local targetDepth = 0
while true do
  -- descent mining
  for i=1,targetDepth do
    -- check for bedrock
    local result, block = turtle.inspectDown()
    if block ~= nil and block['name'] == 'minecraft:bedrock' then
      print('Hit bedrock. Shutting down.')
      return
    end

    turtle.digDown()
    turtle.down()
  end

  -- forward
  turtle.dig()
  turtle.forward()
  turtle.digDown()

  print('Reached depth of ' .. targetDepth)

  -- check that there's enough fuel to go up and then reach the bottom again
  if turtle.getFuelLevel() < (targetDepth * 2) then
    print('Not enough fuel to continue.')
    print('Sleeping until more fuel loaded...')

    -- wait until fuel items are placed in the turtle's inventory
    while turtle.getFuelLevel() < (targetDepth * 2) do
      os.sleep(10)
      local slot
      for slot=1,16 do
        if turtle.getItemCount(slot) and turtle.getFuelLevel() < MINIMUM_FUEL then
          turtle.select()
          turtle.refuel()
        end
      end
    end
  end

  -- check for a full inventory
  if hare.findEmptySlot() == nil then
    print('Inventory full.')
    print('Sleeping until inventory is unloaded...')

    while hare.findEmptySlot() == nil do
      os.sleep(10)
    end
  end

  -- ascent mining
  for i=1,targetDepth do
    turtle.digUp()
    turtle.up()
  end

  -- forward
  turtle.dig()
  turtle.forward()
  
  targetDepth = targetDepth + 2

  if targetDepth >= maxDepth then
    print('Reached maximum depth. Shutting down.')
    return
  end
end  
