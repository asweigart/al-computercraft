-- Stair Builder program
-- By Al Sweigart
-- turtleappstore.com/AlSweigart
-- Builds stairs. Use with stair miner.

os.loadAPI('hare')

print('Building stairs...')
while turtle.detect() do
  if not turtle.up() then
    print('Hit ceiling. Stopping.')
  end

  if not hare.selectItem('stairs') then
    print('Need more stairs. Stopping.')
    return
  end
  
  turtle.placeDown()
  
  if not turtle.forward() then
    print('Hit wall. Stopping.')
    return
  end
end

print('Reached end of incline. Stopping.')
