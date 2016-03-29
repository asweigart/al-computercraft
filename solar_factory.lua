--5
os.loadAPI('hare')

DEBUG_SOLAR = true

STORAGE = {800, 78, -638, 'east'}

WOOD = {800, 81, -638, 'south'}

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

PV_CELL_III = {793, 80, -638, 'south'}
EMPTY_REDSTONE_ENERGY_CELL = {793, 79, -638, 'south'}
REDSTONE_ENERGY_CELL = {793, 78, -638, 'south'}
SOLAR_PANEL_V = {793, 77, -638, 'south'}

PV_CELL_IV = {792, 80, -638, 'south'}
DIAMOND = {792, 79, -638, 'south'}
ENDERIUM = {792, 78, -638, 'south'}
RESONANT_ENERGY_CELL_FRAME = {792, 77, -638, 'south'}

MACHINE_FRAME_RESONANT = {791, 80, -638, 'south'}
ENDERIUM_GEAR =  {791, 79, -638, 'south'}

function dumpAll()
  local i
  print('Dumping inventory...')
  hare.goto(STORAGE)
  for i=1,16 do
    turtle.select(i)
    turtle.drop(64)
  end
end


function grab(location, num, slots)
  if type(slots) == 'number' then slots = {slots} end
  success, errMsg = hare.goto(location)
  if not success then return false, errMsg end
  --print('arrived at barrel')

  for k,v in pairs(slots) do
    --print('sel ' .. tostring(v) .. ' s ' .. num)
    hare.doActionsSafely('sel ' .. v .. ' s ' .. num)
    if turtle.getItemCount(v) ~= num then return false end
  end
  return true
end


function inventoryIsEmpty()
  for i=1,16 do
    if turtle.getItemCount(i) ~= 0 then return false end
  end
  return true
end

function craftAndDrop(location, num)
  success, errMsg = hare.doActionsSafely('sel 16 c ' .. num)
  if not success then return false, errMsg end

  success, errMsg = hare.goto(location)
  if not success then return false, errMsg end

  if not hare.doActionsSafely('dr ' .. num) then return false, errMsg end
  if not inventoryIsEmpty() then
    dumpAll()
    return false, 'Crafting failed, inventory not empty'
  end
  return true
end


function craftPlank(num)
  print('Crafting planks...')
  if num % 4 ~= 0 then return false, 'Num for craftPlank() must multiple of 4' end
  if not inventoryIsEmpty() then dumpAll() end

  if not grab(WOOD, num / 4, {1}) then return false, 'Could not grab WOOD' end

  success, errMsg = craftAndDrop(PLANK, num)
  if not success then return false, errMsg end
  print('Planks (' .. num .. 'x) crafted.')
  return true
end


function craftRedstoneBlock(num)
  print('Crafting redstone block...')
  if not inventoryIsEmpty() then dumpAll() end

  if not grab(REDSTONE, num, {1,2,3,5,6,7,9,10,11}) then return false, 'Could not grab REDSTONE' end

  success, errMsg = craftAndDrop(REDSTONE_BLOCK, num)
  if not success then return false, errMsg end
  print('Redstone blocks (' .. num .. 'x) crafted.')
  return true
end


function craftMirror(num)
  print('Crafting mirror...')
  if not inventoryIsEmpty() then dumpAll() end
  if num % 2 ~= 0 then return false, 'Num for craftMirror() must be even' end

  if not grab(GLASS, num / 2, {1,2,3}) then return false, 'Could not grab GLASS' end
  if not grab(IRON, num / 2, {6}) then return false, 'Could not grab IRON' end

  success, errMsg = craftAndDrop(MIRROR, num)
  if not success then return false, errMsg end
  print('Mirrors (' .. num .. 'x) crafted.')
  return true
end


function craftSolarPanelI(num)
  print('Crafting solar panel I...')
  if not inventoryIsEmpty() then dumpAll() end
  if not grab(MIRROR, num, {1,2,3}) then return false, 'Could not grab MIRROR' end
  if not grab(PLANK, num, {5,9,10,11,7}) then return false, 'Could not grab PLANK' end
  if not grab(REDSTONE, num, {6}) then return false, 'Could not grab REDSTONE' end

  success, errMsg = craftAndDrop(SOLAR_PANEL_I, num)
  if not success then return false, errMsg end
  print('Solar panel I (' .. num .. 'x) crafted.')
  return true
