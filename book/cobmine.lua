--[[ Cobblestone Miner program
By Al Sweigart
https://turtleappstore.com/users/AlSweigart
Stone brick factory robot, 1 of 3 ]]

os.loadAPI('hare')  -- load the hare library

print('Starting mining program...')
while true do
  -- mine cobblestone
  if turtle.detect() then
    print('Cobblestone detected. Mining...')
    turtle.dig()  -- mine cobblestone
  else
    print('No cobblestone. Sleeping...')
    os.sleep(0.5)  -- half second pause
  end

  -- check for a full stack of cobble
  hare.selectItem('cobblestone')
  if turtle.getItemCount() == 64 then
  	-- check turtle's fuel
  	if turtle.getFuelLevel() < 2 then
  		print('Turtle needs more fuel!')
  		return
  	end

    -- put cobble in furnace
  	turtle.back()  -- move over furnace
  	if not turtle.dropDown() then
  		print('Furnace is full. Sleeping...')
  		turtle.forward()
  		os.sleep(300)  -- wait 5 minutes
  	else
  		print('Dropped off cobblestone.')
  		turtle.forward()  -- move to cobble
  	end  	
  end
end
