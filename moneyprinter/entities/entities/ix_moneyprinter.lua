
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Money Printer"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true
-- The money printer will start ON (true), not OFF (false).
ENT.bOn = true
ENT.health = ix.config.Get("printerHP", 100)


if (SERVER) then
	function ENT:SpawnFunction(client, trace)
		local printer = ents.Create("ix_moneyprinter")

		printer:SetPos(trace.HitPos + Vector(0,0,5))
		printer:Spawn()
		printer:Activate()

		return printer
	end

	function ENT:Initialize()
		self:SetModel("models/props_lab/reciever01a.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:DrawShadow(false)
		self:SetUseType(SIMPLE_USE)
		self:PhysicsInit( SOLID_VPHYSICS )

		local physics = self:GetPhysicsObject()
		physics:EnableMotion(true)

		self.nextPrintTime = CurTime()
		self.toggleCooldown = CurTime()
	end

	function ENT:Think()
		-- This is where the delay between each print of money is being determined. ix.config.Get("printTime") is whatever you set it to ingame.
		if (CurTime() > self.nextPrintTime + ix.config.Get("printTime", 5)) and self.bOn then
			self.nextPrintTime = CurTime()
			self:SpawnCurrency()
		end
	end

	function ENT:Use(activator)
		if CurTime() > self.toggleCooldown + 3 then
			self.toggleCooldown = CurTime()
			self.nextPrintTime = CurTime()
			self:Toggle(activator)
			self:EmitSound("buttons/lightswitch2.wav")
		end
	end

	function ENT:Toggle(activator)
		if self.bOn then
			self.bOn = false
			activator:Notify("You turn the printer off.")
		elseif self.bOn == false then
			self.bOn = true
			activator:Notify("You turn the printer on.")
		end
	end

	function ENT:SpawnCurrency(callback, releaseDelay)
		releaseDelay = releaseDelay or 1.2

		-- This is where the money value is being determined. math.random is picking a number between the minimum print amount and the maximum print amount.
		local item = ix.currency.Spawn(self:GetPos() + Vector(0,0,8), math.random(ix.config.Get("minPrintAmount", 5), ix.config.Get("maxPrintAmount", 30)))

			item:SetMoveType(MOVETYPE_NONE)
			item:SetNotSolid(true)
			item:SetParent(self, 1)

		self:EmitSound("ambient/machines/combine_terminal_idle4.wav")

		timer.Simple(releaseDelay, function()
			local physics = item:GetPhysicsObject()

			item:SetMoveType(MOVETYPE_VPHYSICS)
			item:SetNotSolid(false)
			item:SetParent(nil)

			if (IsValid(physics)) then
				physics:EnableGravity(true)
			end
		end)
		self.nextPrintTime = CurTime()
	end

	function ENT:OnTakeDamage(dmg)
    	self:TakePhysicsDamage(dmg)
	
    	if self.burningup then return end
	
    	self.damage = (self.damage or 100) - dmg:GetDamage()
    	if self.damage <= 0 then
    	    local rnd = math.random(1, 10)
    	    if rnd < 3 then
    	        self:BurstIntoFlames()
    	    else
    	        self:Destruct()
    	        self:Remove()
    	    end
   		end
	end

	function ENT:BurstIntoFlames()
    	self.burningup = true
    	local burntime = math.random(8, 18)
    	self:Ignite(burntime, 0)
    	timer.Simple(burntime, function() self:Fireball() end)
	end

	function ENT:Fireball()
    	if not self:IsOnFire() then self.burningup = false return end
    	local dist = math.random(20, 280) -- Explosion radius
    	self:Destruct()
    	for k, v in pairs(ents.FindInSphere(self:GetPos(), dist)) do
    	    if not v:IsPlayer() and not v:IsWeapon() and v:GetClass() ~= "predicted_viewmodel" and not v.IsMoneyPrinter then
    	        v:Ignite(math.random(5, 22), 0)
    	    elseif v:IsPlayer() then
    	        local distance = v:GetPos():Distance(self:GetPos())
    	        v:TakeDamage(distance / dist * 100, self, self)
    	    end
    	end
    	self:Remove()
	end

	function ENT:Destruct()
    	local vPoint = self:GetPos()
    	local effectdata = EffectData()
    	effectdata:SetStart(vPoint)
    	effectdata:SetOrigin(vPoint)
    	effectdata:SetScale(1)
    	util.Effect("Explosion", effectdata)
	end
end