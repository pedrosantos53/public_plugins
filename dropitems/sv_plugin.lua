
local PLUGIN = PLUGIN

local dontDrop = {
	["weapon_physgun"] = true,
	["gmod_tool"] = true,
	["ix_hands"] = true,
	["ix_keys"] = true,
}

function PLUGIN:PlayerHurt(target, attacker, health, damageAmount)
	local character = target:GetCharacter()

	if character then
		local inventory = character:GetInventory()
		local items = inventory:GetItems()

		-- If the player is taking lethal damage
		if health <= 0 then
			local weapon = target:GetActiveWeapon()
			local class = weapon and weapon:GetClass()
			local bDropWeapons = ix.config.Get("dropWeaponOnDeath", false)
			local bDestroyInventory = ix.config.Get("destroyInventoryOnDeath", false)

			for _, item in pairs(items) do
				-- Check if dropping weapons is enabled and skip checking for weapon classes that shouldn't drop
				if (item:GetData("equip", false) and (item.class == class)) then
					weapon = item

					if bDropWeapons and !dontDrop[class] then
						item:SetData("equip", false)
						target:StripWeapon(class)
						item:Transfer() -- drops the item
					end
				end

				-- Destroy inventory, if enabled
				if bDestroyInventory and (!item.noDrop and item != weapon) then
					item:Remove()
				end
			end
		end
	end
end
