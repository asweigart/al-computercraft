-- A utility module for ComputerCraft's turtles that adds several functions


local direction = 'north'
--local x, y, z = gps.locate()
local x = 0
local y = 0
local z = 0
local positionStack = {}

-- TODO add fuel checks. Also, if not enough fuel for, say, forward(9999), should we stop at first?

function forward(steps)
  local success, i
  if steps == nil then steps = 1 end

  if steps < 0 then
    return back(math.abs(steps)) -- edge case for negative steps
  end

  for i=1,steps do
    success = turtle.forward()
    if not success then return false end

    -- track location
    if direction == 'north' then
      y = y + 1
    elseif direction == 'south' then
      y = y - 1
    elseif direction == 'west' then
      x = x - 1
    elseif direction == 'east' then
      x = x + 1
    end
  end
  return true
end


function back(steps)
  local success, i
  if steps == nil then steps = 1 end

  if steps < 0 then
    return forward(math.abs(steps)) -- edge case for negative steps
  end

  for i=1,steps do
    success = turtle.back()
    if not success then return false end

    -- track location
    if direction == 'north' then
      y = y - 1
    elseif direction == 'south' then
      y = y + 1
    elseif direction == 'west' then
      x = x + 1
    elseif direction == 'east' then
      x = x - 1
    end
  end
  return true
end


function turnLeft(turns)
  if turns == nil then turns = 1 end

  for i=1,turns do
    success = turtle.turnLeft()
    if not success then return false end

    -- track location
    if direction == 'north' then
      direction = 'west'
    elseif direction == 'south' then
      direction = 'east'
    elseif direction == 'west' then
      direction = 'south'
    elseif direction == 'east' then
      direction = 'north'
    end
  end
  return true
end


function turnRight(turns)
  local success, i
  if turns == nil then turns = 1 end

  for i=1,turns do
    success = turtle.turnRight()
    if not success then return false end

    -- track location
    if direction == 'north' then
      direction = 'east'
    elseif direction == 'east' then
      direction = 'south'
    elseif direction == 'south' then
      direction = 'west'
    elseif direction == 'west' then
      direction = 'north'
    end
  end
  return true
end


function up(steps)
  local success, i
  if steps == nil then steps = 1 end

  for i=1,steps do
    success = turtle.up()
    if not success then return false end
    z = z + 1 -- track position
  end
  return true
end


function down(steps)
  local success, i
  if steps == nil then steps = 1 end

  for i=1,steps do
    success = turtle.down()
    if not success then return false end
    z = z - 1 -- track position
  end
  return true
end


function face(d)
  if d == 'north' or d == 'n' then
    return faceNorth()
  elseif d == 'south' or d == 's' then
    return faceSouth()
  elseif d == 'west' or d == 'w' then
    return faceWest()
  elseif d == 'east' or d == 'e' then
    return faceEast()
  end

  return false, '"' .. d .. '" is not a valid direction'
end


function faceNorth()
  local success
  if direction == 'south' then
    success = turnRight(2)
    if not success then return false end
  elseif direction == 'east' then
    success = turnLeft()
    if not success then return false end
  elseif direction == 'west' then
    success = turnRight()
    if not success then return false end
  end
  return true
end


function faceSouth()
  local success
  if direction == 'north' then
    success = turnRight(2)
    if not success then return false end
  elseif direction == 'west' then
    success = turnLeft()
    if not success then return false end
  elseif direction == 'east' then
    success = turnRight()
    if not success then return false end
  end
  return true
end


function faceEast()
  local success
  if direction == 'west' then
    success = turnRight(2)
    if not success then return false end
  elseif direction == 'south' then
    success = turnLeft()
    if not success then return false end
  elseif direction == 'north' then
    success = turnRight()
    if not success then return false end
  end
  return true
end


function faceWest()
  local success
  if direction == 'east' then
    success = turnRight(2)
    if not success then return false end
  elseif direction == 'north' then
    success = turnLeft()
    if not success then return false end
  elseif direction == 'south' then
    success = turnRight()
    if not success then return false end
  end
  return true
end


function north(steps)
  if not faceNorth() then return false end
  return forward(steps)
end


function south(steps)
  if not faceSouth() then return false end
  return forward(steps)
end


function west(steps)
  if not faceWest() then return false end
  return forward(steps)
end


function east(steps)
  if not faceEast() then return false end
  return forward(steps)
end


function pushPosition()
  table.insert(positionStack, {x=x, y=y, z=z}) -- TODO test this
end


function popPosition()
  -- TODO
  local pos = table.remove(positionStack)
  if pos == nil then return nil end
  x = pos['x']
  y = pos['y']
  z = pos['z']
  return pos
end


