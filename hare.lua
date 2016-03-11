-- A utility module for ComputerCraft's turtles that adds several functions

-- TODO switch from return values to exceptions for errors
-- TODO call hasFuelFor for various events

local DEBUG = true


function split(str)
  -- splits a string up into an array of strings
  str = string.lower(str)
  local actions = {}
  local word
  for word in str:gmatch("%w+") do table.insert(actions, word) end
  return actions
end

local VALID_ACTIONS = split('f forward b back l left r right up dn down fn fs fe fw facenorth facesouth faceeast facewest no north so south ea east we west d dig du digup dd digdown i inspect iu inspectup id inspectdown sel select s suck su suckup sd suckdown p place pu placeup pd placedown dr drop dru dropup drd dropdown')

local direction = 'north'
--local x, y, z = gps.locate()
local x = 0
local y = 0
local z = 0
local positionStack = {}

local recordingNow = false
local recordedMoves = {}

local recipes = {}

local MAX_STACK_SIZE = 64

-- TODO add fuel checks!!!! Also, if not enough fuel for, say, forward(9999), should we stop at first?


function forward(steps)
  -- TODO record new position to a file for reloading
  local success, errMsg, i
  if steps == nil then steps = 1 end

  if steps < 0 then
    return back(math.abs(steps)) -- edge case for negative steps
  end

  for i=1,steps do
    success, errMsg = turtle.forward()
    if not success then return false, errMsg end

    if recordingNow then recordMove('f') end
    -- track location
    if direction == 'north' then
      z = z - 1
    elseif direction == 'south' then
      z = z + 1
    elseif direction == 'west' then
      x = x - 1
    elseif direction == 'east' then
      x = x + 1
    end
  end
  if DEBUG then print('Moved forward ' .. steps .. ' steps') end
  return true
end


function back(steps)
  -- TODO record new position to a file for reloading
  local success, errMsg, i
  if steps == nil then steps = 1 end

  if steps < 0 then
    return forward(math.abs(steps)) -- edge case for negative steps
  end

  for i=1,steps do
    success, errMsg = turtle.back()
    if not success then return false, errMsg end

    if recordingNow then recordMove('b') end

    -- track location
    if direction == 'north' then
      z = z + 1
    elseif direction == 'south' then
      z = z - 1
    elseif direction == 'west' then
      x = x + 1
    elseif direction == 'east' then
      x = x - 1
    end
  end
  if DEBUG then print('Moved back ' .. steps .. ' steps') end
  return true
end


function turnLeft(turns)
  if turns == nil then turns = 1 end

  for i=1,turns do
    success = turtle.turnLeft()
    if not success then return false end

    if recordingNow then recordMove('l') end

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
  if DEBUG then print('Turned left ' .. turns .. ' turns') end
  return true
end


function turnRight(turns)
  local success, i
  if turns == nil then turns = 1 end

  for i=1,turns do
    success = turtle.turnRight()
    if not success then return false end

    if recordingNow then recordMove('r') end

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
  if DEBUG then print('Turned right ' .. turns .. ' turns') end
  return true
end


function up(steps)
  local success, i
  if steps == nil then steps = 1 end

  for i=1,steps do
    success = turtle.up()
    if not success then return false end
    if recordingNow then recordMove('up') end
    y = y + 1 -- track position
  end
  if DEBUG then print('Moved up ' .. steps .. ' steps') end
  return true
end


function down(steps)
  local success, i
  if steps == nil then steps = 1 end

  for i=1,steps do
    success = turtle.down()
    if not success then return false end
    if recordingNow then recordMove('dn') end
    y = y - 1 -- track position
  end
  if DEBUG then print('Moved down ' .. steps .. ' steps') end
  return true
end


function face(d)
  d = string.lower(d)
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
  if steps > 0 then
    return forward(steps)
  else
    return back(-steps)
  end
end


function south(steps)
  if not faceSouth() then return false end
    if steps > 0 then
    return forward(steps)
  else
    return back(-steps)
  end
end


function west(steps)
  if not faceWest() then return false end
    if steps > 0 then
    return forward(steps)
  else
    return back(-steps)
  end
end


function east(steps)
  if not faceEast() then return false end
    if steps > 0 then
    return forward(steps)
  else
    return back(-steps)
  end
end


function pushPositionSetting()
  table.insert(positionStack, {x=x, y=y, z=z}) -- TODO test
end


function popPositionSetting()
  -- TODO test
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


