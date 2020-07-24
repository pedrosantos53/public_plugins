
local PLUGIN = PLUGIN

PLUGIN.name = "Money Printers"
PLUGIN.author = "pedro.santos53"
PLUGIN.description = "Adds customizable money printers."

ix.config.Add("minPrintAmount", 5, "Minimum amount to be printed out of money printers.", nil, {
	data = {min = 1, max = 300},
	category = "Money Printers"
})

ix.config.Add("maxPrintAmount", 30, "Maximum amount to be printed out of money printers.", nil, {
	data = {min = 1, max = 300},
	category = "Money Printers"
})

ix.config.Add("printTime", 30, "Time it takes for a printer to print one stack of currency.", nil, {
	data = {min = 1, max = 300},
	category = "Money Printers"
})

ix.config.Add("printerHP", 100, "Starting health of printers.", nil, {
	data = {min = 1, max = 1000},
	category = "Money Printers"
})