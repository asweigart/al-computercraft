-- "Hare" utility library
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Provides useful utility functions.

hareVersion = "3"

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


-- sweepField() moves across the rows
-- and columns of an area in front and
-- to the right of the turtle, calling
-- the provided sweepFunc at each point
function sweepField(rows, columns, sweepFunc)
  local turnRightNext = true
  local columnStep = 1
  local rowStep = 1
  for columnStep = 1, columns do
    if sweepFunc ~= nil then
      sweepFunc(rowStep, columnStep, rows, columns)
    end

    -- move forward through rows
    for rowStep = 2, rows do
      if not turtle.forward() then return false end

      -- call the sweepFunc function
      if sweepFunc ~= nil then
        sweepFunc(rowStep, columnStep, rows, columns)
      end
    end

    if columnStep == columns then
      -- don't turn on the last column
      break
    end

    -- turn to the next column
    if turnRightNext then
      turtle.turnRight()
      if not turtle.forward() then return false end
      turtle.turnRight()
      turnRightNext = false
    else
      turtle.turnLeft()
      if not turtle.forward() then return false end
      turtle.turnLeft()
      turnRightNext = true
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


-- countItems() returns the total number
-- of items with the exact name in the
-- turtle's inventory
function countItems(name)
  local total = 0
  local slot
  for slot = 1,16 do
    local item = turtle.getItemDetail(slot)
    if item ~= nil and item['name'] == name then
      total = total + item['count']
    end
  end
  return total
end


-- countInventory() returns the total
-- number of items in the inventory
function countInventory()
  local total = 0
  local slot
  for slot = 1, 16 do
    total = total + turtle.getItemCount(slot)
  end
  return total
end


-- buildRectangleFloor() builds a rectangle
-- shaped floor out of the blocks in the
-- inventory
function buildRectangleFloor(length, width)
  if countInventory() < length * width then
    return false, 'Not enough blocks.'  -- not enough blocks
  end
  turtle.up()
  sweepField(length, width, selectAndPlaceDown)
end


-- selectAndPlaceDown() selects a nonempty
-- slot and places it under the turtle
function selectAndPlaceDown()
  local slot
  for slot = 1, 16 do
    if turtle.getItemCount(slot) > 0 then
      turtle.select(slot)
      turtle.placeDown()
      break
    end
  end
end


-- buildWall() creates a wall stretching
-- in front of the turtle
function buildWall(length, height)
  if countInventory() < length * height then
    return false  -- not enough blocks
  end

  turtle.up()

  local currentHeight, currentLength
  local movingForward = true
  for currentHeight = 1, height do
    for currentLength = 1, length do
      selectAndPlaceDown() -- place the block
      if movingForward and currentLength ~= length then
        turtle.forward()
      elseif not movingForward and currentLength ~= length then
        turtle.back()
      end
    end
    if currentHeight ~= height then
      turtle.up()
    end
    movingForward = not movingForward
  end

  -- done building wall, move to end position
  local i
  if movingForward then
    -- turtle near the start position
    for i = 1, length do
      turtle.forward()
    end
  else
    -- turtle near the end position
    turtle.forward()
  end

  -- move down to the ground
  for i = 1, height do
    turtle.down()
  end
end


-- 
function buildRoom(length, width, height)
  if countInventory() < ((length * height * height) - ((length - 1) * (height - 1) * height)) then
    return false  -- not enough blocks
  end

  -- build the four walls
  buildWall(length - 1, height)
  turtle.turnRight()

  buildWall(width - 1, height)
  turtle.turnRight()
  
  buildWall(length - 1, height)
  turtle.turnRight()
  
  buildWall(width - 1, height)
  turtle.turnRight()
end


-- buildCircleFloor() builds a circle
-- shaped floor out of the blocks in the
-- inventory, centered on the turtle's
-- starting position
function buildCircleFloor(radius)
  -- this is an overestimation of the blocks needed
  local diameter = radius * 2 + 1
  if countInventory() < (diameter * diameter)  then
    return false, 'Not enough blocks.'  -- not enough blocks
  end

  -- move to start of sweep area
  local i
  turtle.up()
  turtle.turnLeft()
  for i = 1, math.floor(radius) do
    turtle.forward()
  end
  turtle.turnRight()
  for i = 1, math.floor(radius) do
    turtle.back()
  end

  -- place blocks
  sweepField(radius * 2 + 1, radius * 2 + 1, selectAndPlaceDownInCircle)

  -- move back to center
  for i = 1, math.floor(radius) do
    turtle.forward()
  end
  turtle.turnRight()
  for i = 1, math.floor(radius) do
    turtle.forward()
  end
  turtle.turnLeft()
end


-- selectAndPlaceDownInCircle() selects 
-- a nonempty slot and places it under 
-- the turtle if it is within the circle's
-- radius
function selectAndPlaceDownInCircle(x, y, length, width)
  local radius = math.floor(length / 2)
  local centerx = math.ceil(length / 2)
  local centery = math.ceil(width / 2)
  
  local xdistance = centerx - x
  local ydistance = centery - y

  if (math.sqrt(xdistance * xdistance + ydistance * ydistance) < radius) then
    selectAndPlaceDown()
      print(x, y, length, width, 'yes')
  else
      print(x, y, length, width, 'no')
  end
end