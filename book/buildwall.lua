--[[ Wall Building program
By Al Sweigart
turtleappstore.com/users/AlSweigart
Builds a wall out of blocks in the
turtle's inventory. ]]

os.loadAPI('hare')

-- handle command line arguments
cliArgs = {...}
length = tonumber(cliArgs[1])
height = tonumber(cliArgs[2])

if height == nil or cliArgs[1] == '?' then
  print('Usage: buildwall <length> <height>')
  return
end

hare.buildWall(length, height)