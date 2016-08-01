-- Farm Wheat program
-- By Al Sweigart
-- al@inventwithpython.com
-- Automatically farms wheat.

os.loadAPI('hare')

local COAL_ENERGY = 80 -- amount of fuel a piece of coal has
local MINIMUM_FUEL = 1000 -- minimum amount of fuel the turtle should maintain
local START_FUEL = 100 -- amount of fuel needed before turtle should even start

local cliArgs = {...}
local maxDepth = tonumber(cliArgs[1])

if maxDepth == nil then
  print('Usage: stairminer maxDepth')
  return
end

if turtle.getFuelLevel() < START_FUEL then
  print('Need at least ' .. START_FUEL .. ' fuel to start!')
  return
end


function returnHome(fromDepth, fromLength)
  local i
  for i=1,fromDepth do
    turtle.up()
  end
  for i=1,fromLength do
    turtle.back()
  end
end

function unloadIntoChest(fromDepth, fromLength)
  -- return to chest
  print('Returning to chest to unload...')
  returnHome(fromDepth, fromLength)

  -- face where chest should be
  turtle.turnLeft()
  turtle.turnLeft()

  -- drop to where chest should be
  print('Unloading into chest...')
  local slot
  for slot=1,16 do
    if turtle.getItemcount(slot) > 0 then
      turtle.select(slot)
      turtle.drop() -- possible for chest to overflow
    end
  end

  -- turn back around
  turtle.turnLeft()
  turtle.turnLeft()

  -- return to mining
  print('Returning to mining...')
  local i
  for i=1,toLength do
    turtle.forward()
  end
  for i=1,toDepth do
    turtle.down()
  end

  print('Continuing to mine...')  
end


function refuelIfNeeded()
  local slot,item
  if turtle.getFuelLevel() >= MINIMUM_FUEL then
    return
  end

  local fuelNeeded = MINIMUM_FUEL - turtle.getFuelLevel()
  for slot=1,16 do
    item = turtle.getItemDetail(slot)
    if item ~= nil and item['name'] == 'minecraft:coal' and item['count'] > 0 then
      turtle.select(slot)
      turtle.refuel(math.floor(fuelNeeded / COAL_ENERGY))
      fuelNeeded = MINIMUM_FUEL - turtle.getFuelLevel()
    end
  end

  if turtle.getFuelLevel() < START_FUEL then
    print('Not enough fuel to continue.')
    return false
  end
  return true
end

local i, j
local currentDepth = 0
local currentLength = 0
local targetDepth = 0
local restartMining = false
while true do
  -- descent mining
  for i=1,targetDepth do
    print('debug: going down, curDep=' .. currentDepth)
    if refuelIfNeeded() then return end
    if hare.findEmptySlot() == nil then
      unloadIntoChest(currentDepth, currentLength)
    end

    -- check for bedrock
    result, block = turtle.inspectDown()
    if block ~= nil and block['name'] == 'minecraft:bedrock' then
      print('Hit bedrock. Returning home...')
      returnHome(currentDepth, currentLength)
      print('Done.')
      return
    end

    turtle.digDown()
    turtle.down()
    currentDepth = currentDepth + 1
  end

  -- forward
  turtle.dig()
  turtle.forward()
  currentLength = currentLength + 1
  turtle.digDown()

  -- ascent mining
  for i=1,targetDepth do
    print('debug: going up, curDep=' .. currentDepth)
    if refuelIfNeeded() then return end
    if hare.findEmptySlot() == nil then
      turtle.back()
      unloadIntoChest(currentDepth, currentLength - 1)
      turtle.forward()
    end

    turtle.digUp()
    currentDepth = currentDepth - 1
    turtle.up()
  end

  -- forward
  turtle.dig()
  turtle.forward()
  currentLength = currentLength + 1
  
  targetDepth = targetDepth + 2
  print('debug: new targetDepth=' .. targetDepth)

  if targetDepth >= maxDepth then
    print('Reached maximum depth. Returning home...')
    returnHome(currentDepth, currentLength)
    print('')
    return
  end
end  
