--[[ Tree Farming program
By Al Sweigart
turtleappstore.com/users/AlSweigart
Plants tree then cuts it down. ]]

os.loadAPI('hare')  -- load the hare library

-- check if choptree program exists
if not fs.exists('choptree') then
  error('You need the choptree program installed to run this program.')
  return
end

while true do
  -- check inventory for saplings
  if not hare.selectItem('sapling') then
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
  shell.run('choptree')  -- run choptree

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
