local addonName, addon = ...
local module = addon:CreateModule("Diminishing Returns")

module.defaultSettings = {
	enable = true,
	x = -128,
	y = -3,
	size = 26,
	spacing = 3,
	growthDirection = "LEFT",
}

module.optionsTable = {
	enable = {
		order = 1,
		type = "toggle",
		name = "Enable",
		set = module.UpdateSettings,
	},
	growthDirection = {
		order = 2,
		type = "select",
		name = "Growth Direction",
		values = {
			["LEFT"] = "Left",
			["RIGHT"] = "Right",
		},
		set = module.UpdateSettings,
	},
	size = {
		order = 3,
		type = "range",
		name = "Size",
		min = 10,
		max = 128,
		step = 1,
		set = module.UpdateSettings,
	},
	spacing = {
		order = 4,
		type = "range",
		name = "Spacing",
		min = 0,
		max = 20,
		step = 1,
		set = module.UpdateSettings,
	}
}

local drCategories = {
	"Incapacitate",
	"Stun",
	"RandomStun",
	"Fear",
	"Root",
	"RandomRoot",
	"Disarm",
	"Silence",
	"Horror",
	"OpenerStun",
	"Scatter",
	"Cyclone",
	"MindControl",
	"Charge",
	"Counterattack",
}

local drTime = 18

local severityColor = {
	[1] = { 0, 1, 0, 1 },
	[2] = { 1, 1, 0, 1 },
	[3] = { 1, 0, 0, 1 }
}

