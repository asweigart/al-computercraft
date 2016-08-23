--[[ Sheep Shearer program
By Al Sweigart
turtleappstore.com/users/AlSweigart
Shears sheep in a field. ]]


os.loadAPI('hare')

-- handle command line arguments
local cliArgs = {...}
local rowsArg = tonumber(cliArgs[1])
local columnsArg = tonumber(cliArgs[2])

-- display "usage" info
if columnsArg == nil or cliArgs[1] == '?' then
  print('Usage: shearer <forward> <right>')
  return
end


function shearSheep()
  -- keep shearing sheep as long as
  -- there are empty buckets and sheep
  local preShearAmount = hare.countItems('minecraft:wool')
  while turtle.placeDown() do
    if hare.countItems('minecraft:wool') == preShearAmount then
      break -- "sheared" an already sheared sheep, so break
    end
    print('Sheared a sheep.')
    preShearAmount = hare.countItems('minecraft:wool')
  end
end


function storeWool()
  -- face the chest
  if not hare.findBlock('minecraft:chest') then
    error('Cannot find the wool chest!')
  end

  -- drop any item that isn't an empty bucket
  print('Dropping off wool...')
  local slot
  for slot=1,16 do
    local item = turtle.getItemDetail(slot)
    if item ~= nil and item['name'] ~= 'minecraft:shears' then
      turtle.select(slot)
      turtle.drop()
    end
  end

  -- face the field again
  turtle.turnLeft()
  turtle.turnLeft()
end


print('Hold Ctrl+T to stop.')

-- start by facing the chest
if not hare.findBlock('minecraft:chest') then
  error('Must start next to a chest!')
end

-- face the field
turtle.turnLeft()
turtle.turnLeft()

while true do
  -- check fuel
  if turtle.getFuelLevel() < (rowsArg * columnsArg) + rowsArg + columnsArg then
    error('Not enough fuel.')
  end

  -- select the shears
  if not hare.selectItem('minecraft:shears') then
    error('Need shears in inventory.')
  end

  -- find and shear sheep
  print('Sweeping field...')
  hare.sweepField(rowsArg, columnsArg, shearSheep, storeWool)

  print('Sleeping for 4 minutes...')
  os.sleep(240)
end