function line(x0, y0, z0, x1, y1, z1)
  -- returns an array of tables with x & y coordinates of the line between the two given points
  local points = {}
  local dx, dy, dz, xptr, yptr, zptr, sx, sy, sz, errx, erry, errz

  dx = math.abs(x1 - x0)
  dy = math.abs(y1 - y0)
  dz = math.abs(z1 - z0)

  xptr, yptr, zptr = x0, y0, z0

  if x0 > x1 then
    sx = -1
  else
    sx = 1
  end

  if y0 > y1 then
    sy = -1
  else
    sy = 1
  end

  if z0 > z1 then
    sz = -1
  else
    sz = 1
  end

  if dx > dy and dx > dz then
    erry = dx / 2
    errz = dx / 2
    while xptr ~= x1 do
      table.insert(points, {x=xptr, y=yptr, z=zptr})
      erry = erry - dy
      if erry < 0 then
        yptr = yptr + sy
        erry = erry + dx
      end
      errz = errz - dz
      if errz < 0 then
        zptr = zptr + sz
        errz = errz + dx
      end
      xptr = xptr + sx
    end
  elseif dy > dx and dy > dz then
    errx = dy / 2
    errz = dy / 2
    while yptr ~= y1 do
      table.insert(points, {x=xptr, y=yptr, z=zptr})
      errx = errx - dx
      if errx < 0 then
        xptr = xptr + sx
        errx = errx + dy
      end
      errz = errz - dz
      if errz < 0 then
        zptr = zptr + sz
        errz = errz + dy
      end
      yptr = yptr + sy
    end
  else
    errx = dz / 2
    erry = dz / 2
    while zptr ~= z1 do
      table.insert(points, {x=xptr, y=yptr, z=zptr})
      errx = errx - dx
      if errx < 0 then
        xptr = xptr + sx
        errx = errx + dz
      end
      erry = erry - dy
      if erry < 0 then
        yptr = yptr + sy
        erry = erry + dz
      end
      zptr = zptr + sz
    end
  end

  table.insert(points, {x=xptr, y=yptr, z=zptr})
  return points
end


function goto(destx, desty, destz)
  -- TODO (will require bresenhem line alg)
  local startx, starty, startz = x, y, z
  local originalDirection = direction

  if startx == destx and starty == desty and startz == destz then
    return true -- edge case; we are already at the destination
  end

  linePoints = line(startx, starty, startz, destx, desty, destz)

  -- go through all the points and make them relative to the one before it
  for i=#linePoints,2,-1 do
    linePoints[i]['x'] = linePoints[i]['x'] - linePoints[i-1]['x']
    linePoints[i]['y'] = linePoints[i]['y'] - linePoints[i-1]['y']
    linePoints[i]['z'] = linePoints[i]['z'] - linePoints[i-1]['z']
  end
  table.remove(linePoints, 1) -- get rid of the first point; we won't need it

  for i=1,#linePoints do
    --hare.print(linePoints[i]['x'], ' ', linePoints[i]['y'], ' ', linePoints[i]['z'])
    if linePoints[i]['x'] == 1 then
      faceEast()
      forward()
    elseif linePoints[i]['x'] == -1 then
      faceWest()
      forward()
    end

    if linePoints[i]['y'] == 1 then
      faceNorth()
      forward()
    elseif linePoints[i]['y'] == -1 then
      faceSouth()
      forward()
    end

    if linePoints[i]['z'] == 1 then
      up()
    elseif linePoints[i]['z'] == -1 then
      down()
    end
  end

  face(originalDirection)
end


function doActions(actions, safeMode)
  if safeMode == nil then safeMode = false end
  local i, j, k, v

  -- TODO need to replace tArgs
  for i = 1,#tArgs do
    cmd = tArgs[i] -- get the command
    if #tArgs < i + 1 then
      reps = 1 -- end of cmdline args, so set this to 1
    else
      if tonumber(tArgs[i+1]) ~= nil then -- check if next arg is numeric
        reps = tonumber(tArgs[i+1]) -- set
      else
        -- "reps" is actually the next command, so set it to 1
        reps = 1
      end
    end
    if tArgs[i] == 'f' then
      for j = 1,reps do
        success, errMsg = turtle.forward()
        --print('forward: ' .. tostring(success) .. ' ' .. errMsg)
        if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'b' then
      for j = 1,reps do
        success, errMsg = turtle.back()
        --print('back: ' .. tostring(success) .. ' ' .. errMsg)
        if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'l' then
      for j = 1,reps do
          --print('left: ' .. tostring(turtle.turnLeft()))
      end
    elseif tArgs[i] == 'r' then
      for j = 1,reps do
          --print('right: ' .. tostring(turtle.turnRight()))
      end
    elseif tArgs[i] == 'up' then
      for j = 1,reps do
        success, errMsg = turtle.up()
        --print('up: ' .. tostring(success) .. ' ' .. errMsg)
        if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'dn' then
      for j = 1,reps do
        success, errMsg = turtle.down()
        --print('down: ' .. tostring(success) .. ' ' .. errMsg)
        if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'd' then
      for j = 1,reps do
        success, errMsg = turtle.dig()
        --print('dig: ' .. tostring(success) .. ' ' .. errMsg)
        if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'du' then
      for j = 1,reps do
        success, errMsg = turtle.digUp()
        --print('digUp: ' .. tostring(success) .. ' ' .. errMsg)
        if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'dd' then
      for j = 1,reps do
        success, errMsg = turtle.digDown()
        --print('digDown: ' .. tostring(success) .. ' ' .. errMsg)
        if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'i' then
      for j = 1,reps do
        success, inspectResults = turtle.inspect()
        if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'iu' then
      for j = 1,reps do
          success, inspectResults = turtle.inspectUp()
          if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'id' then
      for j = 1,reps do
        success, inspectResults = turtle.inspectDown()
        if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'sel' then
      -- in this case, reps is the inventory number
      success, errMsg = turtle.select(reps)
      if safeMode and not success then return success, errMsg end
    elseif tArgs[i] == 's' then
      for j = 1,reps do
          success, errMsg = turtle.suck()
          if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'su' then
      for j = 1,reps do
          success, errMsg = turtle.suckUp()
          if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'sd' then
      for j = 1,reps do
          success, errMsg = turtle.suckDown()
          if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'p' then
      for j = 1,reps do
          success, errMsg = turtle.place()
          if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'pu' then
      for j = 1,reps do
          success, errMsg = turtle.placeUp()
          if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'pd' then
      for j = 1,reps do
          success, errMsg = turtle.placeDown()
          if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'dr' then
      for j = 1,reps do
          success, errMsg = turtle.drop()
          if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'dru' then
      for j = 1,reps do
          success, errMsg = turtle.dropUp()
          if safeMode and not success then return success, errMsg end
      end
    elseif tArgs[i] == 'drd' then
      for j = 1,reps do
          success, errMsg = turtle.dropDown()
          if safeMode and not success then return success, errMsg end
      end
    end
  end
