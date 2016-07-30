-- Craft Stone Bricks program
-- By Al Sweigart
-- al@inventwithpython.com
-- Stone brick factory robot, 3 of 3

print('Starting brick crafting program...')
local counter = 0
while true do
  turtle.select(1) -- load stone here
  turtle.suckUp() -- get stone from furnace
  if turtle.getItemCount() >= 4 then
    -- make stone brick recipe
    turtle.transferTo(2, 1)
    turtle.transferTo(5, 1)
    turtle.transferTo(6, 1)
    turtle.select(16) -- craft to slot 16
    turtle.craft() -- craft stone brick

    counter = counter + 4
    print('I have made ' .. counter .. ' bricks.')
    turtle.drop() -- put stone brick into chest
  else
    -- wait before checking for stone again
    print('Not enough stone yet. Sleeping...')
    os.sleep(10)
  end
end
