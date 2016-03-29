os.loadAPI('hare')
local tArgs  = {...}

if tArgs[1] == nil then F_LEN = 33 else F_LEN = tonumber(tArgs[1]) end
if tArgs[2] == nil then R_LEN = 33 else R_LEN = tonumber(tArgs[2]) end

local movements = hare.split(hare.getAreaCoverActions(F_LEN, R_LEN, true))

for i=1,#movements do
  hare.selectItem('multibrickfancy')
  turtle.placeDown()
  hare.doActions(movements[i], true)
end