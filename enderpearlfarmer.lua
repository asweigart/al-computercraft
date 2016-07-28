os.loadAPI('hare')
hare.goto(765,61,-664)
hare.faceNorth()

local tArgs = {...}
if tonumber(tArgs[1]) == nil then tArgs[1] = 8 end
if tonumber(tArgs[2]) == nil then tArgs[2] = 8 end


local FORWARD_LEN = tonumber(tArgs[1])
local RIGHT_LEN = tonumber(tArgs[2])
local i
local pearlCount = 0

local movements = hare.split(hare.getAreaCoverActions(FORWARD_LEN, RIGHT_LEN, true))

while true do
  for i=1,#movements do
    hare.doActions(movements[i], true)

    local exists, block = turtle.inspectDown()
    if exists and (string.find(block['name'], 'chest') or string.find(block['name'], 'barrel')) then
      -- drop off inventory into chest
      print('Dropping off inventory into chest...')
      for i=1,16 do
        turtle.select(i)
        itemData = turtle.getItemDetail()
        if itemData ~= nil and itemData['name'] == 'minecraft:ender_pearl' then
          pearlCount = pearlCount + turtle.getItemCount()
          turtle.dropDown(64) -- deposit into chest
        end
      end
      print('  ', pearlCount, ' pearls deposited.')
      pearlCount = 0
    elseif not exists then
      -- nothing is under the turtle, so try to plant lilly
      hare.selectItem('ExtraUtilities:plant/ender_lilly')
      turtle.placeDown()
    elseif block['name'] == 'ExtraUtilities:plant/ender_lilly' and block['metadata'] == 7 then
      -- ender pearl (and fully mature) is below, so harvest it
      turtle.digDown()
      turtle.suckDown() -- pick up any ender pearls
      hare.selectItem('ExtraUtilities:plant/ender_lilly')
      turtle.placeDown()
    end
  end
  os.sleep(15*60)
end