drList = {
	[49203] = "Incapacitate", 	-- Hungering Cold
	[2637]  = "Incapacitate", 	-- Hibernate
	[3355]  = "Incapacitate", 	-- Freezing Trap Effect
	[19386] = "Incapacitate", 	-- Wyvern Sting
	[118]   = "Incapacitate", 	-- Polymorph
	[28271] = "Incapacitate", 	-- Polymorph: Turtle
	[28272] = "Incapacitate", 	-- Polymorph: Pig
	[61721] = "Incapacitate", 	-- Polymorph: Rabbit
	[61780] = "Incapacitate", 	-- Polymorph: Turkey
	[61305] = "Incapacitate", 	-- Polymorph: Black Cat
	[20066] = "Incapacitate", 	-- Repentance
	[1776]  = "Incapacitate", 	-- Gouge
	[6770]  = "Incapacitate", 	-- Sap
	[710]   = "Incapacitate", 	-- Banish
	[9484]  = "Incapacitate", 	-- Shackle Undead
	[51514] = "Incapacitate", 	-- Hex
	[13327] = "Incapacitate", 	-- Reckless Charge (Rocket Helmet)
	[4064]  = "Incapacitate", 	-- Rough Copper Bomb
	[4065]  = "Incapacitate", 	-- Large Copper Bomb
	[4066]  = "Incapacitate", 	-- Small Bronze Bomb
	[4067]  = "Incapacitate", 	-- Big Bronze Bomb
	[4068]  = "Incapacitate", 	-- Iron Grenade
	[12421] = "Incapacitate", 	-- Mithril Frag Bomb
	[4069]  = "Incapacitate", 	-- Big Iron Bomb
	[12562] = "Incapacitate", 	-- The Big One
	[12543] = "Incapacitate", 	-- Hi-Explosive Bomb
	[19769] = "Incapacitate", 	-- Thorium Grenade
	[19784] = "Incapacitate", 	-- Dark Iron Bomb
	[30216] = "Incapacitate", 	-- Fel Iron Bomb
	[30461] = "Incapacitate", 	-- The Bigger One
	[30217] = "Incapacitate", 	-- Adamantite Grenade

	[47481] = "Stun",      -- Gnaw (Ghoul Pet)
	[5211]  = "Stun",      -- Bash
	[22570] = "Stun",      -- Maim
	[24394] = "Stun",      -- Intimidation
	[50519] = "Stun",      -- Sonic Blast
	[50518] = "Stun",      -- Ravage
	[44572] = "Stun",      -- Deep Freeze
	[853]   = "Stun",      -- Hammer of Justice
	[2812]  = "Stun",      -- Holy Wrath
	[408]   = "Stun",      -- Kidney Shot
	[1833]  = "Stun", 	   -- Cheap Shot
	[58861] = "Stun",      -- Bash (Spirit Wolves)
	[30283] = "Stun",      -- Shadowfury
	[12809] = "Stun",      -- Concussion Blow
	[60995] = "Stun",      -- Demon Charge
	[30153] = "Stun",      -- Pursuit
	[20253] = "Stun",      -- Intercept Stun
	[46968] = "Stun",      -- Shockwave
	[20549] = "Stun",      -- War Stomp (Racial)
	[85388] = "Stun",      -- Throwdown
	[90337] = "Stun",      -- Bad Manner (Hunter Pet Stun)
	[91800] = "Stun",	   -- Gnaw (DK Pet Stun)

	[16922] = "RandomStun", 	-- Celestial Focus (Starfire Stun)
	[28445] = "RandomStun", 	-- Improved Concussive Shot
	[12355] = "RandomStun", 	-- Impact
	[20170] = "RandomStun", 	-- Seal of Justice Stun
	[39796] = "RandomStun", 	-- Stoneclaw Stun
	[12798] = "RandomStun", 	-- Revenge Stun
	[5530]  = "RandomStun", 	-- Mace Stun Effect (Mace Specialization)
	[15283] = "RandomStun", 	-- Stunning Blow (Weapon Proc)
	[56]    = "RandomStun", 	-- Stun (Weapon Proc)
	[34510] = "RandomStun", 	-- Stormherald/Deep Thunder (Weapon Proc)

	[1513]  = "Fear",      -- Scare Beast
	[10326] = "Fear",      -- Turn Evil
	[8122]  = "Fear",      -- Psychic Scream
	[2094]  = "Fear",      -- Blind
	[5782]  = "Fear",      -- Fear
	[6358]  = "Fear",      -- Seduction (Succubus)
	[5484]  = "Fear",      -- Howl of Terror
	[5246]  = "Fear",      -- Intimidating Shout
	[5134]  = "Fear",      -- Flash Bomb Fear (Item)

	[339]   = "Root",      -- Entangling Roots
	[19975] = "Root",      -- Nature's Grasp
	[50245] = "Root",      -- Pin
	[33395] = "Root",      -- Freeze (Water Elemental)
	[122]   = "Root",      -- Frost Nova
	[39965] = "Root",      -- Frost Grenade (Item)
	[63685] = "Root",      -- Freeze (Frost Shock)

	[12494] = "RandomRoot", -- Frostbite
	[55080] = "RandomRoot", -- Shattered Barrier
	[58373] = "RandomRoot", -- Glyph of Hamstring
	[23694] = "RandomRoot", -- Improved Hamstring
	[47168] = "RandomRoot", -- Improved Wing Clip
	[19185] = "RandomRoot", -- Entrapment

	[53359] = "Disarm",    -- Chimera Shot (Scorpid)
	[50541] = "Disarm",    -- Clench
	[64058] = "Disarm",    -- Psychic Horror Disarm Effect
	[51722] = "Disarm",    -- Dismantle
	[676]   = "Disarm",    -- Disarm

	[47476] = "Silence",   -- Strangulate
	[34490] = "Silence",   -- Silencing Shot
	[35334] = "Silence",   -- Nether Shock (Rank 1)
	[44957] = "Silence",   -- Nether Shock (Rank 2)
	[18469] = "Silence",   -- Silenced - Improved Counterspell (Rank 1)
	[55021] = "Silence",   -- Silenced - Improved Counterspell (Rank 2)
	[15487] = "Silence",   -- Silence
	[1330]  = "Silence",   -- Garrote - Silence
	[18425] = "Silence",   -- Silenced - Improved Kick
	[24259] = "Silence",   -- Spell Lock
	[43523] = "Silence",   -- Unstable Affliction 1
	[31117] = "Silence",   -- Unstable Affliction 2
	[18498] = "Silence",   -- Silenced - Gag Order (Shield Slam)
	[50613] = "Silence",   -- Arcane Torrent (Racial, Runic Power)
	[28730] = "Silence",   -- Arcane Torrent (Racial, Mana)
	[25046] = "Silence",   -- Arcane Torrent (Racial, Energy)

	[64044] = "Horror",    -- Psychic Horror
	[6789]  = "Horror",    -- Death Coil

	[9005]  = "OpenerStun", -- Pounce

	[31661] = "Scatter",   -- Dragon's Breath
	[19503] = "Scatter",   -- Scatter Shot

	-- Spells that DR with itself only
	[33786] = "Cyclone",    	-- Cyclone
	[605]   = "MindControl", 	-- Mind Control
	[13181] = "MindControl", 	-- Gnomish Mind Control Cap
	[7922]  = "Charge",     	-- Charge Stun
	[19306] = "Counterattack", 	-- Counterattack
}

