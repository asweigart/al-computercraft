-- "Hare" utility library
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Provides useful utility functions.

hareVersion = "2"

-- fuelSpace() returns how much space
-- for fuel there is left
function fuelSpace()
  if turtle.getFuelLimit() == 'unlimited' then
    return 0
  else 
    return turtle.getFuelLimit() - turtle.getFuelLevel()
  end
end

-- findItem() returns inventory slot 
-- that has the named item, or nil if not found
function findItem(name)
  local slot, item

  -- first try to find an exact name match
  for slot = 1, 16 do
    item = turtle.getItemDetail(slot)
    if item ~= nil and item['name'] == name then
      return slot
    end
  end

  -- don't try a similar match if name
  -- has a colon (like "minecraft:")
  if string.find(name, ':') ~= nil then
    return nil  -- couldn't find item
  end

  -- next try to find a similar name match
  for slot = 1, 16 do
    item = turtle.getItemDetail(slot)
    if item ~= nil and string.find(item['name'], name) then
      return slot
    end
  end

  return nil  -- couldn't find item
end


-- selectItem() selects the inventory
-- slot with the named item, returns
-- true if found and false if not
function selectItem(name)
  -- selects inventory slot that has the named item
  -- return true if found, false if not found
  local slot = findItem(name)

  if slot ~= nil then
    turtle.select(slot)
    return true
  else
    return false -- couldn't find item
  end
end


-- findEmptySlot() finds inventory slot
-- that is empty, returns slot number
-- if found, returns nil if no empty spaces
function findEmptySlot()
  -- loop through all slots
  local slot
  for slot = 1, 16 do  
    if turtle.getItemCount(slot) == 0 then
      return slot
    end
  end
  return nil -- couldn't find empty space
end


-- selectEmptySlot() selects inventory
-- slot that is empty, returns true if 
-- found, false if no empty spaces
function selectEmptySlot()
  -- loop through all slots
  local slot = findEmptySlot()
  if slot ~= nil then
    turtle.select(slot)
    return true
  else
    return false -- couldn't find empty space
  end
end


-- findBlock() spins around searching
-- for the named block next to the turtle
function findBlock(name)
  local foundBlock = false
  local i
  for i = 1, 4 do
    local result, block = turtle.inspect()
    if block ~= nil and block['name'] == name then
      return true
    end
    turtle.turnRight()
  end
  return false
end


-- sweepField() moves
function sweepField(rows, columns, sweepFunc)
  local turnRight = true
  local columnStep, rowStep
  for columnStep = 1, columns do
    if sweepFunc ~= nil then
      sweepFunc()
    end

    -- move forward through rows
    for rowStep = 1, rows - 1 do
      if not turtle.forward() then return false end

      -- call the sweepFunc function
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
    for i = 1, rows - 1 do
      if not turtle.back() then return false end
    end
    turtle.turnLeft()
  end
  for i = 1, columns - 1 do
     if not turtle.forward() then return false end
  end
  turtle.turnRight()

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
