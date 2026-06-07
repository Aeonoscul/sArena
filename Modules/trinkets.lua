local addonName, addon = ...
local module = addon:CreateModule("Trinkets")

module.defaultSettings = {
	x = -74,
	y = 7,
	size = 24,
	hideCountdownNumbers = false,
}

module.optionsTable = {
	size = {
		order = 1,
		type = "range",
		name = "Size",
		min = 10,
		max = 128,
		step = 1,
		bigStep = 2,
		set = module.UpdateSettings,
	}
}

-- ---------------------------------------------------------------------------
-- COMBAT_LOG_EVENT_UNFILTERED handler
-- ---------------------------------------------------------------------------

local function HandleCOMBAT_LOG_EVENT_UNFILTERED(self, ...)
	local _, event, sourceGUID, sourceName, _, destGUID, destName, _, spellId, spellName, _, _, _, _, _ = select(1,...)

	if UnitGUID(self.unit) ~= sourceGUID then return end
	if event ~= "SPELL_CAST_SUCCESS" then return end
	
	local arenaFrame = self:GetParent()
	local racial = arenaFrame.racial
	
	-- default trinket
	if spellId == 42292 then 
		self.time = tonumber(120)
		self.starttime = GetTime()
		CooldownFrame_SetTimer(self.cooldown, GetTime(), 120, 1)

		local overallTime;

		for key = 1, 40 do
			local _, _, icon, _, _, duration, expirationTime, _, _, _, spellID = UnitAura(self.unit, key, "HARMFUL")

			if spellID ~= nil and addon.overallCooldown[spellID] then
				overallTime = addon.overallCooldown[spellID]
			end
		end

		if overallTime == nil then return end

		if overallTime and addon:isNeedStart(racial, overallTime) then
			racial.time = tonumber(overallTime)
			racial.starttime = GetTime()
			CooldownFrame_SetTimer(racial.cooldown, GetTime(), overallTime, 1)
		end
	end
end

-- ---------------------------------------------------------------------------
-- Event handlers
-- ---------------------------------------------------------------------------

local function HandleADDON_LOADED(trinket)
	trinket:SetMovable(true)
	addon:SetupDrag(module, true, trinket)

	trinket:SetFrameLevel(4)

	trinket.cooldown:ClearAllPoints()
	trinket.cooldown:SetPoint("TOPLEFT", 1, -1)
	trinket.cooldown:SetPoint("BOTTOMRIGHT", -1, 1)
	
	trinket.Icon:SetTexture("Interface\\Icons\\Ability_pvp_gladiatormedallion")
end

local function HandleTEST_MODE(trinket)
	if addon.testMode then
		trinket:EnableMouse(true)
		trinket.cooldown:SetCooldown(GetTime(), random(45,120))
	else
		trinket:EnableMouse(false)
		trinket.cooldown:Hide()
	end
end

local function HandleUPDATE_SETTINGS(trinket)
	trinket:ClearAllPoints()
	trinket:SetPoint("CENTER", module.db.x, module.db.y)
	trinket:SetSize(module.db.size, module.db.size)
end

-- ---------------------------------------------------------------------------
-- Trinket handler creation
-- ---------------------------------------------------------------------------

local function CreateTrinketHandler(arenaFrame, index)
	local trinket = CreateFrame("Frame", nil, arenaFrame, "sArenaIconTemplate")
	trinket.unit = arenaFrame.unit
	trinket.time = 0
	trinket.starttime = 0
	trinket:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	trinket:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)
	trinket.COMBAT_LOG_EVENT_UNFILTERED = HandleCOMBAT_LOG_EVENT_UNFILTERED
	arenaFrame.CC = trinket
	return trinket
end

-- ---------------------------------------------------------------------------
-- Module event dispatcher
-- ---------------------------------------------------------------------------

function module:OnEvent(event, ...)
	if event == "UNIT_AURA" then
		return;
	end

	for i = 1, MAX_ARENA_ENEMIES do
		local arenaFrame = _G["ArenaEnemyFrame"..i]
		local trinket = arenaFrame.CC

		if not trinket then
			trinket = CreateTrinketHandler(arenaFrame, i)
		end
		
		trinket.cooldown:SetCooldown(0, 0)
		
		if event == "ADDON_LOADED" then
			HandleADDON_LOADED(trinket)
		elseif event == "TEST_MODE" then
			HandleTEST_MODE(trinket)
		elseif event == "UPDATE_SETTINGS" then
			HandleUPDATE_SETTINGS(trinket)
		end
	end

	if event == "ADDON_LOADED" then
		self:OnEvent("UPDATE_SETTINGS")
	end
end