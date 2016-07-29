-- Furnace Fueler program
-- By Al Sweigart
-- al@inventwithpython.com
-- Stone brick factory robot, 2 of 3

while true do
  if turtle.suckDown() then
    print('No fuel in the chest.')
  else
    if turtle.drop() then
      print('Furnace already full.')
    else
      print('Loaded some fuel.')
    end
  end
  print('Sleeping...')
  os.sleep(60)
end
