-- Cobblestone Miner program
-- By Al Sweigart
-- al@inventwithpython.com
-- Stone brick factory robot, 1 of 3

print('Starting mining program...')
while true do
  if turtle.detect() then
    print('Cobblestone detected. Mining...')
    turtle.dig() -- mine cobblestone
  else
    print('No cobblestone. Sleeping...')
    os.sleep(0.5) -- half second pause
  end
end
