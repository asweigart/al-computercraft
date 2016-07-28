local tArgs = {...}

pos = tArgs[1]
txtcol = tArgs[2]
bgcol = tArgs[3]

if bgcol == nil then
  print('Usage: setcolor pos textcolor bgcolor')
  print('Color must be one of:')
  print('  white, orange, magenta, lightblue')
  print('  yellow, lime, pink, gray, lightgray')
  print('  cyan, purple, blue, brown, green')
  print('  red, black')
  return
end

local function getColorFromString(cstr)
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
  

mon = peripheral.wrap(pos)
if mon == nil then
  print('No monitor on ' .. pos .. ' side.')
  return
end

mon.setTextColor(getColorFromString(txtcol))
mon.setBackgroundColor(getColorFromString(bgcol))
mon.clear()
