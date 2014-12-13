AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

util.AddNetworkString("sendChefMenu")

function ENT:Initialize()
	self:SetSolid( 2 )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetModel( hungerConfig.chefModel )
	self:SetUseType( SIMPLE_USE )
end

function ENT:Use( ply )
	if ply:IsPlayer() then
		net.Start("sendChefMenu")
		net.Send( ply )
	end
end