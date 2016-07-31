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


function findChest()
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
    return false
  end

  return true
end


function sweepField(rows, columns, sweepFunc, endSweepFunc)
  local turnRight = true
  local columnStep, rowStep
  for columnStep=1,columns do
    if sweepFunc ~= nil then
      sweepFunc()
    end

    -- move forward through rows
    for rowStep=1,rows-1 do
      turtle.forward()
      if sweepFunc ~= nil then
        sweepFunc()
      end
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

  -- move back to the start
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
  turtle.turnRight()

  if endSweepFunc ~= nil then
    endSweepFunc()
  end
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
  if not findChest() then -- face the chest
    print('Warning: Could not find chest.')
    return
  end

  -- drop off wheat
  while hare.selectItem('minecraft:wheat') do
    print('Dropping off ' .. turtle.getItemCount() .. ' wheat...')
    turtle.drop()
  end

  -- face field again
  turtle.turnLeft()
  turtle.turnLeft()
end


print('Hold Ctrl+T to stop.')
if not findChest() then
  print('ERROR: Must start next to a chest!')
end
while true do
  -- check fuel
  if turtle.getFuelLevel() < (rowsArg * columnsArg) + rowsArg + columnsArg then
    print('ERROR: Not enough fuel.')
    return
  end

  -- farm wheat
  print('Sweeping field...')
  sweepField(rowsArg, columnsArg, checkCrop, storeWheat)

  print('Sleeping for 10 minutes...')
  os.sleep(600)
end
