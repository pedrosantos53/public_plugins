
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

			-- Check if dropping weapons is enabled and skip checking for weapon classes that shouldn't drop
			if ix.config.Get("dropWeaponOnDeath", false) and !dontDrop[weapon:GetClass()] then
				for _, v in pairs(items) do
					if v:GetData("equip", false) and (v.class == weapon:GetClass()) then
						v:SetData("equip", false)
						target:StripWeapon(v.class)
						v:Transfer() -- drops the item
						weapon = v
						break
					end
				end
			end

			-- Drop inventory, if enabled
			if ix.config.Get("destroyInventoryOnDeath", false) then
				for _, item in pairs(items) do
					if !item.noDrop and item != weapon then
						item:Remove()
					end
				end
			end
		end
	end
end