
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Door Breach"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

if (SERVER) then

	function ENT:GetLockPosition(door, normal)
		local index = door:LookupBone("handle")
		local position = door:GetPos()
		normal = normal or door:GetForward():Angle()

		if (index and index >= 1) then
			position = door:GetBonePosition(index)
		end

		position = position + normal:Forward() * 4 + normal:Up() * 8 + normal:Right() * -21

		normal:RotateAroundAxis(normal:Up(), 180)
		normal:RotateAroundAxis(normal:Forward(), 180)
		normal:RotateAroundAxis(normal:Right(), 180)

		return position, normal
	end

	function ENT:SetDoor(door, position, angles)
		if (!IsValid(door) or !door:IsDoor()) then
			return
		end

		local doorPartner = door:GetDoorPartner()

		self.door = door
		self.door:DeleteOnRemove(self)
		door.ixBreach = self

		if (IsValid(doorPartner)) then
			self.doorPartner = doorPartner
			self.doorPartner:DeleteOnRemove(self)
			doorPartner.ixBreach = self
		end

		self:SetPos(position)
		self:SetAngles(angles)
		self:SetParent(door)
	end

	function ENT:SpawnFunction(client, trace)
		local door = trace.Entity

		if (!IsValid(door) or !door:IsDoor() or IsValid(door.ixBreach)) then
			return client:NotifyLocalized("dNotValid")
		end

		local normal = client:GetEyeTrace().HitNormal:Angle()
		local position, angles = self:GetLockPosition(door, normal)

		local entity = ents.Create("ix_doorbreach")
		entity:SetPos(trace.HitPos)
		entity:Spawn()
		entity:Activate()
		entity:SetDoor(door, position, angles)

		return entity
	end

	function ENT:OnRemove()
		if (IsValid(self)) then
			self:SetParent(nil)
		end

		if (IsValid(self.door)) then
			self.door:Fire("unlock")
			self.door.ixBreach = nil
		end

		if (IsValid(self.doorPartner)) then
			self.doorPartner:Fire("unlock")
			self.doorPartner.ixBreach = nil
		end
	end

	function ENT:Initialize()
		self:SetModel("models/props_wasteland/prison_padlock001a.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetUseType(SIMPLE_USE)

		self.nextUseTime = 0
	end

	function ENT:Explode( )
		local eff = EffectData( )
		eff:SetStart( self:GetPos( ) )
		eff:SetOrigin( self:GetPos( ) )
		eff:SetScale( 6 )
		util.Effect( "Explosion", eff, true, true )

		-- This determines if and how much damage the surrounding entities (namely, players) take from the blast.
		util.BlastDamage( self, self, self:GetPos(), 40, 15)
		self:EmitSound( "physics/wood/wood_furniture_break" .. math.random( 1, 2 ) .. ".wav" )
	end

	function ENT:Use(client)
		if (self.nextUseTime > CurTime()) then
			return
		end

		self:SetNWBool("beep", true)
		self:EmitSound("buttons/blip1.wav")
		timer.Simple(1, function()
			self:EmitSound("buttons/blip1.wav")
			timer.Simple(1, function()
				self:EmitSound("buttons/blip1.wav")
				timer.Simple(0.8, function()
					self:EmitSound("buttons/blip1.wav")
					timer.Simple(0.6, function()
						self:EmitSound("buttons/blip1.wav")
						timer.Simple(0.4, function()
							self:EmitSound("buttons/blip1.wav")
							timer.Simple(0.4, function()
								self:EmitSound("buttons/blip1.wav")
								timer.Simple(0.3, function()
									self:EmitSound("buttons/blip1.wav")
									timer.Simple(0.3, function()
										self:EmitSound("buttons/blip1.wav")
										timer.Simple(0.2, function()
											self:EmitSound("buttons/blip1.wav")
											timer.Simple(0.2, function()
												self:EmitSound("buttons/blip1.wav")
												timer.Simple(0.1, function()
													self:EmitSound("buttons/blip1.wav")
													timer.Simple(0.1, function()
														if (IsValid(self.door)) then
															self:EmitSound("buttons/blip1.wav")
															self:EmitSound("weapons/explode3.wav")
															self:Explode()
															self.door:Fire("unlock")
															self.door:Fire("open")
															self:Remove()
															if (IsValid(self.doorPartner)) then
																self.doorPartner:Fire("unlock")
																self.doorPartner:Fire("open")
															end
														end
													end )
												end )
											end )
										end	)
									end )
								end )
							end )
						end )
					end	)
				end )
			end )
		end	)
	self.nextUseTime = CurTime() + 10
	end
else
	local glowMaterial = ix.util.GetMaterial("sprites/glow04_noz")
	local color_green = Color(0, 255, 0, 255)
	local color_blue = Color(0, 100, 255, 255)
	local color_red = Color(255, 50, 50, 255)

	function ENT:Draw()
		self:DrawModel()

		local color = color_green

		if (self:GetNWBool("beep", false)) then
			color = color_red
		else
			color = color_green
		end

		local position = self:GetPos() + self:GetForward() * 1.5 + self:GetUp() * 3

		render.SetMaterial(glowMaterial)
		render.DrawSprite(position, 10, 10, color)
	end
end
