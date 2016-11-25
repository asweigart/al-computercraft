--[[ Fuel Gauge program
By Al Sweigart
https://turtleappstore.com/users/AlSweigart
Displays fuel info nicely. ]]

-- check that the turtle has a label
if os.getComputerLabel() == nil then
  print('WARNING: Set a label or else fuel will')
  print('be lost when turtle is picked up!')
end

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
