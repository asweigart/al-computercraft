-- Set Color program
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Sets the color on the monitor 
-- behind the turtle.

-- handle command line arguments
local cliArgs = {...}
local txtcol = cliArgs[1]
local bgcol = cliArgs[2]

-- display "usage" info
if bgcol == nil or cliArgs[1] == '?' then
  print('Usage: setcolor textcolor bgcolor')
  print('Colors must be one of:')
  print('  white, orange, magenta, lightblue')
  print('  yellow, lime, pink, gray, lightgray')
  print('  cyan, purple, blue, brown, green')
  print('  red, black')
  return
end

local function getColorFromString(cstr)
  -- return color value based on cstr
  cstr = string.lower(cstr)
  if cstr == 'white' then return colors.white end
  if cstr == 'orange' then return colors.orange end
  if cstr == 'magenta' then return colors.magenta end
  if cstr == 'lightblue' then return colors.lightBlue end
  if cstr == 'yellow' then return colors.yellow end
  if cstr == 'lime' then return colors.lime end
  if cstr == 'pink' then return colors.pink end
  if cstr == 'gray' then return colors.gray end
  if cstr == 'lightgray' then return colors.lightGray end
  if cstr == 'cyan' then return colors.cyan end
  if cstr == 'purple' then return colors.purple end
  if cstr == 'blue' then return colors.blue end
  if cstr == 'brown' then return colors.brown end
  if cstr == 'green' then return colors.green end
  if cstr == 'red' then return colors.red end
  if cstr == 'black' then return colors.black end
  return nil
end  

-- connect to the monitor  
mon = peripheral.wrap('back')
if mon == nil then
  print('ERROR: No monitor behind turtle!')
  return
end

-- set text color
local col = getColorFromString(txtcol)
if col ~= nil then
  mon.setTextColor(col)
end

-- set background color
col = getColorFromString(bgcol)
if col ~= nil then
  mon.setBackgroundColor(col)
end
