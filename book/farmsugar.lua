-- Farm Sugar Cane program
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Automatically farms sugar cane.

-- NOTE: Sugar cane has the name minecraft:reeds

os.loadAPI('hare')

-- handle command line arguments
local cliArgs = {...}
local rowsArg = tonumber(cliArgs[1])
local columnsArg = tonumber(cliArgs[2])

-- display "usage" info
if columnsArg == nil or cliArgs[1] == '?' then
  print('Usage: farmsugar <forward> <right>')
  return
end


function checkCrop()
  local result, block = turtle.inspectDown()

  if block ~= nil and block['name'] == 'minecraft:reeds' then
    if turtle.digDown() then -- collect sugar cane
      print('Collected sugar cane.')
    end
  end
end


function storeSugarCane()
  if not hare.findBlock('minecraft:chest') then -- face the chest
    print('Warning: Could not find chest.')
    return
  end

  -- drop off sugar cane
  while hare.countItems('minecraft:reeds') > 0 do
    hare.selectItem('minecraft:reeds')
    print('Dropping off ' .. turtle.getItemCount() .. ' reeds...')
    if not turtle.drop() then
      print('Sugar cane chest is full!')
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

  -- farm sugar cane
  print('Sweeping field...')
  hare.sweepField(rowsArg, columnsArg, checkCrop)
  storeSugarCane()

  print('Sleeping for 10 minutes...')
  os.sleep(600)
end
