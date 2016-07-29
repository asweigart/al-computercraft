-- "Hare" utility library
-- By Al Sweigart
-- al@inventwithpython.com
-- Provides useful utility functions.

version = "1"

function fuelSpace()
  if turtle.getFuelLimit() == 'unlimited' then
    return 0
  else 
    return turtle.getFuelLimit() - turtle.getFuelLevel()
  end
end

function findItem(name, metadata)
  -- finds inventory slot that has
  -- the named item
  -- returns slot number if found
  -- returns nil if not found
  local slot, item

  -- first try to find an exact match
  for slot=1,16 do
    item = turtle.getItemDetail(slot)
    if item ~= nil and 
       item['name'] == 'minecraft:' .. name and
       (metadata == nil or item['metadata'] == metadata) then
      return slot
    end
  end

  -- try to find a similar match
  for slot=1,16 do
    item = turtle.getItemDetail(slot)
    if item ~= nil and 
       string.find(item['name'], name) and
       (metadata == nil or item['metadata'] == metadata) then
      return slot
    end
  end

  return nil -- could not find item
end


function selectItem(name, metadata)
  -- selects inventory slot that has
  -- the named item
  -- return true if found
  -- returns false if not found
  local slot = findItem(name, metadata)

  if slot ~= nil then
    turtle.select(slot)
    return true
  else
    return false
  end
end


function findEmptySlot()
  local slot
  for slot=1,16 do
    if turtle.getItemCount(slot) == 0 then
      return slot
    end
  end
  return nil
end


function selectEmptySlot()
  local slot = findEmptySlot()
  if slot ~= nil then
    turtle.select(slot)
    return true
  else
    return false
  end
end
