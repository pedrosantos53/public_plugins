
ITEM.name = "Money Printer"
ITEM.description = "A low-tech counterfeit currency printer."
ITEM.model = Model("models/props_lab/reciever01a.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(-0.5, 50, 2),
	ang = Angle(0, 270, 0),
	fov = 25.29
}

ITEM.functions.Place = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client

		scripted_ents.Get("ix_moneyprinter"):SpawnFunction(client, util.TraceLine(data))
	end
}
