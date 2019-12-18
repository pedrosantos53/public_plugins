
ITEM.name = "Shaped Charge Breaching Device"
ITEM.description = "A shaped explosive charge specially designed to do minimal structural damage to the target door while still granting access to the other side."
ITEM.model = Model("models/props_wasteland/prison_padlock001a.mdl")
ITEM.width = 1
ITEM.height = 1

ITEM.functions.Place = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client

		local breach = scripted_ents.Get("ix_doorbreach"):SpawnFunction(client, util.TraceLine(data))

		if (IsValid(breach)) then
			client:EmitSound("physics/metal/weapon_impact_soft2.wav", 75, 80)
		else
			return false
		end
	end
}
