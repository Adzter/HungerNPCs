AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

util.AddNetworkString("sendChefMenu")
util.AddNetworkString("buyFood")

function ENT:Initialize()
	self:SetSolid( 2 )
	self:SetModel( hungerConfig.chefModel )
	self:SetUseType( SIMPLE_USE )
	self:SetAnimation( 0 )
	
	self:SetMoveType( MOVETYPE_STEP )
	self:SetSolid( SOLID_BBOX )
	self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
end

local cooldown = CurTime()
-- prevent spamming with a cooldown
function ENT:AcceptInput(ply, caller)
	if caller:IsPlayer() && cooldown < CurTime() then
		cooldown = CurTime() + 1
		net.Start("sendChefMenu")
		net.Send( caller )
	end
end

net.Receive("buyFood", function( len, ply )
	local food = net.ReadString()
	
	-- Lets make sure what the client is sending us
	-- is actually in the food table.
	for k,v in pairs( FoodItems ) do
		-- Make sure we're actually spawning food
		if v["name"] == food and table.HasValue( hungerConfig.chefItems, food ) then
			
			-- Make sure they can actually afford it
			if not ply:canAfford( v["price"] ) then 
				DarkRP.notify( ply, 1, 5, "You can't afford this" )
				return 
			end
			
			local chef = ents.FindByClass( "npc_chef" )[1]
			-- I know this is a horrible way of doing it, but it's 2am and
			-- I can't think of anything better atm.
			
			-- Remove the appropriate amount of money
			ply:addMoney( -v["price"] )
			
			-- Let them know they bought it
			DarkRP.notify( ply, 0, 5, "You purchased: " .. v["name"] .. " for $" .. v["price"] )
			
			-- Make sure they're in range and not trying to spawn it from half way across the map
			if ply:GetPos():Distance( chef:GetPos() ) < 170 then
				local SpawnedFood = ents.Create("spawned_food")
				SpawnedFood:Setowning_ent(ply)
				SpawnedFood.ShareGravgun = true
				SpawnedFood:SetPos( chef:LocalToWorld( Vector( 30, 0, 50 ) ) )
				SpawnedFood.onlyremover = true
				SpawnedFood.SID = ply.SID
				SpawnedFood:SetModel(v["model"])
				SpawnedFood.FoodName = v["name"]
				SpawnedFood.FoodEnergy = v["energy"]
				SpawnedFood.FoodPrice = v["price"]
				SpawnedFood:Spawn()
			end
		end
	end
end)