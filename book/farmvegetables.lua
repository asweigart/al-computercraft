-- Farm Vegtables program
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Automatically farms carrots or potatoes.

--[[
IMPORTANT NOTE!!!
Planted potatoes in the game world are
named 'minecraft:potatoes' but potatoes
in your inventory are called
'minecraft:potato'
]]

os.loadAPI('hare')

-- handle command line arguments
local cliArgs = {...}
local rowsArg = tonumber(cliArgs[1])
local columnsArg = tonumber(cliArgs[2])

-- display "usage" info
if columnsArg == nil or cliArgs[1] == '?' then
  print('Usage: farmvegetables <forward> <right>')
  return
end


function checkCrop()
  local result, block = turtle.inspectDown()

  if not result then
    turtle.digDown() -- till the soil
    plantVegetable()
  elseif block ~= nil and (block['name'] == 'minecraft:potatoes' or block['name'] == 'minecraft:carrots') and block['metadata'] == 7 then
    if turtle.digDown() then -- collect vegetable
      print('Collected vegetable.')
      plantVegetable()
    end
  end
end


function plantVegetable()
  -- TODO: This code means we'll have to explain short-circuiting. Do we want this?
  local haveVegetable = false
  if math.random(1, 2) == 1 then
    haveVegetable = hare.selectItem('minecraft:potato')
    haveVegetable = hare.selectItem('minecraft:carrot')
  else
    haveVegetable = hare.selectItem('minecraft:carrot')
    haveVegetable = hare.selectItem('minecraft:potato')
  end
  if not haveVegetable then
    print('Warning: Low on vegetables.')
    return false
  end

  if turtle.placeDown() then -- plant vegetable
    print('Planted vegetable.')
    return true
  else
    return false -- couldn't plant
  end

end


function storeVegetables()
  if not hare.findBlock('minecraft:chest') then -- face the chest
    print('Warning: Could not find chest.')
    return
  end

  -- drop vegetables in chest
  local numToSave = math.ceil((rowsArg * columnsArg) / 2)
  local key, vegName
  for key, vegName in pairs({'potato', 'carrot'}) do
    while hare.countItems('minecraft:' .. vegName) > numToSave do
      hare.selectItem('minecraft:' .. vegName)
      local numToDropOff = math.min((hare.countItems('minecraft:' .. vegName) - numToSave), turtle.getItemCount())
      print('Dropping off ' .. numToDropOff .. ' ' .. vegName .. '...')
      if not turtle.drop(numToDropOff) then
        print('Vegetable chest is full!')
        print('Waiting for chest to be emptied...')
        while not turtle.drop(numToDropOff) do
          os.sleep(10)
        end
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
  end

  -- farm vegetables
  print('Sweeping field...')
  hare.sweepField(rowsArg, columnsArg, checkCrop)
  storeVegetables()

  print('Sleeping for 10 minutes...')
  os.sleep(600)
end
