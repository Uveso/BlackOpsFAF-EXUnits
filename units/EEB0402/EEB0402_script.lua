--------------------------------------------------------------------------------
-- Author(s):  Tpapp & Exavier Macbeth
-- Summary  :  UEF T4 Stellar Generator Script
-- Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--------------------------------------------------------------------------------

local TEnergyCreationUnit = import('/lua/terranunits.lua').TEnergyCreationUnit
local DeathNukeWeapon = import('/lua/sim/defaultweapons.lua').DeathNukeWeapon
local TrashBagAdd = TrashBag.Add

---@class EEB0402 : TEnergyCreationUnit
EEB0402 = Class(TEnergyCreationUnit) {

    Weapons = {
        DeathWeapon = Class(DeathNukeWeapon) {},
    },

    ---@param self EEB0402
    ---@param builder Unit
    ---@param layer Layer
    OnStopBeingBuilt = function(self,builder,layer)
        TEnergyCreationUnit.OnStopBeingBuilt(self,builder,layer)
        local trash = self.Trash

        self.RotorArms = CreateRotator(self, 'arms', 'y', nil, 0, 16, 45)
        self.RotorRings01 = CreateRotator(self, 'ring01', 'z', nil, 0, 60, 202)
        self.RotorRings02 = CreateRotator(self, 'ring02', 'x', nil, 0, 60, -270)
        self.RotorRings03A = CreateRotator(self, 'ring03', 'y', nil, 0, 120, 405)
        self.RotorRings03B = CreateRotator(self, 'ring03', 'x', nil, 0, 18, 67)
        self.RotorSubRings01 = CreateRotator(self, 'ring01_sub', 'x', nil, 0, 12, 30)
        self.RotorSubRings02 = CreateRotator(self, 'ring02_sub', 'y', nil, 0, 12, 30)
        self.RotorSubRings03 = CreateRotator(self, 'ring03_sub', 'z', nil, 0, 12, 30)

        TrashBagAdd(trash, self.RotorArms)
        TrashBagAdd(trash, self.RotorRings01)
        TrashBagAdd(trash, self.RotorRings02)
        TrashBagAdd(trash, self.RotorRings03A)
        TrashBagAdd(trash, self.RotorRings03B)
        TrashBagAdd(trash, self.RotorSubRings01)
        TrashBagAdd(trash, self.RotorSubRings02)
        TrashBagAdd(trash, self.RotorSubRings03)

        self.StellarCoreTable = {}
        self.UnitComplete = true
        TrashBagAdd(trash, ForkThread(self.InitialSpawnDelay, self))
    end,

    ---@param self EEB0402
    NotifyOfDroneDeath = function(self)
        ------ Only respawns the drones if the parent unit is not dead
        if not self.Dead then
            --local mass = self:GetAIBrain():GetEconomyStored('Mass')
            --local energy = self:GetAIBrain():GetEconomyStored('Energy')
            ------ Check to see if the player has enough mass / energy
            ------ And that the production is enabled.
            --if self:GetScriptBit('RULEUTC_ProductionToggle') == false and mass >= 100 and energy >= 1000 then
            --    ------Remove the resources and spawn a single drone
            --    self:GetAIBrain():TakeResource('Mass',100)
            --    self:GetAIBrain():TakeResource('Energy',1000)
            --    self:ForkThread(self.SpawnDrone)
            --else
            --    ------ If the above conditions are not met the carrier will wait a short time and try again
            --    self:ForkThread(self.EconomyWait)
            --end
            self:ForkThread(self.CoreMonitor)
        end
    end,

    ---@param self EEB0402
    InitialSpawnDelay = function(self)
        WaitSeconds(2)
        self:ForkThread(self.CoreSpawn)
    end,

    ---@param self EEB0402
    CoreMonitor = function(self)
        self:OnProductionPaused()
        self.RotorRings01:SetTargetSpeed(0)
        self.RotorRings02:SetTargetSpeed(0)
        self.RotorRings03A:SetTargetSpeed(0)
        self.RotorRings03B:SetTargetSpeed(0)
        WaitSeconds(5)
        self.RotorRings01:SetTargetSpeed(202)
        self.RotorRings02:SetTargetSpeed(-270)
        self.RotorRings03A:SetTargetSpeed(405)
        self.RotorRings03B:SetTargetSpeed(67)
        WaitSeconds(1)
        self:ForkThread(self.CoreSpawn)
        WaitSeconds(2)
        self:OnProductionUnpaused()
    end,

    ---@param self EEB0402
    CoreSpawn = function(self)
        local platOrient = self:GetOrientation()
        local location = self:GetPosition('star')
        local StellarCore = CreateUnit('eeb0001', self:GetArmy(), location[1], location[2], location[3], platOrient[1], platOrient[2], platOrient[3], platOrient[4], 'Land')
        table.insert (self.StellarCoreTable, StellarCore)
        StellarCore:AttachTo(self, 'star')
        StellarCore:SetParent(self, 'eeb0402')
        StellarCore:SetCreator(self)
        self.Trash:Add(StellarCore)
    end,

}

TypeClass = EEB0402