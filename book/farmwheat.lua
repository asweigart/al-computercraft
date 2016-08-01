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


function checkCrop()
  local result, block = turtle.inspectDown()

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
  if not hare.findBlock('minecraft:chest') then -- face the chest
    print('Warning: Could not find chest.')
    return
  end

  -- drop off wheat
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


print('Hold Ctrl+T to stop.')
if not hare.findBlock('minecraft:chest') then
  print('ERROR: Must start next to a chest!')
end

-- face field
turtle.turnLeft()
turtle.turnLeft()

while true do
    -- check fuel
  if turtle.getFuelLevel() < (rowsArg * columnsArg) + rowsArg + columnsArg then
    print('ERROR: Not enough fuel.')
    return
  end

  -- farm wheat
  print('Sweeping field...')
  hare.sweepField(rowsArg, columnsArg, checkCrop, storeWheat)

  print('Sleeping for 10 minutes...')
  os.sleep(600)
end