local function CreateCustomBorder(frame)
	local border = CreateFrame("Frame", nil, frame)
	border:SetAllPoints(frame)
	border:SetFrameLevel(frame:GetFrameLevel() + 2)

	local t = border:CreateTexture(nil, "OVERLAY")
	t:SetTexture(1, 1, 1, 1)
	t:SetPoint("TOPLEFT", border, "TOPLEFT", 0, 0)
	t:SetPoint("TOPRIGHT", border, "TOPRIGHT", 0, 0)
	t:SetHeight(1)

	local b = border:CreateTexture(nil, "OVERLAY")
	b:SetTexture(1, 1, 1, 1)
	b:SetPoint("BOTTOMLEFT", border, "BOTTOMLEFT", 0, 0)
	b:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 0, 0)
	b:SetHeight(1)

	local l = border:CreateTexture(nil, "OVERLAY")
	l:SetTexture(1, 1, 1, 1)
	l:SetPoint("TOPLEFT", border, "TOPLEFT", 0, 0)
	l:SetPoint("BOTTOMLEFT", border, "BOTTOMLEFT", 0, 0)
	l:SetWidth(1)

	local r = border:CreateTexture(nil, "OVERLAY")
	r:SetTexture(1, 1, 1, 1)
	r:SetPoint("TOPRIGHT", border, "TOPRIGHT", 0, 0)
	r:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 0, 0)
	r:SetWidth(1)

	border.SetVertexColor = function(self, r_val, g, b_val, a)
		t:SetVertexColor(r_val, g, b_val, a)
		b:SetVertexColor(r_val, g, b_val, a)
		l:SetVertexColor(r_val, g, b_val, a)
		r:SetVertexColor(r_val, g, b_val, a)
	end

	border.Show = function(self) t:Show() b:Show() l:Show() r:Show() end
	border.Hide = function(self) t:Hide() b:Hide() l:Hide() r:Hide() end

	return border
end

local function UpdateDRPositions(drHandler)
	local prevFrame = drHandler
	local spacing = module.db and module.db.spacing or 3
	local dir = module.db and module.db.growthDirection or "LEFT"

	local point, relativePoint, mult
	if dir == "LEFT" then
		point, relativePoint, mult = "RIGHT", "LEFT", -1
	else
		point, relativePoint, mult = "LEFT", "RIGHT", 1
	end

	for i = 1, #drCategories do
		local cat = drCategories[i]
		local frame = drHandler[cat]
		
		if frame and frame:IsShown() then
			frame:ClearAllPoints()
			frame:SetPoint(point, prevFrame, relativePoint, spacing * mult, 0)
			prevFrame = frame
		end
	end
end

local function ResetDR(drHandler)
	for i = 1, #drCategories do
		local cat = drCategories[i]
		local frame = drHandler[cat]
		if frame then
			frame.time = 0
			frame.starttime = 0
			frame.cooldown:Hide()
			frame.severity = 1
			if frame.CustomBorder then frame.CustomBorder:Hide() end
			frame:Hide()
		end
	end
