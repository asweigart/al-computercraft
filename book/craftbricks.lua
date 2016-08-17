-- Craft Stone Bricks program
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Stone brick factory robot, 3 of 3

print('Starting brick crafting program...')

counter = 0
while true do
  turtle.select(1)  -- put stone in slot 1
  turtle.suckUp()  -- get stone from furnace
  if turtle.getItemCount() >= 4 then
    -- make stone brick recipe
    turtle.transferTo(2, 1)  -- put in slot 2
    turtle.transferTo(5, 1)  -- put in slot 5
    turtle.transferTo(6, 1)  -- put in slot 6
    turtle.select(16) -- bricks to go in slot 16
    turtle.craft() -- craft stone bricks

    counter = counter + 4
    print('I have made ' .. counter .. ' bricks.')
    turtle.drop() -- put stone brick into chest
  else
    -- wait before checking for stone again
    print('Not enough stone yet. Sleeping...')
    os.sleep(30)
  end
end
