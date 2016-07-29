-- Cobblestone Miner program
-- By Al Sweigart
-- al@inventwithpython.com
-- Stone brick factory robot, 1 of 3

os.loadAPI('hare')

print('Starting mining program...')
while true do
  if turtle.detect() then
    print('Cobblestone detected. Mining...')
    turtle.dig() -- mine cobblestone
  else
    print('No cobblestone. Sleeping...')
    os.sleep(0.5) -- half second pause
  end

  hare.selectItem('cobblestone')
  if turtle.getItemCount() == 64 then
  	-- check for turtle's fuel
  	if turtle.getFuelLevel() < 2 then
  		print('Turtle is out of fuel!')
  		return
  	end

  	turtle.back() -- move over furnace
  	if not turtle.dropDown() then
  		print('Furnace is full. Sleeping...')
  		turtle.forward()
  		os.sleep(300)
  	else
  		print('Dropped off cobblestone.')
  		turtle.forward()
  	end
  	
  end
end
