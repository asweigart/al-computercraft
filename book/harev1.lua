-- "Hare" utility library
-- By Al Sweigart
-- turtleappstore.com/AlSweigart
-- Provides useful utility functions.

hareVersion = "1"

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
