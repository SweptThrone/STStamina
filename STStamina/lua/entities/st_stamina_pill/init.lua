AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()

	self:SetModel("models/props_junk/plasticbucket001a.mdl")
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:Wake() end
	self:SetUseType(SIMPLE_USE)
	
	self:SetModelScale( 0.25 )
end

function ENT:Think()

end

function ENT:Use(a, ply)
	if !IsValid(ply) then return end
	self:EmitSound("npc/barnacle/barnacle_gulp" .. math.random(1,2) .. ".wav")
	
	ply:SetNWFloat( "CurrStamina", 100 )
	
	self:Remove()
end