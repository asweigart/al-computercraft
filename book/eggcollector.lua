-- Egg Collector program
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Collects eggs in a field.
-- Assumes a field is forward and to
-- the right of the turtle, with a
-- chest behind it.

os.loadAPI('hare')

local cliArgs = {...}
local rowsArg = tonumber(cliArgs[1])
local columnsArg = tonumber(cliArgs[2])

if columnsArg == nil then
  print('Usage: eggcollect rows columns')
  return
end


function storeItems()
  -- face the chest
  if not hare.findBlock('minecraft:chest') then 
    print('Warning: Could not find chest.')
    return
  end

  -- drop off items
  local slot
  for slot=1,16 do
    if turtle.getItemCount(slot) > 0 then
      turtle.drop()
    end
  end

  -- face field
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

  -- collect eggs
  print('Sweeping field...')
  hare.sweepField(rowsArg, columnsArg, turtle.suckDown, storeItems)

  print('Sleeping for 5 minutes...')
  os.sleep(300)
end
