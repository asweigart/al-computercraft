-- Banner program
-- By Al Sweigart
-- turtleappstore.com/AlSweigart
-- Displays a scrolling banner on the
-- monitor behind the turtle.

-- handle command line arguments
local cliArgs = {...}
size = tonumber(cliArgs[1])
msg = cliArgs[2]

-- display "usage" info
if msg == nil or cliArgs[1] == '?' then
  print('Usage: <banner> <size> <"message">')
  return
end

-- connect to the monitor
mon = peripheral.wrap('back')
if mon == nil then
  print('ERROR: No monitor behind turtle!')
  return
end

-- check for valid text size
if size < 0.5 or size > 5 then
  print('ERROR: Size must be between 0.5 and 5!')
  return
end
mon.setTextScale(size)

-- get the monitor size
width, height = mon.getSize()
row = math.floor(height / 2)   -- text's row
if row == 0 then
  row = 1
end

print('Hold Ctrl+T to stop.')
print('Scrolling banner...')
mon.clear()

-- make the scrolling text
indent = width
consume = 0
while true do
  if indent > 0 then
    -- add indentation to the start
    display = string.rep(' ', indent) .. msg
    indent = indent - 1
  elseif consume <= string.len(msg) then
    -- remove letters from the start
    display = string.sub(msg, consume)
    consume = consume + 1
  else
    -- reset indent and consume
    indent = width
    consume = 0
  end

  -- display the scrolling text
  mon.setCursorPos(1, row)
  mon.clearLine()
  mon.write(display)
  os.sleep(0.1)
end