function goto(destx, desty, destz, faceOriginalDirection)
  -- returns false if at some point the turtle can't move along the path
  local startx, starty, startz = getx(), gety(), getz()
  local originalDirection = direction

  if faceOriginalDirection == nil then faceOriginalDirection = true end

  if destx == nil then destx = getx() end
  if desty == nil then desty = gety() end
  if destz == nil then destz = getz() end

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
      if DEBUG then print('goto: moving east') end
      success, errMsg = forward()
    elseif linePoints[i]['x'] == -1 then
      faceWest()
      if DEBUG then print('goto: moving west') end
      success, errMsg = forward()
    end

    if linePoints[i]['y'] == 1 then
      if DEBUG then print('goto: moving up') end
      success, errMsg = up()
    elseif linePoints[i]['y'] == -1 then
      if DEBUG then print('goto: moving down') end
      success, errMsg = down()
    end

    if linePoints[i]['z'] == 1 then
      faceSouth()
      if DEBUG then print('goto: moving south') end
      success, errMsg = forward()
    elseif linePoints[i]['z'] == -1 then
      faceNorth()
      if DEBUG then print('goto: moving north') end
      success, errMsg = forward()
    end

    if not success then return false, errMsg end
  end

  if faceOriginalDirection then face(originalDirection) end
end



function doActions(actionsStr, safeMode)
  --[[
  Complete list of commands:
  f - move forward
  b - move backward

  ]]
  actionsStr = string.lower(actionsStr)
  local actions = split(actionsStr)

  if safeMode == nil then safeMode = false end

  local i, j, k, v, success, errMsg

  if safeMode then -- check that there are no invalid commands
    success, errMsg = isValidActionString(actionsStr)
    if not success then return false, errMsg end
  end

  for i = 1,#actions do
    cmd = actions[i] -- get the command
    if #actions < i + 1 then
      reps = 1 -- end of actions, so set this to 1
    else
      if tonumber(actions[i+1]) ~= nil then -- check if next arg is numeric
        reps = tonumber(actions[i+1]) -- set
      else
        -- "reps" is actually the next command, so set it to 1
        reps = 1
      end
    end
    if actions[i] == 'f' or actions[i] == 'forward' then
      success, errMsg = forward(reps)
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 'b' or actions[i] == 'back' then
      success, errMsg = back(reps)
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 'l' or actions[i] == 'left' then
      turnLeft(reps)
    elseif actions[i] == 'r' or actions[i] == 'right' then
      turnRight(reps)
    elseif actions[i] == 'up' then
      success, errMsg = up(reps)
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 'dn' or actions[i] == 'down' then
      success, errMsg = down(reps)
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 'fn' or actions[i] == 'facenorth' then
      success = faceNorth()
      if safeMode and not success then return success end -- TODO figure out if there are error messages for turning, I'm assuming there are not.
    elseif actions[i] == 'fs' or actions[i] == 'facesouth' then
      success = faceSouth()
      if safeMode and not success then return success end -- TODO figure out if there are error messages for turning
    elseif actions[i] == 'fe' or actions[i] == 'faceeast' then
      success = faceEast()
      if safeMode and not success then return success end -- TODO figure out if there are error messages for turning
    elseif actions[i] == 'fw' or actions[i] == 'facewest' then
      success = faceWest()
      if safeMode and not success then return success end -- TODO figure out if there are error messages for turning
    elseif actions[i] == 'no' or actions[i] == 'north' then
      success = faceNorth()
      if safeMode and not success then return success end
      success, errMsg = forward()
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 'so' or actions[i] == 'south' then
      success = faceSouth()
      if safeMode and not success then return success end
      success, errMsg = forward()
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 'we' or actions[i] == 'west' then
      success = faceWest()
      if safeMode and not success then return success end
      success, errMsg = forward()
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 'ea' or actions[i] == 'east' then
      success = faceEast()
      if safeMode and not success then return success end
      success, errMsg = forward()
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 'd' or actions[i] == 'dig' then
      for j = 1,reps do
        success, errMsg = turtle.dig()
        --print('dig: ' .. tostring(success) .. ' ' .. errMsg)
        if safeMode and not success then return success, errMsg end
      end
    elseif actions[i] == 'du' or actions[i] == 'digup' then
      for j = 1,reps do
        success, errMsg = turtle.digUp()
        --print('digUp: ' .. tostring(success) .. ' ' .. errMsg)
        if safeMode and not success then return success, errMsg end
      end
    elseif actions[i] == 'dd' or actions[i] == 'digdown' then
      for j = 1,reps do
        success, errMsg = turtle.digDown()
        --print('digDown: ' .. tostring(success) .. ' ' .. errMsg)
        if safeMode and not success then return success, errMsg end
      end
    elseif actions[i] == 'i' or actions[i] == 'inspect' then
      for j = 1,reps do
        success, inspectResults = turtle.inspect()
        if safeMode and not success then return success, errMsg end
      end
    elseif actions[i] == 'iu' or actions[i] == 'inspectup' then
      for j = 1,reps do
          success, inspectResults = turtle.inspectUp()
          if safeMode and not success then return success, errMsg end
      end
    elseif actions[i] == 'id' or actions[i] == 'inspectdown' then
      for j = 1,reps do
        success, inspectResults = turtle.inspectDown()
        if safeMode and not success then return success, errMsg end
      end
    elseif actions[i] == 'sel' or actions[i] == 'select' then
      -- in this case, reps is the inventory number
      success, errMsg = turtle.select(reps)
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 's' or actions[i] == 'suck' then
      success, errMsg = turtle.suck(reps)
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 'su' or actions[i] == 'suckup' then
      success, errMsg = turtle.suckUp(reps)
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 'sd' or actions[i] == 'suckdown' then
      success, errMsg = turtle.suckDown(reps)
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 'p' or actions[i] == 'place' then
      for j = 1,reps do
        success, errMsg = turtle.place()
        if safeMode and not success then return success, errMsg end
      end
    elseif actions[i] == 'pu' or actions[i] == 'placeup' then
      for j = 1,reps do
        success, errMsg = turtle.placeUp()
        if safeMode and not success then return success, errMsg end
      end
    elseif actions[i] == 'pd' or actions[i] == 'placedown' then
      for j = 1,reps do
        success, errMsg = turtle.placeDown()
        if safeMode and not success then return success, errMsg end
      end
    elseif actions[i] == 'dr' or actions[i] == 'drop' then
      success, errMsg = turtle.drop(reps)
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 'dru' or actions[i] == 'dropup' then
      success, errMsg = turtle.dropUp(reps)
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 'drd' or actions[i] == 'dropdown' then
      success, errMsg = turtle.dropDown(reps)
      if safeMode and not success then return success, errMsg end
    end
  end
