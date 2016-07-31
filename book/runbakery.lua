-- Robotic Bakery program
-- By Al Sweigart
-- al@inventwithpython.com
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

MON_BLOCK = 'computercraft:CC-Peripheral'
turtleFacing = nil
turtlePosition = nil


local function isMonitor(block)
  -- returns true if block is a monitor
  -- basic monitors metadata = 10
  -- advanced monitors metadata = 12
  if block['name'] == MON_BLOCK and (block['metadata'] == 10 or block['metadata'] == 12) then
    turtleFacing = 'front'
    turtlePosition = 9
    return true
  else
    turtleFacing = nil
    turtlePosition = nil
    return false
  end
end


local function isInStartPosition()
  -- check for facing the monitor
  -- (this is the start position)
  result, block = turtle.inspect()
  if result == nil or not isMonitor(block) then
    print('Please position turtle facing the')
    print('monitor and re-run this program.')
    return false
  else
    return true
  end
end


local function moveTo(position, facing)
  if position == nil or facing == nil then
    print('ERROR: Don\'t know where turtle is.')
    return false
  end

  -- check if already there
  if position == turtlePosition and facing == turtleFacing then
    return true
  end

  -- figure out the 
end


local function craftCake()

end


local function pickUpIngredient(ingred)

end


local function getCakeCount()
  local fo = fs.open('cakecount', 'r')
  local count = fo.readAll()
  fo.close()
  -- note: count is a string, not num
  return count
end


local function setCakeCount(count)
  local fo = fs.open('cakecount', 'w')
  fo.write(tostring(count))
  fo.close()
end
