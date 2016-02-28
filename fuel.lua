-- ComputerCraft script to display fuel stats
-- Written by al@inventwithpython.com
-- Find my other scripts at https://github.com/asweigart/al-computercraft
-- or http://turtlescripts.com/profile/AlSweigart

if turtle.getFuelLimit() == 'unlimited' then
  print('Unlimited fuel mode is enabled.')
  return
end

io.write(tostring(turtle.getFuelLevel()))
io.write(' / ')
io.write(tostring(turtle.getFuelLimit()))
io.write('    ')

local amt = 100 * turtle.getFuelLevel() / turtle.getFuelLimit()
print(tostring(amt) .. '%')
if amt < 100 then
  print('Space left: ' .. tostring(turtle.getFuelLimit() - turtle.getFuelLevel()))
end
