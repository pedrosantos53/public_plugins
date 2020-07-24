
local PLUGIN = PLUGIN

PLUGIN.name = "Height"
PLUGIN.description = "Changes character height based on inputted height."
PLUGIN.author = "pedro.santos53"

local function DetermineScale(height)
	if (height != 0) then
		if (height <= 50) then
			return 0.95
		elseif (height <= 62) then
			return 0.97
		elseif (height <= 69) then
			return 1
		elseif (height <= 75) then
			return 1.02
		elseif (height > 75) then
			return 1.05
		end
	end
end

function PLUGIN:PlayerLoadout(client)
	local character = client:GetCharacter()

	timer.Simple(0.1, function()
		if (character:GetData("height", 0) != 0) then

			local scaleViewFix = DetermineScale(character:GetData("height", 0))
			local scaleViewFixOffset = Vector(0, 0, 64)
			local scaleViewFixOffsetDuck = Vector(0, 0, 28)

			client:SetViewOffset(scaleViewFixOffset * scaleViewFix)
			client:SetViewOffsetDucked(scaleViewFixOffsetDuck * scaleViewFix)

			client:SetModelScale( scaleViewFix )
		else
			client:SetViewOffset(Vector(0, 0, 64))
			client:SetViewOffsetDucked(Vector(0, 0, 28))
			client:SetModelScale ( 1 )
		end
	end)
end