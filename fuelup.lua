-- This is a ComputerCraft script that makes a turtle consume *all* of its fuel (if needed), instead of just one block like the 'refuel' program.
-- Written by al@inventwithpython.com

-- constants for energy amounts of each fuel type
-- (these must change if ComputerCraft changes it, which is unlikely)
LAVA_ENERGY = 1000
COAL_ENERGY = 80
COAL_COKE_ENERGY = 160
WOOD_ENERGY = 15
SAPLING_ENERGY = 5

-- check if "unlimited fuel" is set on this server
if turtle.getFuelLimit() == 'unlimited' then
  print('Turtles are set to "unlimited" fuel already!')
  return
end

-- check for valid command line arguments
local tArgs = {...}
if #tArgs > 0 and (tonumber(tArgs[1]) == nil) then
    print('Usage: refuelall [min percent]')
    print('  Refuels using all inventory up to')
    print('  the minimum percent level, which is')
    print('  100% by default. Smart enough to')
    print('  not waste fuel. Uses lava first.')
    return
end

-- get minimum fuel level from command line argument
local minLevel -- the minimum fuel level, not percentage
if #tArgs > 0 then
  minLevel = ((tonumber(tArgs[1])) / 100) * turtle.getFuelLimit()
  if turtle.getFuelLevel() >= minLevel then
    print('Minimum already reached!')
    return
  end
else
  minLevel = turtle.getFuelLimit()
end

print('DEBUG: minLevel=',minLevel)


-- remember which slot was selected so we can set it back to that at the end
local originalSelectedSlot = turtle.getSelectedSlot()

-- function to get amount of fuel needed to reach minimum level
local function fuelNeeded()
  return minLevel - turtle.getFuelLevel()
end


-- main program
local startingLevel = turtle.getFuelLevel()
local totalConsumed = 0

-- find out if there's lava, and use it first
local lavaAt = nil
for slot=1,16 do
  if fuelNeeded() > LAVA_ENERGY then
    turtle.select(slot)
    itemData = turtle.getItemDetail()
    if itemData ~= nil and itemData['name'] == 'minecraft:lava_bucket' then
      print('DEBUG found lava at ', slot)
      turtle.refuel(1) -- consume the lava
    end
  end
  -- really wish Lua had a continue statement that I could put here, no big deal though
end


-- go through inventory and keep fueling until minimum level is met
for slot=1,16 do
  turtle.select(slot)
  itemData = turtle.getItemDetail()
  if itemData ~= nil then
    print('DEBUG item at ', slot)
    local energyGain
    if itemData['name'] == 'ImmersiveEngineering:material' then
      energyGain = COAL_COKE_ENERGY
    elseif itemData['name'] == 'minecraft:coal' then
      energyGain = COAL_ENERGY
    elseif string.find(itemData['name'], 'sapling') ~= nil then
      energyGain = SAPLING_ENERGY
    elseif string.find(itemData['name'], 'planks') ~= nil or itemData['name'] == 'minecraft:log' then
      energyGain = WOOD_ENERGY
    else
      energyGain = 15 -- default guess
    end

    -- if it turns out this item isn't burnable, it won't affect our calculations

    if fuelNeeded() > energyGain then
      local numConsumed = math.floor(fuelNeeded() / energyGain)
      numConsumed = math.min(turtle.getItemCount(), numConsumed)
      local refuelStatus = turtle.refuel(numConsumed)
      if refuelStatus ~= 0 then
        totalConsumed = totalConsumed + numConsumed
      end
      print('DEBUG refueld slot #', slot)
    end
  end
end


-- copied this from my fuel.lua script:
io.write(tostring(turtle.getFuelLevel()))
io.write(' / ')
io.write(tostring(turtle.getFuelLimit()))
io.write('    ')
local amt = 100 * turtle.getFuelLevel() / turtle.getFuelLimit()
print(tostring(amt) .. '%')

-- display usage stats
local totalRefueled = turtle.getFuelLevel() - startingLevel
print('Used ' .. tostring(totalConsumed) .. ' items for ' .. tostring(totalRefueled) .. ' fuel.')

-- reset back to original selected slot
turtle.select(originalSelectedSlot)