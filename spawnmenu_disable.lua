
local PLUGIN = PLUGIN or {}

PLUGIN.name = "Spawn Menu Disable"
PLUGIN.author = "pedro.santos53"
PLUGIN.description = "Removes the ability to open the spawn menu for non-staff."

if CLIENT then
	function PLUGIN:OnSpawnMenuOpen()
		if !(LocalPlayer():IsAdmin()) then
			return false
		end
	end
end