end

local function DR_COMBAT_LOG_EVENT_UNFILTERED(self, ...)
	if module.db and not module.db.enable then return end
	
	-- Распаковка для 3.3.5
	local _, event, sourceGUID, sourceName, _, destGUID, destName, _, spellId, spellName = ...

	-- Проверка таргета
	if UnitGUID(self.unit) ~= destGUID then return end
	
	local category = drList[spellId]
	if not category then return end

	local frame = self[category]
	if not frame then return end

	if event == "SPELL_AURA_APPLIED" then
		frame.cooldown:Hide()
		frame:Hide()
		frame.severity = math.min(frame.severity + 1, 3)
		UpdateDRPositions(self)

	elseif event == "SPELL_AURA_REMOVED" then
		local _, _, texture = GetSpellInfo(spellId)
		frame.Icon:SetTexture(texture or "Interface\\Icons\\inv_misc_questionmark")
		
		if frame.CustomBorder and severityColor and severityColor[frame.severity] then
			frame.CustomBorder:SetVertexColor(unpack(severityColor[frame.severity]))
			frame.CustomBorder:Show()
		end

		frame:Show()
		frame.time = tonumber(drTime) or 18
		frame.starttime = GetTime()
		
		CooldownFrame_SetTimer(frame.cooldown, GetTime(), frame.time, 1)
		UpdateDRPositions(self)

	elseif event == "SPELL_AURA_REFRESH" then
		local _, _, texture = GetSpellInfo(spellId)
		frame.Icon:SetTexture(texture or "Interface\\Icons\\inv_misc_questionmark")
		
		if frame.CustomBorder and severityColor and severityColor[frame.severity] then
			frame.CustomBorder:SetVertexColor(unpack(severityColor[frame.severity]))
			frame.CustomBorder:Show()
		end

		frame:Show()
		frame.time = tonumber(drTime) or 18
		frame.starttime = GetTime()
		CooldownFrame_SetTimer(frame.cooldown, GetTime(), frame.time, 1)

		frame.severity = math.min(frame.severity + 1, 3)
		UpdateDRPositions(self)
	end
end

-- Вынесенная функция создания DR-обработчика для одного фрейма арены
local function CreateDRHandler(arenaFrame, index)
	local drHandler = CreateFrame("Frame", nil, arenaFrame, "sArenaIconTemplate")
	drHandler.unit = "arena"..index
	drHandler.severity = 1
	drHandler.time = 0
	drHandler.starttime = 0
	drHandler.CustomBorder = CreateCustomBorder and CreateCustomBorder(drHandler) or nil
	drHandler.cooldown:ClearAllPoints()
	drHandler.cooldown:SetPoint("TOPLEFT", 1, -1)
	drHandler.cooldown:SetPoint("BOTTOMRIGHT", -1, 1)
	drHandler.cooldown:Hide()
	drHandler:Show()
	drHandler.Icon:SetTexture(nil)
	if drHandler.CustomBorder then drHandler.CustomBorder:Hide() end

	for c = 1, #drCategories do
		local cat = drCategories[c]
		local f = CreateFrame("Frame", nil, drHandler, "sArenaIconTemplate")
		f:Hide()
		f.severity = 1
		f.time = 0
		f.starttime = 0
		f.CustomBorder = CreateCustomBorder and CreateCustomBorder(f) or nil
		
		f.cooldown:ClearAllPoints()
		f.cooldown:SetPoint("TOPLEFT", 1, -1)
		f.cooldown:SetPoint("BOTTOMRIGHT", -1, 1)
		
		f:SetScript("OnUpdate", function(self, elapsed)
			if addon.testMode then return end
			
			if self.starttime and self.time and self.time > 0 then
				if GetTime() >= (self.starttime + self.time) then
					self.time = 0
					self.starttime = 0
					self.severity = 1
					self:Hide()
					if self.CustomBorder then self.CustomBorder:Hide() end
					UpdateDRPositions(self:GetParent())
				end
			end
		end)

		drHandler[cat] = f
	end

	drHandler.COMBAT_LOG_EVENT_UNFILTERED = DR_COMBAT_LOG_EVENT_UNFILTERED
	drHandler:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
	-- Безопасный вызов (защита от ошибок nil)
	drHandler:SetScript("OnEvent", function(self, event, ...) 
		if self[event] then 
			return self[event](self, ...) 
		end 
	end)
	
	arenaFrame.sArenaDRHandler = drHandler
	return drHandler
