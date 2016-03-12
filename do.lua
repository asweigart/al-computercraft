-- This is a ComputerCraft script to easily run turtle API commands from the turtle's command line.
-- Written by al@inventwithpython.com
-- Find my other scripts at https://github.com/asweigart/al-computercraft
-- or http://turtlescripts.com/profile/AlSweigart



local VALID_ACTIONS = {'f', 'forward', 'b', 'back', 'l', 'left', 'r', 'right', 'up', 'dn', 'down', 'fn', 'fs', 'fe', 'fw', 'facenorth', 'facesouth', 'faceeast', 'facewest', 'no', 'north', 'so', 'south', 'ea', 'east', 'we', 'west', 'd', 'dig', 'du', 'digup', 'dd', 'digdown', 'i', 'inspect', 'iu', 'inspectup', 'id', 'inspectdown', 'sel', 'select', 's', 'suck', 'su', 'suckup', 'sd', 'suckdown', 'p', 'place', 'pu', 'placeup', 'pd', 'placedown', 'dr', 'drop', 'dru', 'dropup', 'drd', 'dropdown'}


local tArgs = {...}
if #tArgs < 1 then
  print('Usage: do <cmd> [<repeat>] [more]')
  print('  Commands are:')
  print('    f, b, up, dn, l, r - move')
  print('    d, du, dd - dig (up, down)')
  print('    i, iu, id - inspect (up, down)')
  print('    sel <num> - select inv num')
  print('    s, su, sd - suck items (up, down)')
  print('    dr, dru, drd - drop (up, down)')
  print('    p, pu, pd - place (up, down)')
  print('Example: do r f 2')
  print('(Turn right, move forward twice.)')
  return
end




function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end


function split(str)
  -- splits a string up into an array of strings
  str = string.lower(str)
  local actions = {}
  local word
  for word in str:gmatch("%w+") do table.insert(actions, word) end
  return actions
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
      for j=1,reps do
        success, errMsg = turtle.forward()
        if safeMode and not success then return success, errMsg end
      end
    elseif actions[i] == 'b' or actions[i] == 'back' then
      for j=1,reps do
        success, errMsg = turtle.back()
        if safeMode and not success then return success, errMsg end
      end
    elseif actions[i] == 'l' or actions[i] == 'left' then
      for j=1,reps do
        turtle.turnLeft()
      end
    elseif actions[i] == 'r' or actions[i] == 'right' then
      for j=1,reps do
        turtle.turnRight()
      end
    elseif actions[i] == 'up' then
      for j=1,reps do
        success, errMsg = turtle.up()
        if safeMode and not success then return success, errMsg end
      end
    elseif actions[i] == 'dn' or actions[i] == 'down' then
      for j=1,reps do
        success, errMsg = turtle.down()
        if safeMode and not success then return success, errMsg end
      end
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


doActions(table.concat(tArgs, ' '))


