-- Fueling program
-- By Al Sweigart
-- al@inventwithpython.com
-- Consumes all fuel smartly.

os.loadAPI('hare')
local consumed, slot
local FUEL_TABLE = {lava_bucket=1000, coal=60, planks=15, log=15}

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

print('Fueling...')

-- search for each type of fuel
for fuelType, fuelAmount in pairs(FUEL_TABLE) do
  while hare.fuelSpace() > fuelAmount and hare.selectItem(fuelType) do
    consumed = turtle.refuel(1) -- consume lava
    if not consumed then
      break -- break if not consumed
    end
  end
end

-- check if fuelgauge program exists
if fs.exists('fuelgauge') then
  -- display fuel info nicely
  os.loadAPI('fuelgauge')
end
