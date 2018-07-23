hook.Add( "HUDPaint", "DrawStamina", function()
	
	local ply = LocalPlayer()
	
	--color calculations based on SDM's HUD
	local hp = ply:GetNWFloat( "CurrStamina" )
	local g, r = 0, 0
	if hp >= 50 then
		g = 255
		r = 255 - (5.1 * (hp - 50))
	elseif hp < 50 then
		g = (5.1 * (hp))
		r = 255
	else
		g = 255
		r = 0
	end
	
	--draw stamina bar and background of stamina bar
	draw.RoundedBox( 4, 48, ScrH() - 162, 312, 40, Color(0,0,0) )
	draw.RoundedBox( 4, 54, ScrH() - 156, hp * 3, 28, Color(r,g,0) )
	
end )