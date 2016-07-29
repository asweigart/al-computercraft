local tArgs = {...}

pos = tArgs[1]
size = tonumber(tArgs[2])
delay = tonumber(tArgs[3])
msg = tArgs[4]
if msg == nil then
  print('Usage: banner pos size delay "Msg"')
  return
end

mon = peripheral.wrap(pos)
if mon == nil then
  print('No monitor on ' .. pos .. ' side.')
  return
end

if size < 0.5 or size > 5 then
  print('Text size must be between 0.5 and 5.')
  return
end
mon.setTextScale(size)

if delay < 0 or delay > 2 then
  print('Delay must be between 0 and 2.')
  return
end

width, height = mon.getSize()
row = math.floor(height / 2)
if row == 0 then
  row = 1
end

print('Hold Ctrl+T to stop.')
print('Running banner...')
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
  os.sleep(delay)
end
