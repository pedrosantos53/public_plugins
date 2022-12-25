
local PLUGIN = PLUGIN

PLUGIN.name = "Drop Weapon and Wipe Inventory on Death"
PLUGIN.description = "Adds dropping equipped weapons and destroying your entire inventory upon death."
PLUGIN.author = "pedro.santos53"

ix.config.Add("destroyInventoryOnDeath", true, "Whether or not players' inventories should wipe upon death.", nil, {
	category = "Drop Inventory on Death"
})

ix.config.Add("dropWeaponOnDeath", true, "Whether or not players drop their currently held weapon on death.", nil, {
	category = "Drop Inventory on Death"
})

ix.util.Include("sv_plugin.lua")