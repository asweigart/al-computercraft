-- Tree Farming program
-- By Al Sweigart
-- turtleappstore.com/AlSweigart
-- Plants tree then cuts it down.

os.loadAPI('hare')  -- load the hare library

-- check if choptree program exists
if not fs.exists('choptree') then
  print('ERROR: You need the choptree program')
  print('installed to run this program.')
  return
end

local i
while true do
  -- check inventory for saplings
  if hare.selectItem('sapling') == false then
    print('Out of saplings.')
    return
  end

  print('Planting...')
  turtle.place() -- plant sapling

  -- TODO: add bonemeal code here

  -- wait until a tree has grown
  while true do
    result, item = turtle.inspect()
    if item ~= nil and item['name'] == 'minecraft:sapling' then
      print('Waiting for sapling to grow...')
      os.sleep(15)
    else
      break  -- tree has grown
    end
  end

  hare.selectEmptySlot()
  os.loadAPI('choptree')  -- run choptree

  -- move to and face chest
  turtle.back()
  turtle.turnLeft()
  turtle.turnLeft()

  -- put logs into chest
  while hare.selectItem('log') do
    turtle.drop()
  end

  -- face planting spot
  turtle.turnLeft()
  turtle.turnLeft()
end
