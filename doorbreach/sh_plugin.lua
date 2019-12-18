
local PLUGIN = PLUGIN

PLUGIN.name = "Door Breaching"
PLUGIN.author = "pedro.santos53"
PLUGIN.description = "Allows you to breach doors with breaching charges."

ix.config.Add("doorBreachingEnabled", true, "Whether or not door breaching is enabled.", nil, {
	category = "Door Breaching"
})
