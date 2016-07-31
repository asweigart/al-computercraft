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


function sweepField(rows, columns, sweepFunc, endSweepFunc)
  local turnRight = true
  local columnStep, rowStep
  for columnStep=1,columns do
    if sweepFunc ~= nil then
      sweepFunc()
    end

    -- move forward through rows
    for rowStep=1,rows-1 do
      turtle.forward()
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
      turtle.forward()
      turtle.turnRight()
      turnRight = false
    else
      turtle.turnLeft()
      turtle.forward()
      turtle.turnLeft()
      turnRight = true
    end
  end

  -- move back to the start
  if columns % 2 == 0 then
    turtle.turnRight()
  else
    for i=1,rows-1 do
      turtle.back()
    end
    turtle.turnLeft()
  end
  for i=1,columns-1 do
    turtle.forward()
  end
  turtle.turnRight()

  if endSweepFunc ~= nil then
    endSweepFunc()
  end
end