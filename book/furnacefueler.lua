-- Furnace Fueler program
-- By Al Sweigart
-- turtleappstore.com/AlSweigart
-- Stone brick factory robot, 2 of 3

while true do
  -- get fuel from chest
  while turtle.suckDown() do
    print('Grabbed fuel from chest.')
  end

  -- put fuel in furnace
  local slot
  for slot=1,16 do
    turtle.select(slot)
    if turtle.drop() then
      print('Loaded some fuel.')
    end
  end

  -- pause
  print('Sleeping...')
  os.sleep(60)  -- wait 1 minute
end