end


function doReverseMovement(actionsStr, safeMode)
  -- TODO check for fn and other commands that can't be reversed
  actionsStr = string.lower(actionsStr)
  if string.find(actionsStr, 'fn') or string.find(actionsStr, 'fs') or string.find(actionsStr, 'fw') or string.find(actionsStr, 'fe') or
    string.find(actionsStr, 'north') or string.find(actionsStr, 'south') or string.find(actionsStr, 'west') or string.find(actionsStr, 'east') then
    return false, 'Cannot reverse actions that include facing compass directions.'
  end

  local actions = split(actionsStr)

  if safeMode == nil then safeMode = false end
  local i, j, k, v

  for i = 1,#actions do
    cmd = actions[i] -- get the command
    if #actions < i + 1 then
      reps = 1 -- end of actions, so set this to 1
    else
      if tonumber(actions[i+1]) ~= nil then -- check if next arg is numeric
        reps = tonumber(actions[i+1]) -- set
      else
        -- "reps" is actually the next command, so set it to 1
        reps = 1
      end
    end
    if actions[i] == 'f' or actions[i] == 'forward' then
      success, errMsg = back(reps)
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 'b' or actions[i] == 'back' then
      success, errMsg = forward(reps)
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 'l' or actions[i] == 'left' then
      turnRight(reps)
    elseif actions[i] == 'r' or actions[i] == 'right' then
      turnLeft(reps)
    elseif actions[i] == 'up' then
      success, errMsg = turtle.down(reps)
      if safeMode and not success then return success, errMsg end
    elseif actions[i] == 'dn' or actions[i] == 'down' then
      success, errMsg = turtle.up(reps)
      if safeMode and not success then return success, errMsg end
    end
  end
end


function doOneAction(actionsStr)
  -- TODO figure this out, does this return (success, errMsg) or (actionsStr)? Should we be using return values for errors?
  local action, reps
  local actions = split(actionsStr)

  -- retrieve the first action and its reps (if given)
  action = actions[1]
  reps = tonumber(actions[2]) -- if not a number then this will be nil
  if reps == nil then
    reps = 1
  else
    table.remove(actions, 2)
  end
  table.remove(actions, 1)

  if DEBUG then print('doing one action: ' .. action .. ' ' .. tostring(reps)) end
  success, errMsg = doActions(action .. ' ' .. tostring(reps)) -- do the first action
  if success == false then return success, errMsg end

  if DEBUG then print('doOneAction returns: ' .. table.concat(actions, ' ')) end
  return table.concat(actions, ' ')
end


function hasFuelFor(actionsStr)
  -- TODO returns true if it can do all these steps with the fuel it has
  local actions = split(actionsStr)
  local totalFuelConsumption = 0

  for i = 1,#actions do
    if actions[i] == 'f' or actions[i] == 'forward' or actions[i] == 'b' or actions[i] == 'back' or actions[i] == 'up' or actions[i] == 'dn' or actions[i] == 'down' or
      actions[i] == 'no' or actions[i] == 'north' or actions[i] == 'so' or actions[i] == 'south' or actions[i] == 'we' or actions[i] == 'west' or actions[i] == 'ea' or actions[i] == 'east' then
      reps = tonumber(actions[i+1])
      if reps == nil then reps = 1 end
      totalFuelConsumption = totalFuelConsumption + reps
    end
  end

  return totalFuelConsumption <= turtle.getFuelLevel()
