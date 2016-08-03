-- Cake Smash program
-- By Al Sweigart
-- turtleappstore.com/AlSweigart
-- Uses a piston to smash a cake!

-- do a count down
local countdown = 5
while countdown > 0 do
  print(countdown)
  os.sleep(1)
  countdown = countdown - 1
end

-- engage the piston
redstone.setOutput('front', true)
os.sleep(0.5)

-- disengage the piston
redstone.setOutput('front', false)