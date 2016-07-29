-- Tree Farming program
-- By Al Sweigart
-- al@inventwithpython.com
-- Plants tree then cuts it down.

os.loadAPI('hare')

-- check if choptree program exists
if not fs.exists('choptree') then
  print('ERROR: You need the choptree program')
  print('installed to run this.')
  return
end

local i
while true do
  -- check for saplings
  if hare.selectItem('sapling') == false then
    print('Out of saplings.')
    return
  end

  print('Planting...')
  turtle.place() -- plant sapling

  -- place bonemeal until a tree grows
  while hare.selectItem('dye') do
    print('Using bonemeal...')
    if turtle.place() == false then
      break -- tree has grown
    end
    os.sleep(1) -- 1 second pause
  end

  -- wait until a tree has grown
  while true do
    result, item = turtle.inspect()
    if item ~= nil and item['name'] == 'minecraft:sapling' then
      print('Waiting for sapling to grow...')
      os.sleep(15) -- wait 15 seconds
    else
      break
    end
  end

  hare.selectEmptySlot()
  os.loadAPI('choptree') -- chop tree

  -- pick up any saplings & apples on the ground
  for i = 1, 4 do
    turtle.suck()
    turtle.turnLeft()
  end

  -- move to chest
  turtle.back()
  turtle.turnLeft()
  turtle.turnLeft()
  while hare.selectItem('log') do
    turtle.drop(64)
  end
  while hare.selectItem('apple') do
    turtle.drop(64)
  end
  
  turtle.turnLeft()
  turtle.turnLeft()
end