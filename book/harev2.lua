-- "Hare" utility library
-- By Al Sweigart
-- al@inventwithpython.com
-- Provides useful utility functions.

version = "2"

function fuelSpace()
  if turtle.getFuelLimit() == 'unlimited' then
    return 0
  else 
    return turtle.getFuelLimit() - turtle.getFuelLevel()
  end
end

function findItem(name, metadata)
  -- finds inventory slot that has the named item
  -- returns slot number if found, nil if not found
  local slot, item

  -- first try to find an exact match
  for slot=1,16 do
    item = turtle.getItemDetail(slot)
    if item ~= nil and 
       item['name'] == name and
       (metadata == nil or item['metadata'] == metadata) then
      return slot
    end
  end

  -- don't try a similar match if name has a colon (like "minecraft:")
  if string.find(name, ':') ~= nil then
    return nil
  end

  -- next try to find a similar match
  for slot=1,16 do
    item = turtle.getItemDetail(slot)
    if item ~= nil and 
       string.find(item['name'], name) and
       (metadata == nil or item['metadata'] == metadata) then
      return slot
    end
  end

  return nil -- couldn't find item
end


function selectItem(name, metadata)
  -- selects inventory slot that has the named item
  -- return true if found, false if not found
  local slot = findItem(name, metadata)

  if slot ~= nil then
    turtle.select(slot)
    return true
  else
    return false -- couldn't find item
  end
end


function findEmptySlot()
  -- finds inventory slot that has nothing in it
  -- returns slot number if found, nil if not found
  local slot
  for slot=1,16 do
    if turtle.getItemCount(slot) == 0 then
      return slot
    end
  end
  return nil -- couldn't find empty space
end


function selectEmptySlot()
  -- selects inventory slot that has nothing in it
  -- return true if found, false if not found
  local slot = findEmptySlot()
  if slot ~= nil then
    turtle.select(slot)
    return true
  else
    return false -- couldn't find empty space
  end
end


function findBlock(name)
  -- spins aorund searching for the named block
  local foundBlock = false
  local i
  for i=1,4 do
    local result, block = turtle.inspect()
    if block ~= nil and block['name'] == name then
      return true
    end
    turtle.turnRight()
  end
  return false
end


function sweepField(rows, columns, sweepFunc, endSweepFunc)
  local turnRight = true
  local columnStep, rowStep
  for columnStep=1,columns do
    if sweepFunc ~= nil then
      sweepFunc()
    end

    -- move forward through rows
    for rowStep=1,rows-1 do
      if not turtle.forward() then return false end
      if sweepFunc ~= nil then
        sweepFunc()
      end
    end

    if columnStep == columns then
      -- don't turn on the last column
      break
    end

    -- turn to the next column
    if turnRight then
      turtle.turnRight()
      if not turtle.forward() then return false end
      turtle.turnRight()
      turnRight = false
    else
      turtle.turnLeft()
      if not turtle.forward() then return false end
      turtle.turnLeft()
      turnRight = true
    end
  end

  -- move back to the start
  if columns % 2 == 0 then
    turtle.turnRight()
  else
    for i=1,rows-1 do
      if not turtle.back() then return false end
    end
    turtle.turnLeft()
  end
  for i=1,columns-1 do
     if not turtle.forward() then return false end
  end
  turtle.turnRight()

  if endSweepFunc ~= nil then
    endSweepFunc()
  end

  return true
end


function countItems(name)
  -- returns the number of items with
  -- the exact given name that are in
  -- the turtle's inventory

  local total = 0
  local slot
  for slot=1,16 do
    item = turtle.getItemDetail(slot)
    if item ~= nil and item['name'] == name then
      total = total + item['count']
    end
  end
  return total
end
