-- Fueling program
-- By Al Sweigart
-- al@inventwithpython.com
-- Consumes all fuel smartly.

-- check if server is set to unlimited
if turtle.getFuelLimit() == 'unlimited' then
  print('Unlimited fuel mode is enabled.')
  return
end

-- check that the turtle has a label
if os.getComputerLabel() == nil then
  print('WARNING: Set a label or else fuel will')
  print('be lost when turtle is picked up!')
end

-- search for lava in inventory first
local slot
for slot=1,16 do
  -- check if we need 1000 fuel first
  if turtle.getFuelLimit() - turtle.getFuelLevel() < 1000 then
    break -- not enough empty space is fuel tank for lava
  end

  local item = turtle.getItemDetail(slot)
  if item ~= nil and item['name'] == 'minecraft:lava_bucket' then
    turtle.select(slot)
    turtle.refuel(1) -- consume lava
  end
end

-- next search for other fuels
for slot=1,16 do
  -- check if there is fuel in slot
  -- or that we aren't full yet
  local item = turtle.getItemDetail(slot)
  if item ~= nil and
     (item['name'] == 'minecraft:coal' or
     item['name'] == 'minecraft:log' or
     string.find(item['name'], 'sapling') ~= nil or
     string.find(item['name'], 'planks') ~= nil) then
    turtle.select(slot)
    while turtle.getItemCount(slot) > 0 and turtle.getFuelLevel() < turtle.getFuelLimit() do
      turtle.refuel(1) -- consume fuel
    end
  end
end

-- check if fuelgauge program exists
if fs.exists('fuelgauge') then
  -- display fuel info nicely
  os.loadAPI('fuelgauge')
end