end


function craftReceptionCoil(num)
  print('Crafting reception coil...')
  if not inventoryIsEmpty() then dumpAll() end
  if not grab(REDSTONE, num, {3,9}) then return false, 'Could not grab REDSTONE' end
  if not grab(GOLD, num, {6}) then return false, 'Could not grab GOLD' end

  success, errMsg = craftAndDrop(RECEPTION_COIL, num)
  if not success then return false, errMsg end
  print('Reception coil (' .. num .. 'x) crafted.')
  return true
end


function craftSolarPanelII(num)
  print('Crafting solar panel II...')
  if not inventoryIsEmpty() then dumpAll() end
  if not grab(SOLAR_PANEL_I, num, {1,2,3,5,7,9,10,11}) then return false, 'Could not grab SOLAR_PANEL_I' end
  if not grab(RECEPTION_COIL, num, {6}) then return false, 'Could not grab RECEPTION_COIL' end

  success, errMsg = craftAndDrop(SOLAR_PANEL_II, num)
  if not success then return false, errMsg end
  print('Solar panel II (' .. num .. 'x) crafted.')
  return true
end


function craftTinGear(num)
  print('Crafting tin gear...')
  if not inventoryIsEmpty() then dumpAll() end
  if not grab(IRON, num, 6) then return false, 'Could not grab IRON' end
  if not grab(TIN, num, {2, 5, 7, 10}) then return false, 'Could not grab TIN' end

  success, errMsg = craftAndDrop(TIN_GEAR, num)
  if not success then return false, errMsg end
  print('Tin gear (' .. num .. 'x) crafted.')
  return true
end


function craftLeadstoneEnergyFrame(num)
  print('Crafting leadstone energy frame...')
  if not inventoryIsEmpty() then dumpAll() end
  if not grab(LEAD, num, {1,3,9,11}) then return false, 'Could not grab LEAD' end
  if not grab(GLASS, num, {2,5,7,10}) then return false, 'Could not grab GLASS' end
  if not grab(REDSTONE_BLOCK, num, {5}) then return false, 'Could not grab REDSTONE_BLOCK' end

  success, errMsg = craftAndDrop(LEADSTONE_ENERGY_CELL, num)
  if not success then return false, errMsg end
  print('Leadstone energy frame (' .. num .. 'x) crafted.')
  return true
end


function craftMachineFrameBasic(num)
  print('Crafting machine frame basic...')
  if not inventoryIsEmpty() then dumpAll() end
  if not grab(IRON, num, {1,3,9,11}) then return false, 'Could not grab IRON' end
  if not grab(GLASS, num, {2,5,7,10}) then return false, 'Could not grab GLASS' end
  if not grab(TIN_GEAR, num, {5}) then return false, 'Could not grab TIN_GEAR' end

  success, errMsg = craftAndDrop(MACHINE_FRAME_BASIC, num)
  if not success then return false, errMsg end
  print('Machine frame basic (' .. num .. 'x) crafted.')
  return true
end


function craftSolarPanelIII(num)
  print('Crafting solar panel III...')
  if not inventoryIsEmpty() then dumpAll() end
  if not grab(PV_CELL_I, num, {1,2,3}) then return false, 'Could not grab PV_CELL_I' end
  if not grab(SOLAR_PANEL_II, num, {5,7,9,11}) then return false, 'Could not grab SOLAR_PANEL_II' end
  if not grab(MACHINE_FRAME_BASIC, num, {6}) then return false, 'Could not grab MACHINE_FRAME_BASIC' end
  if not grab(LEADSTONE_ENERGY_CELL, num, {10}) then return false, 'Could not grab LEADSTONE_ENERGY_CELL' end

  success, errMsg = craftAndDrop(SOLAR_PANEL_III, num)
  if not success then return false, errMsg end
  print('Solar panel III (' .. num .. 'x) crafted.')
  return true
end

