-- Tree Farming program
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
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

  -- TODO: add bonemeal code here

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

  -- drop logs into chest
  turtle.back()
  turtle.turnLeft()
  turtle.turnLeft()
  while hare.selectItem('log') do
    turtle.drop(64)
  end
  turtle.turnLeft()
  turtle.turnLeft()
end