-- Furnace Fueler program
-- By Al Sweigart
-- al@inventwithpython.com
-- Stone brick factory robot, 2 of 3

local slot

while true do
  -- get fuel from chest
  while turtle.suckDown() do
    print('Grabbed fuel from chest.')
  end

  -- put fuel in furnace
  for slot=1,16 do
    turtle.select(slot)
    if turtle.drop() then
      print('Loaded some fuel.')
    end
  end

  -- pause
  print('Sleeping...')
  os.sleep(60)
end
