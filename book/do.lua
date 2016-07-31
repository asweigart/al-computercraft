-- "Do" program
-- By Al Sweigart
-- al@inventwithpython.com
-- Does various actions from shell.

os.loadAPI('hare')

local cliArgs = {...}
if #cliArgs == 0 then
	print('Usage: do [actions]')
	print('See hare.lua for actions.')
	return
end

local actions = table.concat(cliArgs, ' ')
print(hare.doActions(actions))
