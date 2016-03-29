os.loadAPI('hare')

local tArgs = {...}
local amount = tonumber(tArgs[1])
local endProg = false

while true do
  print('Clearing inventory...')
  for i = 1,16 do
    hare.doActions('sel ' .. i .. ' dr 64')
  end

  print('Gathering...')
  for k,v in pairs({1,2,3,5,6,7,9,10,11}) do
    hare.doActions('sel ' .. v .. ' s ' .. amount)
    if turtle.getItemCount() ~= amount then
      print('Slot ' .. v .. ' did not have the expected ' .. amount .. ' items.')
      endProg = true
      break
    end
  end
  if endProg == true then break end

  hare.doActions('sel 16 c 64 drd 64')
  print('Crafted.')
end

print('Clearing inventory...')
for i = 1,16 do
  hare.doActions('sel ' .. i .. ' dr 64')
end
print('Ended.')