-- Fuel Gauge program
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Displays fuel info nicely.

local amt, spaceLeft

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
amt = 100 * turtle.getFuelLevel() / turtle.getFuelLimit()
print(amt .. '%')

-- display space left
spaceLeft = turtle.getFuelLimit() - turtle.getFuelLevel()
print('Space left: ' .. spaceLeft)
