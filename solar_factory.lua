os.loadAPI('hare')

STORAGE = {800, 78, -638, 'east'}

GLASS = {800, 80, -638, 'south'}
IRON = {800, 79, -638, 'south'}
MIRROR = {800, 78, -638, 'south'}
REDSTONE = {800, 77, -638, 'south'}

PLANK = {799, 80, -638, 'south'}
SOLAR_PANEL_I = {799, 79, -638, 'south'}
GOLD = {799, 78, -638, 'south'}
RECEPTION_COIL = {799, 77, -638, 'south'}

SOLAR_PANEL_II = {798, 80, -638, 'south'}
TIN = {798, 79, -638, 'south'}
TIN_GEAR = {798, 78, -638, 'south'}
MACHINE_FRAME_BASIC = {798, 77, -638, 'south'}

LEAD = {797, 80, -638, 'south'}
REDSTONE_BLOCK = {797, 79, -638, 'south'}
LEADSTONE_ENERGY_CELL = {797, 78, -638, 'south'}
PV_CELL_I = {797, 77, -638, 'south'}

SOLAR_PANEL_III = {796, 80, -638, 'south'}
ELECTRUM = {796, 79-638, 'south'}
ELECTRUM_GEAR = {796, 78-638, 'south'}
INVAR = {796, 77-638, 'south'}

MACHINE_FRAME_HARDENED = {795, 80, -638, 'south'}
HARDENED_ENERGY_CELL = {795, 79, -638, 'south'}
PV_CELL_II = {795, 78, -638, 'south'}
SOLAR_PANEL_IV = {795, 77, -638, 'south'}

SIGNALUM = {794, 80, -638, 'south'}
SIGNALUM_GEAR = {794, 79, -638, 'south'}
HARDENED_GLASS = {794, 78, -638, 'south'}
MACHINE_FRAME_REINFORCED = {794, 77, -638, 'south'}


function dumpAll()
  local i
  print('Dumping inventory...')
  hare.goto(STORAGE)
  for i=1,16 do
    turtle.select(i)
    turtle.drop(64)
  end
end


function checkInvNumbers(nums)
  local i
  for i=1,16 do
    if turtle.getItemCount(i) ~= nums[i] then
      print('Not enough materials.')
      dumpAll()
      return false
    end
  end
  return true
end

function craftMirror()
  print('Crafting mirror...')
  hare.goto(GLASS)
  hare.doActions('sel 1 s 32 sel 2 s 32 sel 3 s 32')
  hare.goto(IRON)
  hare.doActions('sel 6 s 32')

  if not checkInvNumbers({32, 32, 32, 0, 0, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}) then return false end

  hare.doActions('sel 16 c 64')
  hare.goto(MIRROR)
  hare.doActions('dr 64')
  print('Mirrors crafted.')
  return true
end


function craftSolarPanelI()
  print('Crafting solar panel I...')
  hare.goto(MIRROR)
  hare.doActions('sel 1 s 64 sel 2 s 64 sel 3 s 64')
  hare.goto(PLANK)
  hare.doActions('sel 5 s 64 sel 9 s 64 sel 10 s 64 sel 11 s 64 sel 7 s 64')
  hare.goto(REDSTONE)
  hare.doActions('sel 6 s 64')

  if not checkInvNumbers({64, 64, 64, 0, 64, 64, 64, 0, 64, 64, 64, 0, 0, 0, 0, 0}) then return false end

  hare.doActions('sel 16 c 64')
  hare.goto(SOLAR_PANEL_I)
  hare.doActions('dr 64')
  print('Solar panel I crafted.')
  return true
end


function craftReceptionCoil(num)
  print('Crafting reception coil...')
  hare.goto(REDSTONE)
  hare.doActions('sel 3 s ' .. num .. ' sel 9 s ' .. num)
  hare.goto(GOLD)
  hare.doActions('sel 6 s ' .. num)

  if not checkInvNumbers({0, 0, num, 0, 0, num, 0, 0, num, 0, 0, 0, 0, 0, 0, 0}) then return false end

  hare.doActions('sel 16 c ' .. num)
  hare.goto(RECEPTION_COIL)
  hare.doActions('dr ' .. num)
  print('Reception coil (' .. num .. 'x) crafted.')
  return true
end


function craftSolarPanelII(num)
  print('Crafting solar panel II...')
  hare.goto(SOLAR_PANEL_I)
  hare.doActions('sel 1 s ' .. num .. ' sel 2 s ' .. num .. ' sel 3 s ' .. num)
  hare.doActions('sel 5 s ' .. num .. ' sel 7 s ' .. num)
  hare.doActions('sel 9 s ' .. num .. ' sel 10 s ' .. num .. ' sel 11 s ' .. num)
  hare.goto(RECEPTION_COIL)
  hare.doActions('sel 6 s ' .. num)

  if not checkInvNumbers({num, num, num, 0, num, num, num, 0, num, num, num, 0, 0, 0, 0, 0}) then return false end

  hare.doActions('sel 16 c ' .. num)
  hare.goto(SOLAR_PANEL_II)
  hare.doActions('dr ' .. num)
  print('Solar panel II (' .. num .. 'x) crafted.')
  return true
end


function craftTinGear(num)
  print('Crafting tin gear...')
  hare.goto(TIN)
  hare.doActions('sel 6 s ' .. num)
  hare.goto(IRON)
  hare.doActions('sel 2 s ' .. num .. ' sel 5 s ' .. num .. ' sel 7 s ' .. num .. ' sel 10 s ' .. num)

  if not checkInvNumbers({0, num, 0, 0, num, num, num, 0, 0, num, 0, 0, 0, 0, 0, 0}) then return false end

  hare.doActions('sel 16 c ' .. num)
  hare.goto(TIN_GEAR)
  hare.doActions('dr ' .. num)
  print('Tin gear (' .. num .. 'x) crafted.')
  return true
end


function craftLeadstoneEnergyFrame(num)
  print('Crafting leadstone energy frame...')
  hare.goto(LEAD)
  hare.doActions('sel 1 s ' .. num .. 'sel 3 s ' .. num .. 'sel 9 s ' .. num .. 'sel 11 s ' .. num)
  hare.goto(GLASS)
  hare.doActions('sel 2 s ' .. num .. 'sel 5 s ' .. num .. 'sel 7 s ' .. num .. 'sel 10 s ' .. num)
  hare.goto(REDSTONE_BLOCK)
  hare.doActions('sel 5 s ' .. num)

  if not checkInvNumbers({num, num, num, 0, num, num, num, 0, num, num, num, 0, 0, 0, 0, 0}) then return false end

  hare.doActions('sel 16 c ' .. num)
  hare.goto(LEADSTONE_ENERGY_CELL)
  hare.doActions('dr ' .. num)
  print('Leadstone energy frame (' .. num .. 'x) crafted.')
  return true
end





dumpAll()
while true do
  craftMirror()
  craftSolarPanelI()
  craftReceptionCoil(64)
  craftSolarPanelII(8)
  craftTinGear(64)
  print('Sleeping...')
  os.sleep(10)
end

