local PLUGIN = PLUGIN

PLUGIN.name = "Drop Weapon & Destroy Inventory"
PLUGIN.author = "pedro.santos53"
PLUGIN.description = "Makes the player drop their currently equipped weapon and destroys whatever they currently have on them upon dying."

ix.config.Add("pluginEnabled", true, "Whether or not corpses remain on the map after a player dies and respawns.", nil, {
	category = "Drop Weapon and Destroy Inventory"
})

ix.config.Add("dropWeapon", true, "Whether or not corpses remain on the map after a player dies and respawns.", nil, {
	category = "Drop Weapon and Destroy Inventory"
})

ix.config.Add("destroyInventory", true, "Whether or not corpses remain on the map after a player dies and respawns.", nil, {
	category = "Drop Weapon and Destroy Inventory"
})

if (SERVER) then

	function PLUGIN:EntityTakeDamage(target, dmg)
		if (!ix.config.Get("pluginEnabled", true)) or target:GetClass() == "prop_ragdoll" then
			return
		end

		local character = target:GetCharacter()
		local inventory = character:GetInventory()
		local items = inventory:GetItems()

		if dmg:GetDamage() >= target:Health() then
			if target and target:GetActiveWeapon() != ("weapon_physgun" or "gmod_tool" or "ix_hands" or "ix_keys") then
				for k, v in pairs(items) do
					if v:GetData("equip", false) and target:GetActiveWeapon() and (v.class == target:GetActiveWeapon():GetClass()) then
						v:SetData("equip", false)
						v:Transfer()
						target:StripWeapon(v.class)
					end
				end

				for _, slot in pairs(inventory.slots) do
					for _, item in pairs(slot) do
						if (item.noDrop != true) then
							item:Remove()
						end
					end
				end
			end
		end
	end
end