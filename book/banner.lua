-- Banner program
-- By Al Sweigart
-- al@inventwithpython.com
-- Displays a scrolling banner.

local tArgs = {...}
size = tonumber(tArgs[1])
msg = tArgs[2]
if msg == nil then
  print('Usage: banner size "message"')
  return
end

mon = peripheral.wrap('back')
if mon == nil then
  print('ERROR: No monitor behind turtle!')
  return
end

if size < 0.5 or size > 5 then
  print('ERROR: Size must be between 0.5 and 5!')
  return
end
mon.setTextScale(size)

width, height = mon.getSize()
row = math.floor(height / 2)
if row == 0 then
  row = 1
end

print('Hold Ctrl+T to stop.')
print('Scrolling banner...')
mon.clear()
indent = width
consume = 0
while true do
  if indent > 0 then
    display = string.rep(' ', indent) .. msg
    indent = indent - 1
  elseif consume <= string.len(msg) then
    display = string.sub(msg, consume)
    consume = consume + 1
  else
    indent = width
    consume = 0
  end
  mon.setCursorPos(1, row)
  mon.clearLine()
  mon.write(display)
  os.sleep(0.1)
end
