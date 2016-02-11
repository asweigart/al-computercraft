-- This is a ComputerCraft turtle script that digs stairs down through blocks. It is useful to run along the side of an
-- excavation so that you can walk down.

local tArgs = {...}
if #tArgs < 2 then
  print('Usage: digstairs <length> [<depth>] [left|right]')
  return
end

-- set up commandline arguments
local length = tonumber(tArgs[1])
if #tArgs > 2 then
  local depth = tonumber(tArgs[2])
else
  local depth = length
end

if #tArgs > 3 then
  local turnDirection = tArgs[3]
else
  local turnDirection = 'left'
end

local lengthDug = 0 -- this resets to 0 when the turtle turns around
local depthDug = 0

 -- begin digging stairs
for i = 1,depth do
  if turtle.getFuelLevel() < 6 then
    print('Despite calculations, I ran out of fuel!')
    return
  end
  turtle.digUp()

  -- improve height (comment out if not desired)
  turtle.up()
  turtle.digUp()
  turtle.up()
  turtle.digUp()
  -- TODO: Add torch placement code (needs to check inv, select, place )
  turtle.down()
  turtle.down()

  -- dig stairs
  turtle.digDown()
  turtle.down()
  turtle.dig()
  turtle.forward()

  lengthDug = lengthDug + 1
  depthDug = depthDug + 1

end