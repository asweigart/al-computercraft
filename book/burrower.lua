-- Burrower program
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Mines a tunnel-shaped burrow.

os.loadAPI('hare')

-- handle command line arguments
local cliArgs = {...}
local maxLength = tonumber(cliArgs[1])
local maxHeight = tonumber(cliArgs[2])

-- display "usage" info
if maxLength == nil then
  print('Usage: stairminer <length> [height]')
  return
end

-- set default height of 3
if maxHeight == nil then
  maxHeight = 3
end

-- dig the tunnel
print('Digging burrow...')
local i
local currentLength = 0
while currentLength < maxLength do
  print((maxLength - currentLength) .. ' meters left...')

  -- fuel check
  if turtle.getFuelLevel() < (maxHeight * 2 + 1) then
    print('ERROR: Not enough fuel to continue.')
    return
  end

  turtle.dig()
  turtle.forward()

  -- ascend and dig left side
  turtle.turnLeft()
  for i=1,maxHeight do
    turtle.dig()
    if i ~= maxHeight then
      -- don't dig up at the very top
      turtle.digUp()
      turtle.up()
    end
  end

  turtle.turnRight()
  turtle.turnRight()

  -- descend and dig right side
  for i=1,maxHeight do
    turtle.dig()
    if i ~= maxHeight then
      -- don't dig down at the very bottom
      turtle.digDown()
      turtle.down()
    end
  end

  turtle.turnLeft() -- face forward
  currentLength = currentLength + 1
end

print('Done.')