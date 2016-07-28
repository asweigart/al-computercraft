-- assumes saplings in slots 1-4, bonemeal in slots 5-8, wood in 9-16


local function selectSapling()
  turtle.select(1)
  if turtle.getItemCount() ~= 0 then
    return true
  end
  turtle.select(2)
  if turtle.getItemCount() ~= 0 then
    return true
  end
  turtle.select(3)
  if turtle.getItemCount() ~= 0 then
    return true
  end
  turtle.select(4)
  if turtle.getItemCount() ~= 0 then
    return true
  end
  return false
end

local function selectBonemeal()
  local i
  for i = 5, 15 do
    turtle.select(i)
    if turtle.getItemCount() ~= 0 then
      return true
    end
  end
  return false
end


local i
while true do
  if selectSapling() == false then
    print('Out of saplings.')
  end

  turtle.place() -- plant sapling

  -- place bonemeal until a tree grows
  while true do
    if selectBonemeal() == false then
      print('Out of bonemeal.')
    end

    if turtle.place() == false then
      break -- tree has grown
    end
  end

  -- wait until a tree has grown
  while true do
    success, itemData = turtle.inspect()
    if itemData ~= nil and itemData['name'] == 'minecraft:sapling' then
      print('Waiting for sapling to grow...')
      os.sleep(5)
    else
      break
    end
  end

  turtle.select(16)
  turtle.dig()
  turtle.forward()
  while turtle.compareUp() do
    turtle.digUp()
    turtle.up()
  end
  -- move back down
  while not turtle.detectDown() do
    turtle.down()
  end

  -- pick up any saplings & apples on the ground
  turtle.select(14)
  for i = 1, 4 do
    turtle.suck()
    turtle.turnLeft()
  end

  -- move to chest
  turtle.back()
  turtle.turnLeft()
  turtle.turnLeft()
  for i = 14, 16 do
    turtle.select(i)
    turtle.drop()
  end
  turtle.turnLeft()
  turtle.turnLeft()
end