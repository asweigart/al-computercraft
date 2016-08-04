-- Wheat Farmer program
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Plants and harvests wheat.
-- Assumes a field is forward and to
-- the right of the turtle, with a
-- chest behind it.

os.loadAPI('hare')

-- handle command line arguments
local cliArgs = {...}
local maxForward = tonumber(cliArgs[1])
local maxRight = tonumber(cliArgs[2])

-- display "usage" info
if maxRight == nil or cliArgs[1] == '?' then
  print('Usage: farmwheat <forward> <right>')
  return
end


-- checkCrop() harvests mature wheat
-- and plants seeds
function checkCrop()
  local result, block = turtle.inspectDown()

  if result == false then
    turtle.digDown()  -- till the soil
    plantSeed()
  elseif block ~= nil and block['name'] == 'minecraft:wheat' and block['metadata'] == 7 then
    if turtle.digDown() then  -- collect wheat
      print('Collected wheat.')
      plantSeed()
    end
  end
end


-- plantSeed() returns true if a seed
-- was planted, otherwise false
function plantSeed()
  if hare.selectItem('minecraft:wheat_seeds') == false then
    print('Warning: Low on seeds.')
    return false 
  elseif turtle.placeDown() then  -- plant a seed
    print('Planted seed.')
    return true
  else
    return false  -- couldn't plant
  end
end


-- storeWheat() puts all wheat into an
-- adjacent chest
function storeWheat()
  -- face the chest
  if not hare.findBlock('minecraft:chest') then 
    error('Could not find chest!')
    return
  end

  -- store wheat in chest
  while hare.selectItem('minecraft:wheat') do
    print('Dropping off ' .. turtle.getItemCount() .. ' wheat...')
    if not turtle.drop() then
      print('Wheat chest is full!')
      print('Waiting for chest to be emptied...')
      while not turtle.drop() do
        os.sleep(10)
      end
    end
  end

  -- face field again
  turtle.turnLeft()
  turtle.turnLeft()
end


-- face and check that chest is there
print('Hold Ctrl+T to stop.')
if not hare.findBlock('minecraft:chest') then
  print('ERROR: Must start next to a chest!')
end

-- face field
turtle.turnLeft()
turtle.turnLeft()

while true do
    -- check fuel
  if turtle.getFuelLevel() < (maxForward * maxRight) + maxForward + maxRight then
    print('ERROR: Not enough fuel.')
    return
  end

  -- farm wheat
  print('Sweeping field...')
  hare.sweepField(maxForward, maxRight, checkCrop)
  storeWheat()

  print('Sleeping for 10 minutes...')
  os.sleep(600)
end
