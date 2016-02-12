--[[lava scooper
Just goes forward until it is blocked or fills up on lava, then returns]]
local tArgs = {...}

if #tArgs < 1 and tonumber(tArgs[1]) ~= nil then
  print('Usage: getlava <distance>')
  print('  Moves forward, looking for lava. Be')
  print('  sure to have empty buckets in the')
  print('  inventory!')
  return
end

local MAX_DISTANCE = tonumber(tArgs[1])
local movesForward = 0
local movesDown = 0
local i


local function hasEmptyBucket()
  for i=1,16 do
    itemData = turtle.getItemDetail(i)
    if itemData ~= nil and itemData['name'] == 'minecraft:bucket' then
      return true
    end
  end
  return false
end

local function refuelIfNeeded()
  if turtle.getFuelLimit() ~= 'unlimited' then
    -- find a lava bucket and refuel with it
    for i=1,16 do
      if turtle.getFuelLevel() + 1000 < turtle.getFuelLimit() then
        itemData = turtle.getItemDetail(i)
        if itemData ~= nil and itemData['name'] == 'minecraft:lava_bucket' then
          print('Using lava to refuel: ', turtle.refuel())
        end
      end
    end
  end
end

local function selectEmptyBucket()
  for i=1,16 do
    itemData = turtle.getItemDetail(i)
    if itemData ~= nil and itemData['name'] == 'minecraft:bucket' then
      turtle.select(i)
      return true
    end
  end
  return false
end



--main program
local moved = false
local gotLava = false

if not hasEmptyBucket() then
  print('I need an empty bucket!')
  return
end

print('Starting...')

-- move forward until you hit the limit
while movesForward < MAX_DISTANCE and hasEmptyBucket() do
  movesDown = 0
  while true do
    -- check if we're over lava
    exists, itemData = turtle.inspectDown()
    if exists and itemData['name'] == 'minecraft:flowing_lava' and selectEmptyBucket() then
      -- found lava, try to pick it up
      gotLava = turtle.placeDown()
      if gotLava then
        print('Got some lava.')
        refuelIfNeeded()
      end
      -- while we're at it, let's try to get lava from around
      -- check for lava in front:
      exists, itemData = turtle.inspect()
      if exists and itemData['name'] == 'minecraft:flowing_lava' and selectEmptyBucket() then
        gotLava = turtle.place()
        if gotLava then
          print('Got some lava.')
          refuelIfNeeded()
        end
      end
      -- check for lava to the left:
      turtle.turnLeft()
      exists, itemData = turtle.inspect()
      if exists and itemData['name'] == 'minecraft:flowing_lava' and selectEmptyBucket() then
        gotLava = turtle.place()
        if gotLava then
          print('Got some lava.')
          refuelIfNeeded()
        end
      end
      turtle.turnRight()
      -- check for lava to the right:
      turtle.turnRight()
      exists, itemData = turtle.inspect()
      if exists and itemData['name'] == 'minecraft:flowing_lava' and selectEmptyBucket() then
        gotLava = turtle.place()
        if gotLava then
          print('Got some lava.')
          refuelIfNeeded()
        end
      end
      turtle.turnLeft()

      moved = turtle.down()
      if moved then
        movesDown = movesDown + 1
      else
        break -- if we can't move down, then move back up
      end
    else
      break -- start going back up
    end
  end
  -- go back up
  for i=1,movesDown do
    moved = turtle.up()
    if not moved then
      for i=1,8 do -- keep trying 8 times to get unstuck
        -- stuck somehow? dig up to get out
        turtle.digUp()
        moved = turtle.up()
        if not moved then
          print('I appear to be stuck under something!')
          sleep(5) -- try again in 5 seconds
        else
          break
        end
      end
      if not moved then
        -- was unable to get unstuck after all those tries
        print('Shutting down... :(')
        return
      end
    end
  end

  -- move forward if needed
  moved = turtle.forward()
  if moved then
    movesForward = movesForward + 1
  else
    break -- if we can't move forward, then head back home
  end

  if not hasEmptyBucket() then
    print('All filled up!')
  end
end


print('Reached distance of ', movesForward)
print('Heading home...')
for i=1,movesForward do
  moved = turtle.back()
  if not moved then
    print('I can\'t move back!')
  end
end

print('Done')

