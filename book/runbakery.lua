-- Robotic Bakery program
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Runs a bakery.

--[[
Bakery blueprint:

  e.M.S.E.W  (back)
  123456789
  CCssssssm  (front)

Key:
e = Chest of empty buckets
M = Chest of milk buckets
S = Chest of sugar
E = Chest of eggs
W = Chest of wheat
C = Chest of cakes (and empty buckets)
s = Shelf for cakes
m = Monitor
. = Empty space
Numbers = Number positions

(Leave number positions empty!)
Pos 9 and facing m is start pos.
--]]

os.loadAPI('hare')

-- constants for ingredient positions
EMPTY_BUCKETS_POS = 1
CAKE_CHEST_POS = 2
MILK_BUCKETS_POS = 3
SUGAR_POS = 5
EGGS_POS = 7
WHEAT_POS = 9
MONITOR_POS = 9

turtleFacing = nil
turtlePosition = nil

if hare.findBlock('computercraft:CC-Peripheral') then
  turtleFacing = 'front'
  turtlePosition = 9  
else
  error('Please position turtle next to the monitor and re-run this program.')  
end


-- moveTo() moves the turtle to the
-- numbered and faces it either 'front'
-- or 'back' of the bakery.
local function moveTo(toPosition, toFacing)
  if turtlePosition == nil or turtleFacing == nil then
    error('Don\'t know where turtle is.')
    return false
  end

  -- move to the destination
  if toPosition > turtlePosition then
    -- move towards higher numbered positions
    if turtleFacing == 'front' then
      turtle.turnLeft()
    else
      turtle.turnRight()
    end

    for i = 1, (toPosition - turtlePosition) do
      if not turtle.forward() then
        error('Movement obstructed.')
      end
    end

    if toFacing == 'front' then
      turtle.turnRight()  -- face front
    else
      turtle.turnLeft()  -- face back
    end
  elseif toPosition < turtlePosition then
    -- move towards lower numbred positions
    if turtleFacing == 'front' then
      turtle.turnRight()
    else
      turtle.turnLeft()
    end

    for i = 1, (turtlePosition - toPosition) do
      if not turtle.forward() then
        error('Movement obstructed.')
      end
    end

    if toFacing == 'front' then
      turtle.turnLeft()  -- face front
    else
      turtle.turnRight()  -- face back
    end
  else
    if toFacing ~= turtleFacing then
      -- turn around
      turtle.turnLeft()
      turtle.turnLeft()
    end
  end

  turtlePosition = toPosition
  turtleFacing = toFacing
end


-- getCakeCount() returns the number
-- in the cakecount file
local function getCakeCount()
  local fo = fs.open('cakecount', 'r')
  
  if fo == nil then return 0 end

  local count = fo.readAll()
  fo.close()
  return tonumber(count)
end


-- setCakeCount() set the number in
-- the cakecount file
local function setCakeCount(count)
  local fo = fs.open('cakecount', 'w')
  fo.write(tostring(count))
  fo.close()
end


-- pickUpIngredient() moves to the 
-- chest with the ingredient and gets
-- one for each slot in 'slots'.
local function pickUpIngredient(ingredient, position, facing, slots)
  print('Getting ' .. ingredient .. '...')
  moveTo(position, facing)  -- go to ingredient's chest
  local index, slot
  for index, slot in pairs(slots) do
    -- pick up ingredient
    turtle.select(slot)
    if not turtle.suck(1) then
      print('Out of ' .. ingredient .. '!')
      print('Sleeping until chest is refilled...')
      while not turtle.suck(1) do
        os.sleep(10)
      end
    end
  end
end


-- bakeCake() will do everything to
-- make a cake
local function bakeCake()
  if turtle.getFuelLevel() < 45 then
    moveTo(MONITOR_POS, 'front')
    print('Not enough fuel to continue.')
    return  
  end  

  -- TODO - do a check to make sure all inventory slots are empty?
  pickUpIngredient('wheat', WHEAT_POS, 'back', {9, 10, 11})
  pickUpIngredient('eggs', EGGS_POS, 'back', {6})
  pickUpIngredient('sugar', SUGAR_POS, 'back', {5, 7})
  pickUpIngredient('milk', MILK_BUCKETS_POS, 'back', {1, 2, 3})

  print('Making a cake...')
  turtle.select(16)  -- craft cake in slot 16
  turtle.craft()

  -- drop off empty buckets
  print('Dropping off empty buckets...')
  moveTo(EMPTY_BUCKETS_POS, 'back')
  for slot = 1, 3 do
    turtle.select(slot)
    turtle.drop()  -- put bucket in chest
  end

  -- put cake on shelf, if there's space
  turtle.select(16)  -- select cake
  local i
  local placedOnShelf = false
  for i = 8, 3, -1 do  
    -- try shelf at positions 8 to 3
    moveTo(i, 'front')
    if not turtle.detect() then
      turtle.place()
      placedOnShelf = true
      break
    end
  end

  if placedOnShelf then
    print('Cake placed on shelf.')
  else
    moveTo(CAKE_CHEST_POS, 'front')
    turtle.drop()
    print('Cake placed in cake chest.')
  end

  -- update cake count file
  local cakesBaked = getCakeCount() + 1
  setCakeCount(cakesBaked)
  print('I have baked ' .. cakesBaked .. ' cakes!')

  -- update the status monitor
  moveTo(MONITOR_POS, 'front')
  mon = peripheral.wrap('front')
  if mon == nil then
    error('No monitor in front of turtle!')
  end
  mon.clear()
  mon.setCursorPos(1, 1)
  mon.write('Cakes')
  mon.setCursorPos(1, 2)
  mon.write('baked:')
  mon.setCursorPos(2, 4)
  mon.write(tostring(cakesBaked))
end


while true do
  bakeCake()
end