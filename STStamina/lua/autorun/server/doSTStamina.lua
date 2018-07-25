sound.Add( {
	name = "low_stamina_breath",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = { 80, 120 },
	sound = "player/breathe1.wav"
} )

--set default values we can reference later
hook.Add( "PlayerInitialSpawn", "SetUpDefaultValues", function( ply )

	ply.DEFAULTRUN = ply:GetRunSpeed() or 400
	ply.DEFAULTWALK = ply:GetWalkSpeed() or 200
	ply.DEFAULTJUMP = ply:GetJumpPower() or 200

end )

hook.Add( "PlayerTick", "DoStaminaSystem", function( ply )

	local numup = 0
	if !ply:Alive() then return end
	if !ply:OnGround() then 
		numup = 0.1
	else
		numup = 0.25
	end
	--regen stamina
	ply:SetNWFloat( "CurrStamina", math.Clamp( ply:GetNWFloat( "CurrStamina", ply:GetNWInt( "staminacap", 100 ) ) + numup, 0, 100 ) )
	--if you're running at the default value, but are actually slower than walking
	if ply:IsSprinting() and ply:GetRunSpeed() == ply.DEFAULTRUN and ply:GetVelocity():Length() >= ply.DEFAULTWALK and ply:OnGround() then
		ply:SetNWFloat( "CurrStamina", math.Clamp( ply:GetNWFloat( "CurrStamina" ) - 0.5, 0, 100 ) )
	--stamina drain underwater
	elseif ply:WaterLevel() >= 2 then
		if ply:IsSprinting() then
			ply:SetNWFloat( "CurrStamina", math.Clamp( ply:GetNWFloat( "CurrStamina" ) - 0.3, 0, 100 ) )
		else
			ply:SetNWFloat( "CurrStamina", math.Clamp( ply:GetNWFloat( "CurrStamina" ) - 0.2, 0, 100 ) )
		end
	end
	--exhaustion
	if ply:GetNWFloat( "CurrStamina" ) <= 25 then
		if !ply:IsSprinting() or ply:GetNWFloat( "CurrStamina" ) == 0 then
			ply:SetWalkSpeed( ply.DEFAULTWALK * 0.625 )
			ply:SetRunSpeed( ply.DEFAULTWALK * 0.625 )
		end
		ply:SetJumpPower( ply.DEFAULTJUMP / 2 )
		if !ply.soundisplaying then
			ply:EmitSound( "low_stamina_breath" )
			ply.soundisplaying = true
		end
	else
		ply:SetWalkSpeed( ply.DEFAULTWALK )
		ply:SetRunSpeed( ply.DEFAULTRUN )
		ply:SetJumpPower( ply.DEFAULTJUMP )
		if ply.soundisplaying then
			ply:StopSound( "low_stamina_breath" )
			ply.soundisplaying = false
			ply:EmitSound( "player/suit_sprint.wav" )
		end
	end
	
end )

hook.Add( "KeyPress", "DecreaseStaminaOnJump", function( ply, key )

	if !ply:Alive() then return end
	if ply:InVehicle() then return end
	if !ply:OnGround() then return end
	if key == IN_JUMP then
		ply:SetNWFloat( "CurrStamina", math.Clamp( ply:GetNWFloat( "CurrStamina" ) - 15, 0, 100 ) )
	end

end )

hook.Add( "PlayerDeath", "ResetStamina", function( ply )

	ply:SetNWFloat( "CurrStamina", 100 )
	ply:StopSound( "low_stamina_breath" )
	ply.soundisplaying = false

end )