end


function doActionsSafely(actions)
  -- TODO (essentially the do program but in a function)
  -- will immediately stop the first time a call fails or if there is not
  -- enough fuel to do all the steps.
  return doActions(actions, true)
end


function getAreaCoverActions(forward, right, goHome)
  -- returns a string that can be passed to doActions() and doOneAction()
  -- these actions are for moving the turtle to cover an area
  local r, actions, r_str, l_str
  if forward <= 0 or right == 0 then return '' end -- edge case: no movement

  if goHome == nil then goHome = false end

  -- if 'right' was negative, then flip the r_str and l_str actions
  if right < 0 then
    right = math.abs(right)
    r_str = 'l '
    l_str = 'r '
  else
    r_str = 'r '
    l_str = 'l '
  end

  actions = ''
  turnRight = true
  for r=1,(right-1) do
    actions = actions .. string.rep('f ', forward-1) -- go to end of column
    if turnRight then
      actions = actions .. r_str .. 'f ' .. r_str
    else
      actions = actions .. l_str .. 'f ' .. l_str
    end
    turnRight = not turnRight
  end

  -- last column movements
  actions = actions .. string.rep('f ', forward-1)

  -- add "go home" actions if asked for
  if goHome then
    if right % 2 == 1 then
      -- turtle ends up in the far right corner
      actions = actions .. r_str .. r_str .. string.rep('f ', forward-1) .. l_str .. string.rep('f ', right-1) .. r_str
    else
      -- turtle ends up in the near right corner
      actions = actions .. r_str .. string.rep('f ', right-1) .. r_str
    end
  end
  return actions
end


function inventoryMatches(recipe)
  -- special case: check if everything is already in the correct spot
  local matches = true
  for i=1,16 do
    itemData = turtle.getItemDetail(i)
    if (itemData == nil and not (recipe[i] == nil or recipe[i] == '')) or (itemData ~= nil and string.find(string.lower(itemData['name']), recipe[i])) then
      matches = false
      break
    end
  end
  return matches
end