end

function module:OnEvent(event, ...)
	for i = 1, (MAX_ARENA_ENEMIES or 5) do
		local arenaFrame = _G["ArenaEnemyFrame"..i]
		if not arenaFrame then break end

		local drHandler = arenaFrame.sArenaDRHandler
		
		-- Создаём DR-обработчик, если его ещё нет (при ADDON_LOADED или PLAYER_ENTERING_WORLD)
		if not drHandler then
			drHandler = CreateDRHandler(arenaFrame, i)
		end

		if event == "ADDON_LOADED" then
			drHandler:SetMovable(true)
			if addon.SetupDrag then 
				addon:SetupDrag(self, true, drHandler)
			 end
			drHandler:SetFrameLevel(7)
		
		elseif event == "TEST_MODE" then
			if addon.testMode and (not module.db or module.db.enable) then
				drHandler:EnableMouse(true)
				drHandler.Icon:SetTexture("Interface\\Icons\\Spell_Nature_Invisibilty")
				drHandler.severity = 1
				if drHandler.CustomBorder and severityColor and severityColor[1] then
					drHandler.CustomBorder:SetVertexColor(unpack(severityColor[1]))
					drHandler.CustomBorder:Show()
				end

				local testSpells = { 118, 15487 }
				ResetDR(drHandler)

				for c = 1, 2 do
					local cat = drCategories[c + 1]
					local f = drHandler[cat]
					if f then
						f:EnableMouse(false)
						
						local _, _, texture = GetSpellInfo(testSpells[c])
						f.Icon:SetTexture(texture)
						f.severity = c + 1
						
						if f.CustomBorder and severityColor and severityColor[c + 1] then 
							f.CustomBorder:SetVertexColor(unpack(severityColor[c + 1])) 
							f.CustomBorder:Show()
						end
						
						f:Show()
						f.time = 60
						f.starttime = GetTime()
						CooldownFrame_SetTimer(f.cooldown, GetTime(), 60, 1)
					end
				end
				UpdateDRPositions(drHandler)
			else
				drHandler:EnableMouse(false)
				drHandler.Icon:SetTexture(nil)
				if drHandler.CustomBorder then drHandler.CustomBorder:Hide() end
				ResetDR(drHandler)
			end

		elseif event == "UPDATE_SETTINGS" then
			if module.db and not module.db.enable then
				drHandler:EnableMouse(false)
				ResetDR(drHandler)
			else
				drHandler:ClearAllPoints()
				if module.db then
					drHandler:SetPoint("CENTER", arenaFrame, "CENTER", module.db.x, module.db.y)
					drHandler:SetSize(module.db.size, module.db.size)
				end
				
				for c = 1, #drCategories do
					local cat = drCategories[c]
					if drHandler[cat] and module.db then
						drHandler[cat]:SetSize(module.db.size, module.db.size)
					end
				end
				
				if addon.testMode then
					drHandler.Icon:SetTexture("Interface\\Icons\\Spell_Nature_Invisibilty")
					if drHandler.CustomBorder and severityColor and severityColor[1] then
						drHandler.CustomBorder:SetVertexColor(unpack(severityColor[1]))
						drHandler.CustomBorder:Show()
					end
				end
				UpdateDRPositions(drHandler)
			end

		elseif event == "PLAYER_ENTERING_WORLD" then
			ResetDR(drHandler)
		end
	end

	if event == "ADDON_LOADED" then
		self:OnEvent("UPDATE_SETTINGS")
	end
end