function craftElectrumGear(num)
  print('Crafting electrum gear...')
  if not inventoryIsEmpty() then dumpAll() end

  if not grab(IRON, num, {6}) then return false, 'Could not grab IRON' end
  if not grab(ELECTRUM, num, {2,5,7,10}) then return false, 'Could not grab ELECTRUM' end

  success, errMsg = craftAndDrop(ELECTRUM_GEAR, num)
  if not success then return false, errMsg end
  print('Electrum gear (' .. num .. 'x) crafted.')
  return true
end

function craftMachineFrameHardened(num)
  print('Crafting m. fr. hardened...')
  if not inventoryIsEmpty() then dumpAll() end

  if not grab(INVAR, num, {1,3,9,11}) then return false, 'Could not grab INVAR' end
  if not grab(ELECTRUM_GEAR, num, {2}) then return false, 'Could not grab ELECTRUM_GEAR' end
  if not grab(MACHINE_FRAME_BASIC, num, {6}) then return false, 'Could not grab MACHINE_FRAME_BASIC' end

  success, errMsg = craftAndDrop(MACHINE_FRAME_HARDENED, num)
  if not success then return false, errMsg end
  print('M. Fr. Hardened (' .. num .. 'x) crafted.')
  return true
end

function craftHardenedEnergyCellFrame(num)
  print('Crafting hardened en cell fr...')
  if not inventoryIsEmpty() then dumpAll() end

  if not grab(LEADSTONE_ENERGY_CELL, num, {6}) then return false, 'Could not grab LEADSTONE_ENERGY_CELL' end
  if not grab(INVAR, num, {2,5,7,10}) then return false, 'Could not grab INVAR' end

  success, errMsg = craftAndDrop(HARDENED_ENERGY_CELL, num)
  if not success then return false, errMsg end
  print('hardened en cell fr (' .. num .. 'x) crafted.')
  return true
end

function craftSolarPanelIV(num)
  print('Crafting SP IV...')
  if not inventoryIsEmpty() then dumpAll() end

  if not grab(PV_CELL_II, num, {1,2,3}) then return false, 'Could not grab PV_CELL_II' end
  if not grab(SOLAR_PANEL_III, num, {5,7,9,11}) then return false, 'Could not grab SOLAR_PANEL_III' end
  if not grab(MACHINE_FRAME_HARDENED, num, {6}) then return false, 'Could not grab MACHINE_FRAME_HARDENED' end
  if not grab(HARDENED_ENERGY_CELL, num, {10}) then return false, 'Could not grab HARDENED_ENERGY_CELL' end

  success, errMsg = craftAndDrop(SOLAR_PANEL_IV, num)
  if not success then return false, errMsg end
  print('SP IV (' .. num .. 'x) crafted.')
  return true
end

function craftSignalumGear(num)
  print('Crafting signalum gear...')
  if not inventoryIsEmpty() then dumpAll() end

  if not grab(IRON, num, {6}) then return false, 'Could not grab IRON' end
  if not grab(SIGNALUM, num, {2,5,7,10}) then return false, 'Could not grab SIGNALUM' end

  success, errMsg = craftAndDrop(SIGNALUM_GEAR, num)
  if not success then return false, errMsg end
  print('signalum gear (' .. num .. 'x) crafted.')
  return true
end


function craftMachineFrameReinforced(num)
  print('Crafting m. fr. reinfor...')
  if not inventoryIsEmpty() then dumpAll() end

  if not grab(HARDENED_GLASS, num, {1,3,9,11}) then return false, 'Could not grab HARDENED_GLASS' end
  if not grab(SIGNALUM_GEAR, num, {2}) then return false, 'Could not grab SIGNALUM_GEAR' end
  if not grab(MACHINE_FRAME_HARDENED, num, {6}) then return false, 'Could not grab MACHINE_FRAME_HARDENED' end

  success, errMsg = craftAndDrop(MACHINE_FRAME_REINFORCED, num)
  if not success then return false, errMsg end
  print('M. Fr. reinfo (' .. num .. 'x) crafted.')
  return true
end

