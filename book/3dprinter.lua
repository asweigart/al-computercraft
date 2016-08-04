-- 3D Printer program
-- By Al Sweigart
-- turtleappstore.com/users/AlSweigart
-- Builds based on a blueprint.

--[[ FORMAT OF BLUEPRINT FILES:


]]

-- handle command line arguments
local cliArgs = {...}
blueprint = cliArgs[1]

if blueprint == nil or cliArgs[1] == '?' then
  print('Usage: 3dprint <blueprint>')
  print('See source for blueprint file')
  print('format details.')
  return
end

if not fs.exists(blueprint) then
  print('ERROR: ' .. blueprint .. ' file does not exist.')
  return
end

-- read header of the blueprint
local layers = {}
local legend = {}
local fo = fs.open(blueprint, 'r')
local layerWidth = tonumber(fo.readLine())
local layerHeight = tonumber(fo.readLine())
local numLayers = tonumber(fo.readLine())

-- read in the legend
while true do
  line = fo.readLine()
  if line == nil then error('Incomplete header!') end
  if line == '~' then break end  -- ~ marks end of header

  -- in "x=block", x is key and block is value
  legend[string.sub(line, 1, 1)] = string.sub(line, 3)
end


local layerNum
local lineNum = 1
for layerNum = 1, numLayers do
  -- read in a layer
  local x, y, layer
  layer = {}
  for y = 1, layerHeight do
    line = fo.readLine()
    if line == nil then error(lineNum .. ': Incomplete layer!') end
    if #line ~= layerWidth then error(lineNum .. ': Row not long enough!') end
    if line == '~' then error(lineNum .. ':Not enough rows!') end
    lineNum = lineNum + 1

    local row = {}
    for x = 1, #line do
      table.insert(row, line[x])
    end
    table.insert(layer, row)
  end

  line = fo.readLine()
  if line ~= '~' then error(lineNum .. ': Expected ~ at end of layer!') end
  lineNum = lineNum + 1
  table.insert(layers, layer)
end

fo.close()


print('Printing...')

while true do
  print('Collecting...')
  for k, v in pairs({1,2,3,5,6,7,9,10,11}) do
    turtle.select(v)
    turtle.suck()
  end

  -- face the output barrel
  turtle.turnLeft()
  turtle.turnLeft()

  while true do
    turtle.select(16)
    turtle.craft(64)
    print('Crafted.')
    itemData = turtle.getItemDetail(16)
    if itemData == nil then break end
    turtle.drop()
    print('Deposited.')
  end

  -- face the resource barrel
  turtle.turnLeft()
  turtle.turnLeft()

  -- handle any leftover resources
  for k, v in pairs({1,2,3,5,6,7,9,10,11}) do
    turtle.select(v)
    turtle.drop() -- put it back into the resource barrel
  end


  print('Sleeping...')
  os.sleep(60)
end
