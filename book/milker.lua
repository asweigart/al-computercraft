--[[ Milker program
By Al Sweigart
https://turtleappstore.com/users/AlSweigart
Milks cows in a field. ]]

os.loadAPI('hare')

-- handle command line arguments
local cliArgs = {...}
local rowsArg = tonumber(cliArgs[1])
local columnsArg = tonumber(cliArgs[2])

-- display "usage" info
if columnsArg == nil or cliArgs[1] == '?' then
  print('Usage: milker <forward> <right>')
  return
end


function milkCow()
  -- keep milking the cow as long as
  -- there are empty buckets and a cow
  while hare.selectItem('minecraft:bucket') and turtle.placeDown() do
    print('Milked the cow.')
  end
end


function storeMilkBuckets()
  -- face the milk bucket chest
  if not hare.findBlock('minecraft:chest') then
    error('ERROR: Cannot find milk bucket chest!')
  end

  -- drop any item that isn't an empty bucket
  print('Dropping off milk buckets...')
  local slot
  for slot=1,16 do
    local item = turtle.getItemDetail(slot)
    if item ~= nil and item['name'] ~= 'minecraft:bucket' then
      turtle.select(slot)
      while not turtle.drop() do
        print('Milk bucket chest is full!')
        print('Waiting for chest to be emptied...')        
        os.sleep(10)
      end
    end
  end
end

print('Hold Ctrl+T to stop.')


-- start by facing the milk bucket chest
if not hare.findBlock('minecraft:chest') then
  print('ERROR: Must start next to a chest!')
end

storeMilkBuckets() -- drop off anything that isn't an empty bucket
while true do
  -- check fuel
  if turtle.getFuelLevel() < (rowsArg * columnsArg) + rowsArg + columnsArg + 2 then
    print('ERROR: Not enough fuel.')
    return
  end

  -- grab up to 16 empty buckets
  turtle.up()
  while hare.countItems('minecraft:bucket') < 16 do
    if not turtle.suck(1) then
      if hare.countItems('minecraft:bucket') == 0 then
        -- More empty buckets are needed in the empty bucket chest
        print('Bucket chest is empty!')
        print('Waiting for chest to be restocked...')
        os.sleep(10)
      else
        break -- we can just use the buckets we have
      end
    end
  end
  turtle.down()

  -- face the field
  turtle.turnLeft()
  turtle.turnLeft()

  -- find and milk cows
  print('Sweeping field...')
  hare.sweepField(rowsArg, columnsArg, milkCow, storeMilkBuckets)
end
