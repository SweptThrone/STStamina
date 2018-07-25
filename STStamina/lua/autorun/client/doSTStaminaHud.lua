local smoothStam = 100

hook.Add( "HUDPaint", "DrawStamina", function()
	
	local ply = LocalPlayer()
	
	--color calculations based on SDM's HUD
	local stam = ply:GetNWFloat( "CurrStamina" )
	local g, r = 0, 0
	if stam >= 50 then
		g = 255
		r = 255 - (5.1 * (stam - 50))
	elseif stam < 50 then
		g = (5.1 * (stam))
		r = 255
	else
		g = 255
		r = 0
	end
	
	--draw stamina bar and background of stamina bar
	draw.RoundedBox( 4, 48, ScrH() - 162, 312, 40, Color(0,0,0) )
	--thanks CodeBlue!
	smoothStam = Lerp( 15 * FrameTime(), smoothStam, stam )
	draw.RoundedBox( 4, 54, ScrH() - 156, smoothStam * 3, 28, Color(r,g,0) )
	
end )