function craftRedstoneEnergyCellFrame(num)
  print('Crafting red en cell fr...')
  if not inventoryIsEmpty() then dumpAll() end

  if not grab(ELECTRUM, num, {1,3,9,11}) then return false, 'Could not grab ELECTRUM' end
  if not grab(HARDENED_GLASS, num, {2,5,7,10}) then return false, 'Could not grab HARDENED_GLASS' end
  if not grab(DIAMOND, num, {6}) then return false, 'Could not grab DIAMOND' end

  success, errMsg = craftAndDrop(MACHINE_FRAME_REINFORCED, num)
  if not success then return false, errMsg end
  print('red en cell fr (' .. num .. 'x) crafted.')
  return true
end

function craftSolarPanelV(num)
  print('Crafting SP V...')
  if not inventoryIsEmpty() then dumpAll() end

  if not grab(PV_CELL_III, num, {1,2,3}) then return false, 'Could not grab PV_CELL_III' end
  if not grab(SOLAR_PANEL_IV, num, {5,7,9,11}) then return false, 'Could not grab SOLAR_PANEL_IV' end
  if not grab(MACHINE_FRAME_REINFORCED, num, {6}) then return false, 'Could not grab MACHINE_FRAME_REINFORCED' end
  if not grab(REDSTONE_ENERGY_CELL, num, {10}) then return false, 'Could not grab REDSTONE_ENERGY_CELL' end

  success, errMsg = craftAndDrop(SOLAR_PANEL_V, num)
  if not success then return false, errMsg end
  print('SP V (' .. num .. 'x) crafted.')
  return true
end

function craftEnderiumGear(num)
  print('Crafting enderium gear...')
  if not inventoryIsEmpty() then dumpAll() end

  if not grab(IRON, num, {6}) then return false, 'Could not grab IRON' end
  if not grab(ENDERIUM, num, {2,5,7,10}) then return false, 'Could not grab ENDERIUM' end

  success, errMsg = craftAndDrop(ENDERIUM_GEAR, num)
  if not success then return false, errMsg end
  print('enderium gear (' .. num .. 'x) crafted.')
  return true
end

function craftResonantEnergyCellFrame(num)
  print('Crafting res en cell fr gear...')
  if not inventoryIsEmpty() then dumpAll() end

  if not grab(REDSTONE_ENERGY_CELL, num, {6}) then return false, 'Could not grab REDSTONE_ENERGY_CELL' end
  if not grab(ENDERIUM, num, {2,5,7,10}) then return false, 'Could not grab ENDERIUM' end

  success, errMsg = craftAndDrop(RESONANT_ENERGY_CELL_FRAME, num)
  if not success then return false, errMsg end
  print('res en cell fr (' .. num .. 'x) crafted.')
  return true
end

function craftMachineFrameResonant(num)
  print('Crafting m. fr. res...')
  if not inventoryIsEmpty() then dumpAll() end

  if not grab(HARDENED_GLASS, num, {1,3,9,11}) then return false, 'Could not grab HARDENED_GLASS' end
  if not grab(ENDERIUM_GEAR, num, {2}) then return false, 'Could not grab SIGNALUM_GEAR' end
  if not grab(MACHINE_FRAME_HARDENED, num, {6}) then return false, 'Could not grab MACHINE_FRAME_HARDENED' end

  success, errMsg = craftAndDrop(MACHINE_FRAME_RESONANT, num)
  if not success then return false, errMsg end
  print('M. Fr. res (' .. num .. 'x) crafted.')
  return true
end

function craftSolarPanelVI(num)
  print('Crafting SP VI...')
  if not inventoryIsEmpty() then dumpAll() end

  if not grab(PV_CELL_IV, num, {1,2,3}) then return false, 'Could not grab PV_CELL_IV' end
  if not grab(SOLAR_PANEL_V, num, {5,7,9,11}) then return false, 'Could not grab SOLAR_PANEL_V' end
  if not grab(MACHINE_FRAME_RESONANT, num, {6}) then return false, 'Could not grab MACHINE_FRAME_RESONANT' end
  if not grab(RESONANT_ENERGY_CELL_FRAME, num, {10}) then return false, 'Could not grab RESONANT_ENERGY_CELL_FRAME' end

  success, errMsg = craftAndDrop(SOLAR_PANEL_V, num)
  if not success then return false, errMsg end
  print('SP VI (' .. num .. 'x) crafted.')
  return true
end





local tArgs = {...}
if tArgs == nil then
  print '"solar make" to run main program'
  return
