include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end

surface.CreateFont( "foodDesc", {
	font = "Bebas Neue", 
	size = 25, 
	weight = 500, 
	blursize = 0, 
	scanlines = 0, 
	antialias = true, 
} )
surface.CreateFont( "foodEnergy", {
	font = "Bebas Neue", 
	size = 20, 
	weight = 500, 
	blursize = 0, 
	scanlines = 0, 
	antialias = true, 
} )

net.Receive( "sendChefMenu", function()
	DFrame = vgui.Create( "DFrame" )
	DFrame:SetSize( 500, 350 )
	DFrame:Center()
	DFrame:SetTitle("")
	DFrame:MakePopup()
	
	function DFrame:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 240, 240, 240 ) )
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 39, 174, 96) )
		draw.SimpleText( "Hunger NPCs", "Trebuchet18", w/2, 3, Color(255,255,255), TEXT_ALIGN_CENTER, 0 )
	end
	
	local DScrollPanel = vgui.Create( "DScrollPanel", DFrame )
	DScrollPanel:SetSize( DFrame:GetWide()-15, DFrame:GetTall()-25 )
	DScrollPanel:SetPos( 15, 25 )

	PrintTable( FoodItems )
	local panelCount = -0.6
	for k,v in pairs(FoodItems) do
	
		panelCount = panelCount + 1
		
		-- Increment the height by multiplying by the current count
		local DLabel = vgui.Create( "DLabel", DScrollPanel )
		DLabel:SetText( v["name"] )
		DLabel:SetPos( 65, panelCount*55 )
		DLabel:SetColor( Color(0, 0, 0) )
		DLabel:SetFont( "foodDesc" )
		DLabel:SizeToContents()
		
		local DLabel = vgui.Create( "DLabel", DScrollPanel )
		DLabel:SetText( "Energy: " .. v["energy"] )
		DLabel:SetPos( 65, panelCount*55+20 )
		DLabel:SetColor( Color(0, 0, 0) )
		DLabel:SetFont( "foodEnergy" )
		DLabel:SizeToContents()
		
		local modelPanel = vgui.Create( "DModelPanel", DScrollPanel )
		modelPanel:SetSize( 200, 200 )
		modelPanel:SetPos( -75, panelCount*55-156 )
		modelPanel:SetModel( v["model"] )
		
		local buyButton = vgui.Create( "DButton", DScrollPanel )
		buyButton:SetPos( 355, panelCount*55 )
		buyButton:SetText( "" )
		buyButton:SetSize( 90, 40 )
		buyButton.DoClick = function()
			DFrame:Remove()
			
			-- Send the request to be dealt with serverside
			-- Don't need to include the price, we can check serverside
			net.Start("buyFood")
				net.WriteString( v["name"] )
			net.SendToServer()
		end

		function buyButton:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 39, 174, 96) )
			draw.SimpleText( "$" .. v["price"], "foodDesc", w/2, h/2, Color(50,50,50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
end)