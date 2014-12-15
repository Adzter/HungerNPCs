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
	
	self:SetMoveType(MOVETYPE_NONE)
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
		if v["name"] == food then
			if table.HasValue( hungerConfig.chefItems, food )
				-- spawn the food
			end
		end
	end
end)