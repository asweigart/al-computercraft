--[[ Wall Building program
By Al Sweigart
turtleappstore.com/users/AlSweigart
Builds a floor out of blocks in the
turtle's inventory. ]]

os.loadAPI('hare')

-- handle command line arguments
cliArgs = {...}
length = tonumber(cliArgs[1])
width = tonumber(cliArgs[2])

if width == nil or cliArgs[1] == '?' then
  print('Usage: buildwall <length> <width>')
  return
end

hare.buildRectangleFloor(length, width)