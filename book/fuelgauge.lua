-- Fuel Gauge program
-- By Al Sweigart
-- turtleappstore.com/AlSweigart
-- Displays fuel info nicely.

-- check if server is set to unlimited
if turtle.getFuelLimit() == 'unlimited' then
  print('Unlimited fuel mode is enabled.')
  return
end

-- display fuel amount
io.write(turtle.getFuelLevel())
io.write(' / ')
io.write(turtle.getFuelLimit())
io.write('    ')

-- display fuel percentage
local amt = 100 * turtle.getFuelLevel() / turtle.getFuelLimit()
print(amt .. '%')

-- display space left
local spaceLeft = turtle.getFuelLimit() - turtle.getFuelLevel()
print('Space left: ' .. spaceLeft)