function arrange(recipe, discardDirection)
  -- TODO (arranges the turtle's inventory, mostly for making. Can split/combine stacks if needed)
  -- will try to get it as close as possible. '' for blank, nil for "don't care"
  -- turtle will drop unwanted items in direction of dropDir

  -- NOTE: Due to the nature of having to swap, we can't arrange items in the case where all the recipe's items have filled all 16 spaces of the inventory but are in the wrong order.

  local origx = getx() -- save original position and direction so it can be reset to this at the end
  local origy = gety()
  local origz = getz()
  local origFace = getDirection()

  -- set item names to lowercase for easier matching
  for i=1,16 do
    recipe[i] = string.lower(recipe[i])
  end

  -- special case: check if everything is already in the correct spot
  if inventoryMatches(recipe) then return true end

  -- there must be at least one empty slot (after getting rid of all non-recipe items)
  emptySlot = selectEmptySlot()
  if emptySlot == false then return false, 'No empty slots' end

  -- loop through inventory and determine if there are items that need to be dropped because they aren't a part of the recipe
  local discardItemsInSlots = {}
  for i=1,16 do
    -- loop through all the inventory slots, note any slots with non-recipe items
    local notInRecipe = true
    for j=1,#recipe do
      itemData = turtle.getItemDetail(j)
      if string.find(string.lower(itemData['name']), recipe[i]) then
        notInRecipe = false
        break
      end
    end
    if notInRecipe then table.insert(discardItemsInSlots, i) end
  end

  if #discardItemsInSlots > 0 then
    -- travel to discard area and drop off the to-be-discard items, then return
    dropAt(discardDirection, discardItemsInSlots)
  end

  -- TODO any remaining items that are in the inventory should be swapped to their proper place
  for i=1,15 do
    itemData = turtle.getItemDetail(i)
    if recipe[i] ~= nil and recipe[i] ~= '' and itemData ~= nil and not string.find(string.lower(itemData['name']), recipe[i])  then
      -- the item in slot i is not the item the recipe dictates. Figure out if the recipe's item is in another slot
      for j=i,16 do
        itemData2 = turtle.getItemDetail(j)
        if string.find(string.lower(itemData2['name'], recipe[i])) then
          -- we've found the item for slot i; it is in slot j. We should move it to slot i
          turtle.select(i) -- move items in slot i to a free spot
          if DEBUG then
            print('Moving ' .. turtle.getItemDetail(i)['name'] .. ' from slot ' .. tostring(i) .. ' to empty slot ')
          end
          turtle.transferTo(selectEmptySlot(), MAX_STACK_SIZE)
          turtle.select(j) -- move items in slot i to slot j where they belong
          if DEBUG then
            print('Moving ' .. turtle.getItemDetail(j)['name'] .. ' from slot ' .. tostring(j) .. ' to slot ' .. tostring(i))
          end
          turtle.transferTo(i, MAX_STACK_SIZE)
          break
        end
      end
    end
  end

  -- special case: check if everything is already in the correct spot
  if inventoryMatches(recipe) then
    goto(origx, origy, origz)
    face(origFace)
    return true
  else
    return false, 'Not all recipe items in inventory'
  end
end


function isReversibleActionString(actionsStr)
  -- the movements in a string of commands is not reversible if it contains compass direction commands
  local actions = split(actionsStr)
  for i=1,#actions do
    if actions[i] == 'fn' or actions[i] == 'fs' or actions[i] == 'fe' or actions[i] == 'fw' or
      actions[i] == 'facenorth' or actions[i] == 'facesouth' or actions[i] == 'faceeast' or actions[i] == 'facewest' or
      actions[i] == 'no' or actions[i] == 'so' or actions[i] == 'ea' or actions[i] == 'we' or
      actions[i] == 'north' or actions[i] == 'south' or actions[i] == 'east' or actions[i] == 'west' then
        return false, 'Action "' .. actions[i] .. '" is not a reversible movement'
    end
  end
  return true
end


function isValidActionString(actionStr)
  local actions = split(actionStr)
  local expectCmd = true -- commands are expected after other commands or rep numbers or at the start
  for i=1,#actions do
    if expectCmd and not table.contains(VALID_ACTIONS, actions[i]) then
      return false, 'Expected a command but found "' .. tostring(actions[i]) .. '"'
    end

    if not expectCmd and (not table.contains(VALID_ACTIONS, actions[i]) and tonumber(actions[i]) == nil) then
      return false, 'Expected a command or reps number but found "' .. tostring(actions[i]) .. '"'
    end

    if expectCmd then
      expectCmd = false -- next action can be a command OR reps number, it doesn't HAVE to be a command
    end

    if tonumber(actions[i]) == nil then
      -- the command was a reps number, so the next action MUST be a command
      expectCmd = true
    end
  end
  return true
end

--[[
function suckFrom(suckDirection, amount, faceOriginalDirection) -- TODO add amount param?
  local success, errMsg
  local preSuckDirection = getDirection()

  if faceOriginalDirection == nil then faceOriginalDirection = true end

  if amount == nil then amount = MAX_STACK_SIZE end

  -- move and point turtle to the item source
  if type(suckDirection) == 'string' then
    success, errMsg = doActionsSafely(suckDirection)
    if success == false then return false, errMsg end
  elseif type(suckDirection) == 'table' then
    if goto(suckDirection[1], suckDirection[2], suckDirection[3], faceOriginalDirection) == false then return false, 'Movement obstructed' end
    face(suckDirection[4])
  end

  -- suck items from the item source
  if suckDirection[4] == 'up' then
    success, errMsg = turtle.suckUp()
  elseif suckDirection[4] == 'down' or suckDirection[4] == 'dn' then
    success, errMsg = turtle.suckDown()
  else
    success, errMsg = turtle.suck()
  end
  if DEBUG then print('sucked item') end
  face(preSuckDirection)
  return success, errMsg
end
]]

function isValidDirectionValue(direction, requiredCmdType)
  -- a valid "direction value" is either a {x, y, z, compass direction} table or a reversible action string
  -- requiredCmdType can be either 'suck' or 'drop', and checks the action string for this type of command


  if type(direction) == 'string' then
    success, errMsg = isReversibleActionString(direction)
    if not success then return false, errMsg end

    -- check for required command type
    dirAsTable = split(direction)
    if (requiredCmdType == 'suck') and (not (table.contains(dirAsTable, 's') or table.contains(dirAsTable, 'sd') or table.contains(dirAsTable, 'su') or
      table.contains(dirAsTable, 'suck') or table.contains(dirAsTable, 'suckdown') or table.contains(dirAsTable, 'suckup'))) then
      return false, 'No suck command in action string'
    elseif (requiredCmdType == 'drop') and (not (table.contains(dirAsTable, 'dr') or table.contains(dirAsTable, 'drd') or table.contains(dirAsTable, 'dru') or
      table.contains(dirAsTable, 'drop') or table.contains(dirAsTable, 'dropdown') or table.contains(dirAsTable, 'dropup'))) then
      return false, 'No drop command in action string'
    end

  elseif type(direction) == 'table' then
    if type(direction[1]) ~= 'number' or type(direction[2]) ~= 'number' or type(direction[3]) ~= 'number' then
      return false, 'Only numbers can be passed for XYZ coordinates'
    end

    if direction[4] ~= 'no' and direction[4] ~= 'north' and direction[4] ~= 'so' and direction[4] ~= 'south' and
      direction[4] ~= 'ea' and direction[4] ~= 'east' and direction[4] ~= 'we' and direction[4] ~= 'west' then
      return false, '"' .. direction[4] .. '" is not a valid N-S-E-W compass direction'
    end
  else
    return false, '"' .. type(direction) .. '" is an invalid type for the `direction` parameter'
  end

  return true
end


function suckAt(direction, slots, amount)
  if DEBUG then print('Call: suckAt(' .. direction .. ', ' .. table.tostring(slots) .. ', ' .. amount .. ')') end
  local success, errMsg
  local origDirection = getDirection()

  if type(slots) == 'number' then slots = {slots} end

  if amount == nil then amount = MAX_STACK_SIZE end

  success, errMsg = isValidDirectionValue(direction, 'suck')
  if success == false then return false, errMsg end

  if type(direction) == 'string' then
    originalDirection = direction
    while direction ~= '' do
      -- check if this is a suck command
      firstAction = split(direction)[1]
      local isSuckCmd = firstAction == 's' or firstAction == 'suck' or firstAction == 'sd' or firstAction == 'suckdown' or firstAction == 'suckup' or firstAction == 'su'

      if isSuckCmd then
        -- run the suck command for every slot in slots
        for i=1,#slots do
          if DEBUG then print('Sucking to slot #' .. tostring(slots[i])) end
          turtle.select(slots[i])
          success, errMsg = doOneAction(firstAction .. ' ' .. amount)
          if success == false then return false, errMsg end
          direction = success -- assign the remainder of the action string to direction
        end
      else
        -- this is not a suck command, so just do it
        success, errMsg = doOneAction(direction)
        if success == false then return false, errMsg end
        direction = success -- assign the remainder of the action string to direction
      end
    end

    -- return to original place
    doReverseMovement(originalDirection)

  elseif type(direction) == 'table' then
    local origx = getx()
    local origy = gety()
    local origz = getz()

    -- direction is an xyz coordinate with direction
    if goto(direction[1], direction[2], direction[3], false) == false then return false, 'Movement obstructed' end
    face(direction[4])

    -- suck items at the suck destination
    for i=1,#slots do
      if DEBUG then print('Suckping slot #' .. tostring(slots[i])) end
      turtle.select(slots[i])
      if direction[4] == 'up' then
        success, errMsg = turtle.suckUp(amount)
      elseif direction[4] == 'down' or direction[4] == 'dn' then
        success, errMsg = turtle.suckDown(amount)
      else
        success, errMsg = turtle.suck(amount)
      end
    end

    if goto(origx, origy, origz) == false then return false, 'Movement obstructed' end
  end

  if DEBUG then print('sucked items at suck site') end

  if faceOriginalDirection then
    face(origDirection)
  end
end


function dropAt(direction, slots, amount)
  if DEBUG then print('Call: dropAt(' .. direction .. ', ' .. table.tostring(slots) .. ', ' .. amount .. ')') end
  local success, errMsg
  local origDirection = getDirection()

  if type(slots) == 'number' then slots = {slots} end

  if amount == nil then amount = MAX_STACK_SIZE end

  success, errMsg = isValidDirectionValue(direction, 'drop')
  if success == false then return false, errMsg end

  if type(direction) == 'string' then
    originalDirection = direction
    while direction ~= '' do
      -- check if this is a drop command
      firstAction = split(direction)[1]
      local isDropCmd = firstAction == 'dr' or firstAction == 'drop' or firstAction == 'drd' or firstAction == 'dropdown' or firstAction == 'dropup' or firstAction == 'dru'

      if isDropCmd then
        -- run the drop command for every slot in slots
        for i=1,#slots do
          if DEBUG then print('Dropping slot #' .. tostring(slots[i])) end
          turtle.select(slots[i])
          success, errMsg = doOneAction(firstAction .. ' ' .. amount)
          if success == false then return false, errMsg end
          direction = success -- assign the remainder of the action string to direction
        end
      else
        -- this is not a drop command, so just do it
        success, errMsg = doOneAction(direction)
        if success == false then return false, errMsg end
        direction = success -- assign the remainder of the action string to direction
      end
    end

    -- return to original place
    doReverseMovement(originalDirection)

  elseif type(direction) == 'table' then
    local origx = getx()
    local origy = gety()
    local origz = getz()

    -- direction is an xyz coordinate with direction
    if goto(direction[1], direction[2], direction[3], false) == false then return false, 'Movement obstructed' end
    face(direction[4])

    -- drop items at the drop destination
    for i=1,#slots do
      if DEBUG then print('Dropping slot #' .. tostring(slots[i])) end
      turtle.select(slots[i])
      if direction[4] == 'up' then
        success, errMsg = turtle.dropUp(amount)
      elseif direction[4] == 'down' or direction[4] == 'dn' then
        success, errMsg = turtle.dropDown(amount)
      else
        success, errMsg = turtle.drop(amount)
      end
    end

    if goto(origx, origy, origz) == false then return false, 'Movement obstructed' end
  end

  if DEBUG then print('dropped items at direction') end

  if faceOriginalDirection then
    face(origDirection)
  end
end


function pickOut(itemName, amount, suckDirection, dropDirection, slot, timeout)
  -- suck/drop directions can be: {x,y,z,nsew} or an action string with suck/drop commands
  -- TODO implement timeout
  while true do
    if selectEmptySlot() == false then return false, 'No empty slots' end
    if DEBUG then print('selected slot #' .. tostring(turtle.getSelectedSlot())) end

    success, errMsg = suckAt(suckDirection, MAX_STACK_SIZE, false)

    if success == false then return false, errMsg end -- nothing left to get

    -- figure out what item it is
    itemData = turtle.getItemDetail()
    if itemData ~= nil and string.find(string.lower(itemData['name']), string.lower(itemName)) then
      if DEBUG then print('sucked ' .. tostring(itemData['count']) .. ' ' .. itemData['name']) end
      -- put back excess amount of items
      if itemData['count'] > amount then
        if suckDirection[4] == 'up' or suckDirection[4] == 'u' then
          success, errMsg = turtle.dropUp(amount - itemData['count'])
        elseif suckDirection[4] == 'down' or suckDirection[4] == 'd' then
          success, errMsg = turtle.dropDown(amount - itemData['count'])
        else
          success, errMsg = turtle.drop(amount - itemData['count'])
        end
      end

      return true -- NOTE: like the turtle API's suck functions, this might not have collected the full amount requested.
    end

    success, errMsg = dropAt(dropDirection, MAX_STACK_SIZE, false)
    if success == false then return false, errMsg end -- could not drop in that direction
  end
end


function moveAllBetween(suckDirection, dropDirection)
  -- TODO finish, moves all items from one source chest to another
  -- TODO currently this only moves 1 stack at a time
  local success, tempSlots
  local origx = getx() -- save original position and direction so it can be reset to this at the end
  local origy = gety()
  local origz = getz()
  local origFace = getDirection()

  local noMoreItems = false
  local cantDropItems = false
  local finishLastDrop = false

  tempSlots = {}
  for i=1,16 do
    if turtle.getItemDetail(i) == nil then
      table.insert(tempSlots, i)
    end
  end

  if DEBUG then print('temp slots: ' .. table.concat(tempSlots, ',')) end

  if selectEmptySlot() == false then return false, 'No empty slots' end

  while true do
    -- grab items from source
    for i=1,#tempSlots do
      turtle.select(tempSlots[i])
      success = suckFrom(suckDirection, MAX_STACK_SIZE, false)
      if success == false then
        if i == 1 then
          noMoreItems = true
          break
        else
          finishLastDrop = true
        end
      end
    end
    if noMoreItems then break end

    -- drop items at drop site
    for i=1,#tempSlots do
      turtle.select(tempSlots[i])
      success = dropAt(dropDirection, MAX_STACK_SIZE, false)
      if success == false then
        cantDropItems = true
        break
      end
    end

    if finishLastDrop then break end
  end

  goto(origx, origy, origz)
  face(origFace)
end


function getRecipe(itemName)
  -- TODO find recipe by name
  -- TODO where to store the recipes? In a file? How can the user add new recipes?
  -- TODO should recipes be arrays of 9 or 16 items?
end

function craft(recipe, amount, suckDirection, dropDirection, slot, timeout)
  -- return value is the slot number where crafted result is
  -- how do we craft multiple items?
  -- what if I want to feed this function a list of "you can find this ingredient in this chest", and let it figure out how to make everything?
  -- when it can't create, it should return an error
  --arrange()
  -- TODO arranges and then crafts item
  -- need to figure out how to handle getting stuff from chests

  -- TODO pickout items still needed for the recipe, and when found put them in the proper slot

  -- TODO craft the item, then place it in the result direction

end


function dropItem(itemName, amount)
  if not selectItem(itemName) then return false end
  return turtle.drop(amount)
end


function dropItemDown(itemName, amount)
  if not selectItem(itemName) then return false end
  return turtle.dropDown(amount)
end


function dropItemUp(itemName, amount)
  if not selectItem(itemName) then return false end
  return turtle.dropUp(amount)
end


function dropAllItem(itemName)
  while dropItem(itemName) do end
end


function dropAllItemDown(itemName)
  while dropItemDown(itemName) do end
end


function dropAllItemUp(itemName)
  while dropItemUp(itemName) do end
end


function suckAll()
  while turtle.suck(MAX_STACK_SIZE) do end
end


function suckAllDown()
  while turtle.suckDown(MAX_STACK_SIZE) do end
end


function suckAllUp()
  while turtle.suckUp(MAX_STACK_SIZE) do end
end


function getFuelPercent()
  return 100 * turtle.getFuelLevel() / turtle.getFuelLimit()
end


function getFuelSpace()
  -- returns amount of fuel free space there is
  return turtle.getFuelLimit() - turtle.getFuelLevel()
end


function getItemNames()
  local i, itemData, names = {}
  for i=1,16 do
    itemData = turtle.getItemDetail(i)
    table.insert(names, itemData)
  end
  return names
end


function selectEmptySlot()
  local i, itemData
  for i=1,16 do
    itemData = turtle.getItemDetail(i)
    if itemData == nil then
      return turtle.select(i) -- TODO is this correct? What does select return?
    end
  end
  return false, 'No empty slots'
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
  if not table.contains({'north', 'n', 'south', 's', 'east', 'e', 'west', 'w'}, d) then
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


function matchesGPS()
local gpsx, gpsy, gpsz = gps.locate()
  if x == nil then
    return false, 'GPS not available'
  else
    if x == gpsx and y == gpsy and z == gpsz then
      return true
    else
      return false, 'Position does not match GPS'
    end
  end
end


function recordMove(move)
  if (recordedMoves[#recordedMoves] == move) then
    table.insert(recordedMoves, 2) -- adding a second move of the same type
  elseif (type(recordedMoves[#recordedMoves]) == 'number') and (recordedMoves[#recordedMoves - 1] == move) then
    prevCount = table.remove(recordedMoves, #recordedMoves)
    table.insert(recordedMoves, prevCount + 1) -- increment the existing count
  else
    table.insert(recordedMoves, move) -- this is a new, non-repeated move, so just append it
  end
end


function record()
  recordedMoves = {}
  recordingNow = true
end


function stopRecording()
  recordingNow = false
  return table.concat(recordedMoves, ' ')
end


function getRecording()
  return table.concat(recordedMoves, ' ')
end


function table.tostring(tab)
  result = '{'
  for k, v in pairs(tab) do
    result = result .. tostring(k) .. ': ' .. tostring(v) .. ', '
  end
  return result .. '}'
end


function nineSpaceToSixteenSpace(slot)
  if slot <= 3 then return slot end
  if slot <= 6 then return slot + 1 end
  if slot <= 9 then return slot + 2 end
  return false, 'Not a valid nine-space slot'
end


function sixteenSpaceToNineSpace(slot)
  if slot <= 3 then return slot end
  if slot >= 5 and slot <= 7 then return slot - 1 end
  if slot >= 9 and slot <= 11 then return slot - 2 end
  return false, 'Cannot convert to valid nine-space slot'
end



function manufacture(recipe, amount, sourceDirection, resultDirection, discardDirection)
  local success, errMsg
  if amount == nil then amount = MAX_STACK_SIZE end

  -- recipe is a 9-item array for a 3x3 recipe, it must be converted to a full 4x4 sized recipe
  fullSizeRecipe = {recipe[1], recipe[2], recipe[3], '', recipe[4], recipe[5], recipe[6], '', recipe[7], recipe[8], recipe[9], '', '', '', '', ''}

  -- call arrange to see if the turtle already carries parts for the recipe (discarding any non-recipe items)
  success, errMsg = arrange(fullSizeRecipe, discardDirection)
  if success == false then
    -- if the turtle can't craft the item, then pick out craft items from the source (discarding them if they are non-recipe items)
    for i=1,9 do
      -- (because we ran arrange(), we can assume that if a slot isn't blank then it has the correct recipe item)
      if turtle.getItemDetail(nineSpaceToSixteenSpace(i)) == nil then
        success, errMsg = pickOut(recipe[i], amount, sourceDirection, discardDirection, nineSpaceToSixteenSpace(i))
        if success == false then return false, errMsg end -- TODO test this
      end
    end
  end

  -- (if there isn't enough recipe items, then just return false)

  -- put the resulting crafted item in the result Direction

end


alloyrep = {'alloy','alloy','alloy','','alloy','alloy','alloy','','alloy','alloy','alloy','','','','',''}


-- startup code to run:
useGPS()
