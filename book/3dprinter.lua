--[[ 3D Printer program
By Al Sweigart
turtleappstore.com/users/AlSweigart
Builds based on a blueprint and legend file. ]]

os.loadAPI('hare')

-- handle command line arguments
local cliArgs = {...}
blueprint = cliArgs[1]
legend = cliArgs[2]

if legend == nil or cliArgs[1] == '?' then
  print('Usage: 3dprint <blueprint> <legend>')
  print('See source for blueprint & legend file')
  print('format details.')
  return
end

if not fs.exists(blueprint) then
  error(blueprint .. ' file does not exist.')
end

if not fs.exists(legend) then
  error(legend .. ' file does not exist.')
end


-- read in the legend file
local legendData = {}
local legendFile = fs.open(legend, 'r')

-- read in first line
print('Legend:')
local line = legendFile.readLine()
while line ~= nil do
  -- remove leading & trailing whitespace
  line = hare.trim(line)
  print('LINE', line)

  -- only parse if this line is not blank or a comment
  if line ~= '' and string.find(line, '--') == nil then
    local equalPos = string.find(line, '=')
    
    -- make sure line is valid
    if equalPos == nil then
      error('Missing equal sign: ' + tostring(line))
    end

    local symbol = string.sub(line, 1, equalPos - 1)
    local block = string.sub(line, equalPos + 1)
    legendData[symbol] = block
    print(symbol, block)
  end

  -- read in next line
  line = legendFile.readLine()
end
print()

print('debug: read legend file')

-- validate the blueprint file
local blueprintFile = fs.open(blueprint, 'r')
line = blueprintFile.readLine()
local blueprintWidth = nil
local blueprintLength = 0
local i
while line ~= nil do
  -- remove leading & trailing whitespace
  line = hare.trim(line)

  -- only parse if this line is not blank or a comment
  if line ~= '' and string.find(line, '--') == nil then
    if blueprintWidth == nil then
      -- set the width based on the first line
      blueprintWidth = #line
    else
      if #line ~= blueprintWidth then
        error('Width of line is not ' + tostring(blueprintWidth) + ': ' + line)
      end
    end

    -- make sure all symbols exist in legendData
    for i = 1, blueprintWidth do
      if legendData[string.sub(line, i, i)] == nil then
        error('Symbol ' + string.sub(line, i, i) + ' does not exist in legend.')
      end
    end

    blueprintLength = blueprintLength + 1
  end
  line = blueprintFile.readLine()
end

print('debug: validated blueprint')

-- read in the blueprint file
local blueprintData = {}
blueprintFile = fs.open(blueprint, 'r')

-- read in first line
line = blueprintFile.readLine()

while line ~= nil do
  -- remove leading & trailing whitespace
  line = hare.trim(line)

  -- only parse if this line is not blank or a comment
  if line ~= '' and string.find(line, '--') then
    -- LEFT OFF
  end

  line = blueprintFile.readLine()
end

    
    