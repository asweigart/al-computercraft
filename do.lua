-- This is a ComputerCraft script to easily run turtle API commands from the turtle's command line.

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
  print('(Turn right, move forward twice.')
  return
end

local i, j, k, v

local function outOfFuel()
  if turtle.getFuelLevel() == 0 then
    print('Out of fuel!')
    return true
  else
    return false
  end
end

local function inspectAndPrintResults(direction)
  local success, inspectResults, icmd
  if direction == '' then
    success, inspectResults = turtle.inspect()
  elseif direction == 'down' then
    success, inspectResults = turtle.inspectDown()
  elseif direction == 'up' then
    success, inspectResults = turtle.inspect()
  end

  if direction == '' then
    icmd = 'inspect '
  elseif direction == 'down' then
    icmd = 'inspectDown '
  elseif direction == 'up' then
    icmd = 'inspectUp '
  end

  if not success then
    print(icmd .. 'false')
  else
    print(icmd .. 'true')
    for k, v in pairs(inspectResults) do
      print(k, '=', v)
    end
    io.write('\n')
  end
end

-- main program
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
        print('forward ' .. tostring(turtle.forward()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'b' then
    for j = 1,reps do
        print('back ' .. tostring(turtle.back()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'l' then
    for j = 1,reps do
        print('left ' .. tostring(turtle.turnLeft()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'r' then
    for j = 1,reps do
        print('right ' .. tostring(turtle.turnRight()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'up' then
    for j = 1,reps do
        print('up ' .. tostring(turtle.up()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'dn' then
    for j = 1,reps do
        print('down ' .. tostring(turtle.down()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'd' then
    for j = 1,reps do
        print('dig ' .. tostring(turtle.dig()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'du' then
    for j = 1,reps do
        print('digUp ' .. tostring(turtle.digUp()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'dd' then
    for j = 1,reps do
        print('digDown ' .. tostring(turtle.digDown()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'i' then
    for j = 1,reps do
        inspectAndPrintResults('')
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'iu' then
    for j = 1,reps do
        inspectAndPrintResults('up')
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'id' then
    for j = 1,reps do
        inspectAndPrintResults('down')
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'sel' then
    -- in this case, reps is the inventory number
    print('select ' .. reps .. ' ' .. tostring(turtle.select(reps)))
    if outOfFuel() then return end
  elseif tArgs[i] == 'item' then
    -- display info about the item stack
    local itemData = turtle.getItemDetail()
    if itemData ~= nil then
      for k, v in pairs(itemDetail) do
        print(k, '=', v)
      end
    else
      print('No item at slot #' .. tostring(turtle.getSelectedSlot()))
    end
  elseif tArgs[i] == 's' then
    for j = 1,reps do
        print('suck ' .. tostring(turtle.suck()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'su' then
    for j = 1,reps do
        print('suckUp ' .. tostring(turtle.suckUp()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'sd' then
    for j = 1,reps do
        print('suckDown ' .. tostring(turtle.suckDown()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'p' then
    for j = 1,reps do
        print('place ' .. tostring(turtle.place()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'pu' then
    for j = 1,reps do
        print('placeUp ' .. tostring(turtle.placeUp()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'pd' then
    for j = 1,reps do
        print('placeDown ' .. tostring(turtle.placeDown()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'dr' then
    for j = 1,reps do
        print('drop ' .. tostring(turtle.drop()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'dru' then
    for j = 1,reps do
        print('dropUp ' .. tostring(turtle.dropUp()))
        if outOfFuel() then return end
    end
  elseif tArgs[i] == 'drd' then
    for j = 1,reps do
        print('dropDown ' .. tostring(turtle.dropDown()))
        if outOfFuel() then return end
    end
  end
end