--[[ Stair Miner program
By Al Sweigart
turtleappstore.com/users/AlSweigart
Mines in a stair pattern. ]]

os.loadAPI('hare')

MINIMUM_FUEL = 500 -- stops refueling after reaching this minimum

cliArgs = {...}
maxDepth = tonumber(cliArgs[1])

-- display "usage" info
if maxDepth == nil or cliArgs[1] == '?' then
  print('Usage: stairminer <depth>')
  return
end

-- ensure there is at least some fuel at the start
if turtle.getFuelLevel() < 50 then
  print('Please load 50 fuel before starting.')
  return
end

targetDepth = 0
while true do
  -- mine while descending
  for i = 1, targetDepth do
    -- check for bedrock
    result, block = turtle.inspectDown()
    if block ~= nil and block['name'] == 'minecraft:bedrock' then
      print('Hit bedrock. Done.')
      return
    end

    hare.digDownUntilClear()
    turtle.down()
  end

  -- check if we're done
  print('Reached depth of ' .. targetDepth)
  if targetDepth >= maxDepth then
    print('Done.')
    return
  end

  -- move forward
  hare.digUntilClear()
  turtle.forward()
  hare.digDownUntilClear()

  -- check that there's enough fuel to go up and then reach the bottom again
  if turtle.getFuelLevel() < (targetDepth * 2) then
    print('Not enough fuel to continue.')
    print('Sleeping until more fuel loaded...')

    -- wait until fuel items are placed in the turtle's inventory
    while turtle.getFuelLevel() < (targetDepth * 2) do
      os.sleep(10)
      for slot = 1, 16 do
        if turtle.getItemCount(slot) and turtle.getFuelLevel() < MINIMUM_FUEL then
          turtle.select(slot)
          turtle.refuel()
        end
      end
    end
  end

  -- check for a full inventory
  if hare.findEmptySlot() == nil then
    print('Inventory full.')
    print('Sleeping until inventory is unloaded...')

    repeat
      os.sleep(10)
    until hare.findEmptySlot() ~= nil
  end

  -- mine while ascending
  for i = 1, targetDepth do
    hare.digUpUntilClear()
    turtle.up()
  end

  -- move forward
  hare.digUntilClear()
  turtle.forward()

  targetDepth = targetDepth + 2
end  
