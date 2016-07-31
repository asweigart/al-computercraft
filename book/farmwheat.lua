-- Farm Wheat program
-- By Al Sweigart
-- al@inventwithpython.com
-- Automatically farms wheat.

os.loadAPI('hare')

local cliArgs = {...}
local rowsArg = tonumber(cliArgs[1])
local columnsArg = tonumber(cliArgs[2])

if columnsArg == nil then
  print('Usage: farmwheat rows columns')
  return
end


function checkForChest()
  -- check if next to chest
  local foundChest = false
  local i
  for i=1,4 do
    local result, block = turtle.inspect()
    if block ~= nil and block['name'] == 'minecraft:chest' then
      foundChest = true
      break
    end
    turtle.turnRight()
  end
  if not foundChest then
    print('ERROR: Must start next to a chest!')
  end

  -- turn to face field
  turtle.turnRight()
  turtle.turnRight()
end


function sweepField(rows, columns)
  local turnRight = true
  local columnStep, rowStep
  for columnStep=1,columns do
    checkCrop()

    -- move forward through rows
    for rowStep=1,rows-1 do
      turtle.forward()
      checkCrop()
    end

    if columnStep == columns then
      -- don't turn on the last column
      break
    end

    -- turn to the next column
    if turnRight then
      turtle.turnRight()
      turtle.forward()
      turtle.turnRight()
      turnRight = false
    else
      turtle.turnLeft()
      turtle.forward()
      turtle.turnLeft()
      turnRight = true
    end
  end

  -- move back to the chest
  if columns % 2 == 0 then
    turtle.turnRight()
  else
    for i=1,rows-1 do
      turtle.back()
    end
    turtle.turnLeft()
  end
  for i=1,columns-1 do
    turtle.forward()
  end
  turtle.turnLeft()

  storeWheat()

  -- face field again
  turtle.turnLeft()
  turtle.turnLeft()
end


function checkCrop()
  result, block = turtle.inspectDown()

  if result == false then
    turtle.digDown() -- till the soil
    plantSeed()
  elseif block ~= nil and block['name'] == 'minecraft:wheat' and block['metadata'] == 7 then
    if turtle.digDown() then -- collect wheat
      print('Collected wheat.')
      plantSeed()
    end
  end
end


function plantSeed()
  if hare.selectItem('minecraft:wheat_seeds') == false then
    print('Warning: Low on seeds.')
    return false
  elseif turtle.placeDown() then -- plant a seed
    print('Planted seed.')
    return true
  else
    return false -- couldn't plant
  end
end


function storeWheat()
  -- make sure chest is in front
  local result, block = turtle.inspect()
  if block == nil or block['name'] ~= 'minecraft:chest' then
    print('Warning: Not in front of chest.')
    return false
  end

  while hare.selectItem('minecraft:wheat') do
    print('Dropping off ' .. turtle.getItemCount() .. ' wheat...')
    turtle.drop()
  end
end


print('Hold Ctrl+T to stop.')
checkForChest()
while true do
  print('Sweeping field...')
  sweepField(rowsArg, columnsArg)
end
