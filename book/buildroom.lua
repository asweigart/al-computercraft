--[[ Wall Building program
By Al Sweigart
turtleappstore.com/users/AlSweigart
Builds a room of four walls and a
ceiling out of blocks in the turtle's
inventory. ]]

os.loadAPI('hare')

-- handle command line arguments
cliArgs = {...}
length = tonumber(cliArgs[1])
width = tonumber(cliArgs[2])
height = tonumber(cliArgs[3])

if height == nil or cliArgs[1] == '?' then
  print('Usage: buildwallroom <length> <width> <height>')
  return
end

hare.buildRoom(length, width, height)
