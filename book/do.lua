--[[ "Act" program
By Al Sweigart
turtleappstore.com/users/AlSweigart
Does various actions from shell. ]]

local slot, waitTime, cliArgs, actions

function doAction(action, verbose)
  action = string.lower(action)

  -- look at these strings for the action codes
  if action == 'f' then
    return turtle.forward()
  elseif action == 'b' then
    return turtle.back()
  elseif action == 'l' then
    return turtle.turnLeft()
  elseif action == 'r' then
    return turtle.turnRight()
  elseif action == 'up' then
    return turtle.up()
  elseif action == 'dn' then
    return turtle.down()
  elseif action == 'd' then
    return turtle.dig()
  elseif action == 'du' then
    return turtle.digUp()
  elseif action == 'dd' then
    return turtle.digDown()
  elseif action == 'i' then
    -- TODO
    return turtle.inspect()
  elseif action == 'iu' then
    -- TODO
    return turtle.inspectUp()
  elseif action == 'id' then
    -- TODO
    return turtle.inspectDown()
  elseif action == 's' then
    return turtle.suck()
  elseif action == 'sd' then
    return turtle.suckDown()
  elseif action == 'su' then
    return turtle.suckUp()
  elseif action == 'p' then
    return turtle.place()
  elseif action == 'pu' then
    return turtle.placeUp()
  elseif action == 'pd' then
    return turtle.placeDown()
  elseif action == 'dr' then
    return turtle.drop()
  elseif action == 'dru' then
    return turtle.dropUp()
  elseif action == 'drd' then
    return turtle.dropDown()
  elseif action == 'c' then
    return turtle.craft()
  elseif action == 'el' then
    return turtle.equipLeft()
  elseif action == 'er' then
    return turtle.equipRight()
  elseif action == 'a' then
    return turtle.attack()
  elseif action == 'au' then
    return turtle.attackUp()
  elseif action == 'ad' then
    return turtle.attackDown()
  elseif action == 'det' then
    return turtle.detect()
  elseif action == 'detup' then
    return turtle.detectUp()
  elseif action == 'detd' then
    return turtle.detectDown()  
  elseif action == 'cmp' then
    return turtle.compare()
  elseif action == 'cmpu' then
    return turtle.compareUp()
  elseif action == 'cmpd' then
    return turtle.compareDown()
  elseif action == 'ref' then
    return turtle.refuel()
  elseif string.sub(action, 1, 3) == 'sel' then
    slot = tonumber(string.sub(action, 4, 2))
    return turtle.select(slot)
  elseif string.sub(action, 1, 4) == 'tran' then
    --local from = tonnumber(string.sub())
    -- TODO - finish
  elseif action == 'rf' then
    return redstone.setOutput('front', not redstone.getOutput('front'))
  elseif action == 'rb' then
    return redstone.setOutput('back', not redstone.getOutput('back'))
  elseif action == 'rtop' then
    return redstone.setOutput('top', not redstone.getOutput('top'))
  elseif action == 'rbot' then
    return redstone.setOutput('bottom', not redstone.getOutput('bottom'))
  elseif action == 'rl' then
    return redstone.setOutput('left', not redstone.getOutput('left'))
  elseif action == 'rr' then
    return redstone.setOutput('right', not redstone.getOutput('right'))
  elseif string.sub(action, 1, 1) == 'w' then 
    waitTime = tonumber(string.sub(action, 2))
    os.sleep(waitTime)
    return true
  
  else
    -- not a recognized action
    return false, 'Not a recognized action.'
  end
end


function split(str)
  -- splits a string into an array of strings
  -- Example: 'a b c' -> {'a', 'b', 'c'}
  local result, word

  result = {}
  -- Note: The gmatch() function is
  -- beyond the scope of this book.
  for word in str:gmatch("%w+") do 
    table.insert(result, word) 
  end
  return result
end


function doActions(actions)
  -- Do a series of actions.
  -- actions is a string: "f r 3" will
  -- go forward, turn right 3 times.
  -- See doAction() for action codes.
  -- If safeMode is true, then stop
  -- if one action fails.

  -- get array of strings from string
  actions = split(actions)

  while #actions > 0 do
    -- check for rep count
    if tonumber(actions[2]) ~= nil then
      -- reduce the rep count by 1
      actions[2] = tonumber(actions[2]) - 1
    end
    if tonumber(actions[2]) == 0 then
      -- if the rep count is 0, remove it
      table.remove(actions, 2)
    end

    -- do the action
    result1, result2 = doAction(actions[1])

    if tonumber(actions[2]) == nil then
      -- if there's no rep count,
      -- remove this action
      table.remove(actions, 1)
    end

    -- check for error message
    if type(result2) == 'string' then
      -- action failed, return the error message
      return result2
    end
  end

  return 'ok' -- all actions done
end

d = doActions


-- display "usage" info
cliArgs = {...}
if cliArgs[1] == '?' then
	print('Usage: act [actions]')
	print('See source code for actions.')
	print('Example: "act l f 3 r b 2" will turn')
	print('left, go forward 3 times, turn right,')
	print('then move back 2 times.')

	return
elseif #cliArgs ~= 0 then
  actions = table.concat(cliArgs, ' ')
  print(doActions(actions))
end
