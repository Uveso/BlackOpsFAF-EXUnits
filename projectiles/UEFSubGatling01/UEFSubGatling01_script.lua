--------------------------------------------------------------------------------------------------------------
-- File     :  /data/projectiles/TDFHeavyPlasmaGatlingCannon01/TDFHeavyPlasmaGatlingCannon01_script.lua
-- Author(s):  Gordon Duclos
-- Summary  :  UEF Heavy Plasma Gatling Cannon Projectile script, XEB2306
-- Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
---------------------------------------------------------------------------------------------------------------

local UEFHeavyPlasmaGatlingCannon01 = import('/mods/BlackOpsFAF-EXUnits/lua/EXBlackOpsprojectiles.lua').UEFHeavyPlasmaGatlingCannon01

---@class UEFSubGatling01 : UEFHeavyPlasmaGatlingCannon01
UEFSubGatling01 = Class(UEFHeavyPlasmaGatlingCannon01) {}
TypeClass = UEFSubGatling01