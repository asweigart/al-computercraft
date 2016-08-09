-- Farm Cactus program
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Automatically farms cacti.

os.loadAPI('hare')

-- handle command line arguments
local cliArgs = {...}
local rowsArg = tonumber(cliArgs[1])
local columnsArg = tonumber(cliArgs[2])

-- display "usage" info
if columnsArg == nil or cliArgs[1] == '?' then
  print('Usage: farmcactus <forward> <right>')
  return
end


function checkCrop()
  local result, block = turtle.inspectDown()

  if block ~= nil and block['name'] == 'minecraft:cactus' then
    if turtle.digDown() then -- collect cactus
      print('Collected cactus.')
    end
  end
end


function storeCactus()
  if not hare.findBlock('minecraft:chest') then -- face the chest
    print('Warning: Could not find chest.')
    return
  end

  -- drop off cactus
  while hare.countItems('minecraft:cactus') > 0 do
    hare.selectItem('minecraft:cactus')
    print('Dropping off ' .. turtle.getItemCount() .. ' cacti...')
    if not turtle.drop() then
      print('Cactus chest is full!')
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
  error('Must start next to a chest!')
end

-- face field
turtle.turnLeft()
turtle.turnLeft()

while true do
  -- check fuel
  if turtle.getFuelLevel() < (rowsArg * columnsArg) + rowsArg + columnsArg then
    error('Not enough fuel.')
    return
  end

  -- farm cactus
  print('Sweeping field...')
  hare.sweepField(rowsArg, columnsArg, checkCrop)
  storeCactus()

  print('Sleeping for 10 minutes...')
  os.sleep(600)
end
