-- Farm Potatoes program
-- By Al Sweigart
-- al@inventwithpython.com
-- Automatically farms potatoes.

--[[
IMPORTANT NOTE!!!
Planted potatoes in the game world are
named 'minecraft:potatoes' but potatoes
in your inventory are called
'minecraft:potato'
]]

os.loadAPI('hare')

local cliArgs = {...}
local rowsArg = tonumber(cliArgs[1])
local columnsArg = tonumber(cliArgs[2])

if columnsArg == nil then
  print('Usage: farmpotatoes rows columns')
  return
end


function checkCrop()
  local result, block = turtle.inspectDown()

  if result == false then
    turtle.digDown() -- till the soil
    plantPotato()
  elseif block ~= nil and block['name'] == 'minecraft:potatoes' and block['metadata'] == 7 then
    if turtle.digDown() then -- collect potatoes
      print('Collected potatoes.')
      plantPotato()
    end
  end
end


function plantPotato()
  if hare.selectItem('minecraft:potato') == false then
    print('Warning: Low on potatoes.')
    return false
  elseif turtle.placeDown() then -- plant a potato
    print('Planted potato.')
    return true
  else
    return false -- couldn't plant
  end
end


function storePotatoes()
  if not hare.findBlock('minecraft:chest') then -- face the chest
    print('Warning: Could not find chest.')
    return
  end

  -- drop off potatoes
  local numToSave = rowsArg * columnsArg
  while hare.countItems('minecraft:potato') > numToSave do
    hare.selectItem('minecraft:potato')
    local numToDropOff = math.min((hare.countItems('minecraft:potato') - numToSave), turtle.getItemCount())
    print('Dropping off ' .. numToDropOff .. ' potatoes...')
    turtle.drop(numToDropOff)
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

  -- farm potatoes
  print('Sweeping field...')
  hare.sweepField(rowsArg, columnsArg, checkCrop, storePotatoes)

  print('Sleeping for 10 minutes...')
  os.sleep(600)
end