elseif tArgs[1] == 'make' then
  dumpAll()
  while true do
    success, errMsg = craftPlank(64)
    if not success then print(errMsg); dumpAll() end

    success, errMsg = craftRedstoneBlock(8)
    if not success then print(errMsg); dumpAll() end

    success, errMsg = craftMirror(64)
    if not success then print(errMsg); dumpAll() end

    success, errMsg = craftSolarPanelI(64)
    if not success then print(errMsg); dumpAll() end

    success, errMsg = craftReceptionCoil(64)
    if not success then print(errMsg); dumpAll() end

    success, errMsg = craftSolarPanelII(8)
    if not success then print(errMsg); dumpAll() end

    success, errMsg = craftTinGear(64)
    if not success then print(errMsg); dumpAll() end

    success, errMsg = craftLeadstoneEnergyFrame(8)
    if not success then print(errMsg); dumpAll() end

    success, errMsg = craftMachineFrameBasic(8)
    if not success then print(errMsg); dumpAll() end

    success, errMsg = craftSolarPanelIII(8)
    if not success then print(errMsg); dumpAll() end

    print('Sleeping...')
    os.sleep(10)
  end
elseif tArgs[1] == '1' then
  dumpAll()
  while true do
    success, errMsg = craftPlank(64)
    if not success then print(errMsg); dumpAll() end
    success, errMsg = craftPlank(64)
    if not success then print(errMsg); dumpAll() end
    success, errMsg = craftPlank(64)
    if not success then print(errMsg); dumpAll() end
    success, errMsg = craftPlank(64)
    if not success then print(errMsg); dumpAll() end
    success, errMsg = craftPlank(64)
    if not success then print(errMsg); dumpAll() end

    success, errMsg = craftMirror(64)
    if not success then print(errMsg); dumpAll() end
    success, errMsg = craftMirror(64)
    if not success then print(errMsg); dumpAll() end
    success, errMsg = craftMirror(64)
    if not success then print(errMsg); dumpAll() end

    success, errMsg = craftSolarPanelI(64)
    if not success then print(errMsg); dumpAll() end
  end
elseif tArgs[1] == '2' then
  dumpAll()
  while true do
    success, errMsg = craftReceptionCoil(64)
    if not success then print(errMsg); dumpAll() end

    success, errMsg = craftSolarPanelII(64)
    if not success then print(errMsg); dumpAll() end
  end
elseif tArgs[1] == '3' then
  dumpAll()
  while true do

    success, errMsg = craftRedstoneBlock(8)
    if not success then print(errMsg); dumpAll() end

    success, errMsg = craftTinGear(64)
    if not success then print(errMsg); dumpAll() end

    success, errMsg = craftLeadstoneEnergyFrame(8)
    if not success then print(errMsg); dumpAll() end

    success, errMsg = craftMachineFrameBasic(8)
    if not success then print(errMsg); dumpAll() end

    success, errMsg = craftSolarPanelIII(8)
    if not success then print(errMsg); dumpAll() end
  end

elseif tArgs[1] == '4' then
elseif tArgs[1] == '5' then
elseif tArgs[1] == '6' then
elseif tArgs[1] == 'sp1' then
  dumpAll()
  while true do
    success, errMsg = craftSolarPanelI(64)
    if not success then print(errMsg); dumpAll() end
  end
elseif tArgs[1] == 'sp2' then
  dumpAll()
  while true do
    success, errMsg = craftSolarPanelII(64)
    if not success then print(errMsg); dumpAll() end
  end
elseif tArgs[1] == 'sp3' then
  dumpAll()
  while true do
    success, errMsg = craftSolarPanelIII(64)
    if not success then print(errMsg); dumpAll() end
  end
elseif tArgs[1] == 'sp4' then
  dumpAll()
  while true do
    success, errMsg = craftSolarPanelIV(64)
    if not success then print(errMsg); dumpAll() end
  end
elseif tArgs[1] == 'sp5' then
  dumpAll()
  while true do
    success, errMsg = craftSolarPanelV(64)
    if not success then print(errMsg); dumpAll() end
  end
elseif tArgs[1] == 'sp6' then
  dumpAll()
  while true do
    success, errMsg = craftSolarPanelVI(64)
    if not success then print(errMsg); dumpAll() end
  end

end