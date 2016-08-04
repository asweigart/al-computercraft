-- 3D Printer program
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Prints out 

print('Printing...')

while true do
  print('Collecting...')
  for k, v in pairs({1,2,3,5,6,7,9,10,11}) do
    turtle.select(v)
    turtle.suck()
  end

  -- face the output barrel
  turtle.turnLeft()
  turtle.turnLeft()

  while true do
    turtle.select(16)
    turtle.craft(64)
    print('Crafted.')
    itemData = turtle.getItemDetail(16)
    if itemData == nil then break end
    turtle.drop()
    print('Deposited.')
  end

  -- face the resource barrel
  turtle.turnLeft()
  turtle.turnLeft()

  -- handle any leftover resources
  for k, v in pairs({1,2,3,5,6,7,9,10,11}) do
    turtle.select(v)
    turtle.drop() -- put it back into the resource barrel
  end


  print('Sleeping...')
  os.sleep(60)
end
