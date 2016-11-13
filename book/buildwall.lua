--[[ Wall Building program
By Al Sweigart
https://turtleappstore.com/users/AlSweigart
Builds a wall out of blocks in the
turtle's inventory. ]]

os.loadAPI('hare')

-- handle command line arguments
local cliArgs = {...}
local length = tonumber(cliArgs[1])
local height = tonumber(cliArgs[2])

if height == nil or cliArgs[1] == '?' then
  print('Usage: buildwall <length> <height>')
  return
end

hare.buildWall(length, height)