end


function canDo(actions)
  -- TODO returns true if it can do all these steps with the fuel it has
end


function doActionsSafely(actions)
  -- TODO (essentially the do program but in a function)
  -- will immediately stop the first time a call fails or if there is not
  -- enough fuel to do all the steps.
  return doActions(actions, true)
end


function arrange(itemPattern, dropDir)
  -- TODO (arranges the turtle's inventory, mostly for making. Can split/combine stacks if needed)
  -- will try to get it as close as possible. '' for blank, nil for "don't care"
  -- turtle will drop unwanted items in direction of dropDir if it is not nil. dirs are '', 'down', 'up'
end


function craft(itemName)
  -- TODO arranges and then crafts item
  -- need to figure out how to handle getting stuff from chests
end


function dropItem(itemName, amount, _direction)
  if not selectItem(itemName) then return false end

  if _direction == nil then
    success = turtle.drop(amount)
  elseif _direction == 'down' then
    success = turtle.dropDown(amount)
  elseif _direction == 'up' then
    success = turtle.dropUp(amount)
  end

  return success
end


function dropItemDown(itemName)
end


function dropItemUp(itemName)
end



function getFuelPercent()
  return 100 * turtle.getFuelLevel() / turtle.getFuelLimit()
end


function getFuelSpace()
  -- returns amount of fuel free space there is
  return turtle.getFuelLimit() - turtle.getFuelLevel()
end


function selectItem(itemName)
  -- selects an item exactly, or the closest match
  local i, itemData

  -- try to find an exact match:
  for i=1,16 do
    itemData = turtle.getItemDetail(i)
    if itemData ~= nil and itemData['name'] == itemName then
      return turtle.select(i)
    end
  end

  -- try to find an exact match after the : part of the name:
  for i=1,16 do
    itemData = turtle.getItemDetail(i)
    if itemData ~= nil then
      local colonPos = string.find(itemData['name'], ':')
      if colonPos ~= nil then
        if itemData ~= nil and string.sub(itemData['name'], colonPos + 1, -1) == itemName then
          return turtle.select(i)
        end
      end
    end
  end

  -- try to find a "like" match:
  for i=1,16 do
    itemData = turtle.getItemDetail(i)
    if itemData ~= nil and string.find(itemData['name'], itemName) then
      return turtle.select(i)
    end
  end

  return false -- could not find item
end





function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end


function setDirection(d)
  local ALL_DIRS = {'north', 'n', 'south', 's', 'east', 'e', 'west', 'w'}
  if not table.contains(ALL_DIRS, d) then
    return false, '"' .. d .. '" is not a valid direction'
  end
  direction = d
  return true
end

function getDirection()
  return direction
end

function setPos(xpos, ypos, zpos)
  if tonumber(xpos) == nil or tonumber(ypos) == nil or tonumber(zpos) == nil then
    return false, 'Non-numbers passed to setPos()'
  end
  return true
end

function getPos()
  return {x=x, y=y, z=z}
end


function getx()
  return x
end


function setx(xpos)
  if tonumber(xpos) == nil then
    return false, 'Non-number passed to setx()'
  end
  return x
end


function gety()
  return y
end


function sety(ypos)
  if tonumber(ypos) == nil then
    return false, 'Non-number passed to sety()'
  end
  return y
end


function getz()
  return z
end


function setz(zpos)
  if tonumber(zpos) == nil then
    return false, 'Non-number passed to setz()'
  end
  return z
end


function useGPS()
  local gpsx, gpsy, gpsz = gps.locate()
  if x == nil then
    return false, 'GPS not available'
  else
    x, y, z = gpsx, gpsy, gpsz
    return true, x, y, z
  end
end