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
	"incapacitate",
	"stun",
	"random_stun",
	"fear",
	"root",
	"random_root",
	"disarm",
	"silence",
	"horror",
	"opener_stun",
	"scatter",
	"cyclone",
	"mind_control",
	"charge",
	"counterattack",
}

local drTime = 18

local severityColor = {
	[1] = { 0, 1, 0, 1 },
	[2] = { 1, 1, 0, 1 },
	[3] = { 1, 0, 0, 1 }
}

drList = {
	[49203] = "incapacitate", -- Hungering Cold
	[2637]  = "incapacitate", -- Hibernate (Rank 1)
	[18657] = "incapacitate", -- Hibernate (Rank 2)
	[18658] = "incapacitate", -- Hibernate (Rank 3)
	[60210] = "incapacitate", -- Freezing Arrow Effect (Rank 1)
	[3355]  = "incapacitate", -- Freezing Trap Effect (Rank 1)
	[14308] = "incapacitate", -- Freezing Trap Effect (Rank 2)
	[14309] = "incapacitate", -- Freezing Trap Effect (Rank 3)
	[19386] = "incapacitate", -- Wyvern Sting (Rank 1)
	[24132] = "incapacitate", -- Wyvern Sting (Rank 2)
	[24133] = "incapacitate", -- Wyvern Sting (Rank 3)
	[27068] = "incapacitate", -- Wyvern Sting (Rank 4)
	[49011] = "incapacitate", -- Wyvern Sting (Rank 5)
	[49012] = "incapacitate", -- Wyvern Sting (Rank 6)
	[118]   = "incapacitate", -- Polymorph (Rank 1)
	[12824] = "incapacitate", -- Polymorph (Rank 2)
	[12825] = "incapacitate", -- Polymorph (Rank 3)
	[12826] = "incapacitate", -- Polymorph (Rank 4)
	[28271] = "incapacitate", -- Polymorph: Turtle
	[28272] = "incapacitate", -- Polymorph: Pig
	[61721] = "incapacitate", -- Polymorph: Rabbit
	[61780] = "incapacitate", -- Polymorph: Turkey
	[61305] = "incapacitate", -- Polymorph: Black Cat
	[20066] = "incapacitate", -- Repentance
	[1776]  = "incapacitate", -- Gouge
	[6770]  = "incapacitate", -- Sap (Rank 1)
	[2070]  = "incapacitate", -- Sap (Rank 2)
	[11297] = "incapacitate", -- Sap (Rank 3)
	[51724] = "incapacitate", -- Sap (Rank 4)
	[710]   = "incapacitate", -- Banish (Rank 1)
	[18647] = "incapacitate", -- Banish (Rank 2)
	[9484]  = "incapacitate", -- Shackle Undead (Rank 1)
	[9485]  = "incapacitate", -- Shackle Undead (Rank 2)
	[10955] = "incapacitate", -- Shackle Undead (Rank 3)
	[51514] = "incapacitate", -- Hex
	[13327] = "incapacitate", -- Reckless Charge (Rocket Helmet)
	[4064]  = "incapacitate", -- Rough Copper Bomb
	[4065]  = "incapacitate", -- Large Copper Bomb
	[4066]  = "incapacitate", -- Small Bronze Bomb
	[4067]  = "incapacitate", -- Big Bronze Bomb
	[4068]  = "incapacitate", -- Iron Grenade
	[12421] = "incapacitate", -- Mithril Frag Bomb
	[4069]  = "incapacitate", -- Big Iron Bomb
	[12562] = "incapacitate", -- The Big One
	[12543] = "incapacitate", -- Hi-Explosive Bomb
	[19769] = "incapacitate", -- Thorium Grenade
	[19784] = "incapacitate", -- Dark Iron Bomb
	[30216] = "incapacitate", -- Fel Iron Bomb
	[30461] = "incapacitate", -- The Bigger One
	[30217] = "incapacitate", -- Adamantite Grenade
	[67769] = "incapacitate", -- Cobalt Frag Bomb
	[67890] = "incapacitate", -- Cobalt Frag Bomb (Frag Belt)
	[54466] = "incapacitate", -- Saronite Grenade

	[47481] = "stun", -- Gnaw (Ghoul Pet)
	[5211]  = "stun", -- Bash (Rank 1)
	[6798]  = "stun", -- Bash (Rank 2)
	[8983]  = "stun", -- Bash (Rank 3)
	[22570] = "stun", -- Maim (Rank 1)
	[49802] = "stun", -- Maim (Rank 2)
	[24394] = "stun", -- Intimidation
	[50519] = "stun", -- Sonic Blast (Pet Rank 1)
	[53564] = "stun", -- Sonic Blast (Pet Rank 2)
	[53565] = "stun", -- Sonic Blast (Pet Rank 3)
	[53566] = "stun", -- Sonic Blast (Pet Rank 4)
	[53567] = "stun", -- Sonic Blast (Pet Rank 5)
	[53568] = "stun", -- Sonic Blast (Pet Rank 6)
	[50518] = "stun", -- Ravage (Pet Rank 1)
	[53558] = "stun", -- Ravage (Pet Rank 2)
	[53559] = "stun", -- Ravage (Pet Rank 3)
	[53560] = "stun", -- Ravage (Pet Rank 4)
	[53561] = "stun", -- Ravage (Pet Rank 5)
	[53562] = "stun", -- Ravage (Pet Rank 6)
	[44572] = "stun", -- Deep Freeze
	[853]   = "stun", -- Hammer of Justice (Rank 1)
	[5588]  = "stun", -- Hammer of Justice (Rank 2)
	[5589]  = "stun", -- Hammer of Justice (Rank 3)
	[10308] = "stun", -- Hammer of Justice (Rank 4)
	[2812]  = "stun", -- Holy Wrath (Rank 1)
	[10318] = "stun", -- Holy Wrath (Rank 2)
	[27139] = "stun", -- Holy Wrath (Rank 3)
	[48816] = "stun", -- Holy Wrath (Rank 4)
	[48817] = "stun", -- Holy Wrath (Rank 5)
	[408]   = "stun", -- Kidney Shot (Rank 1)
	[8643]  = "stun", -- Kidney Shot (Rank 2)
	[58861] = "stun", -- Bash (Spirit Wolves)
	[30283] = "stun", -- Shadowfury (Rank 1)
	[30413] = "stun", -- Shadowfury (Rank 2)
	[30414] = "stun", -- Shadowfury (Rank 3)
	[47846] = "stun", -- Shadowfury (Rank 4)
	[47847] = "stun", -- Shadowfury (Rank 5)
	[12809] = "stun", -- Concussion Blow
	[60995] = "stun", -- Demon Charge
	[30153] = "stun", -- Intercept (Felguard Rank 1)
	[30195] = "stun", -- Intercept (Felguard Rank 2)
	[30197] = "stun", -- Intercept (Felguard Rank 3)
	[47995] = "stun", -- Intercept (Felguard Rank 4)
	[20253] = "stun", -- Intercept Stun (Rank 1)
	[20614] = "stun", -- Intercept Stun (Rank 2)
	[20615] = "stun", -- Intercept Stun (Rank 3)
	[25273] = "stun", -- Intercept Stun (Rank 4)
	[25274] = "stun", -- Intercept Stun (Rank 5)
	[46968] = "stun", -- Shockwave
	[20549] = "stun", -- War Stomp (Racial)
	[375039] = "stun",
	[374994] = "stun",
	[375010] = "stun",

	[16922]   = "random_stun",  -- Celestial Focus (Starfire Stun)
	[28445]   = "random_stun",  -- Improved Concussive Shot
	[12355]   = "random_stun",  -- Impact
	[20170]   = "random_stun",  -- Seal of Justice Stun
	[39796]   = "random_stun",  -- Stoneclaw Stun
	[12798]   = "random_stun",  -- Revenge Stun
	[5530]    = "random_stun",  -- Mace Stun Effect (Mace Specialization)
	[15283]   = "random_stun",  -- Stunning Blow (Weapon Proc)
	[56]      = "random_stun",  -- Stun (Weapon Proc)
	[34510]   = "random_stun",  -- Stormherald/Deep Thunder (Weapon Proc)

	[1513]  = "fear", -- Scare Beast (Rank 1)
	[14326] = "fear", -- Scare Beast (Rank 2)
	[14327] = "fear", -- Scare Beast (Rank 3)
	[10326] = "fear", -- Turn Evil
	[8122]  = "fear", -- Psychic Scream (Rank 1)
	[8124]  = "fear", -- Psychic Scream (Rank 2)
	[10888] = "fear", -- Psychic Scream (Rank 3)
	[10890] = "fear", -- Psychic Scream (Rank 4)
	[2094]  = "fear", -- Blind
	[5782]  = "fear", -- Fear (Rank 1)
	[6213]  = "fear", -- Fear (Rank 2)
	[6215]  = "fear", -- Fear (Rank 3)
	[6358]  = "fear", -- Seduction (Succubus)
	[5484]  = "fear", -- Howl of Terror (Rank 1)
	[17928] = "fear", -- Howl of Terror (Rank 2)
	[5246]  = "fear", -- Intimidating Shout
	[5134]  = "fear", -- Flash Bomb Fear (Item)

	[339]   = "root", -- Entangling Roots (Rank 1)
	[1062]  = "root", -- Entangling Roots (Rank 2)
	[5195]  = "root", -- Entangling Roots (Rank 3)
	[5196]  = "root", -- Entangling Roots (Rank 4)
	[9852]  = "root", -- Entangling Roots (Rank 5)
	[9853]  = "root", -- Entangling Roots (Rank 6)
	[26989] = "root", -- Entangling Roots (Rank 7)
	[53308] = "root", -- Entangling Roots (Rank 8)
	[19975] = "root", -- Nature's Grasp (Rank 1)
	[19974] = "root", -- Nature's Grasp (Rank 2)
	[19973] = "root", -- Nature's Grasp (Rank 3)
	[19972] = "root", -- Nature's Grasp (Rank 4)
	[19971] = "root", -- Nature's Grasp (Rank 5)
	[19970] = "root", -- Nature's Grasp (Rank 6)
	[27010] = "root", -- Nature's Grasp (Rank 7)
	[53312] = "root", -- Nature's Grasp (Rank 8)
	[50245] = "root", -- Pin (Rank 1)
	[53544] = "root", -- Pin (Rank 2)
	[53545] = "root", -- Pin (Rank 3)
	[53546] = "root", -- Pin (Rank 4)
	[53547] = "root", -- Pin (Rank 5)
	[53548] = "root", -- Pin (Rank 6)
	[33395] = "root", -- Freeze (Water Elemental)
	[122]   = "root", -- Frost Nova (Rank 1)
	[865]   = "root", -- Frost Nova (Rank 2)
	[6131]  = "root", -- Frost Nova (Rank 3)
	[10230] = "root", -- Frost Nova (Rank 4)
	[27088] = "root", -- Frost Nova (Rank 5)
	[42917] = "root", -- Frost Nova (Rank 6)
	[39965] = "root", -- Frost Grenade (Item)
	[63685] = "root", -- Freeze (Frost Shock)
	[55536] = "root", -- Frostweave Net (Item)

	[12494] = "random_root",         -- Frostbite
	[55080] = "random_root",         -- Shattered Barrier
	[58373] = "random_root",         -- Glyph of Hamstring
	[23694] = "random_root",         -- Improved Hamstring
	[47168] = "random_root",         -- Improved Wing Clip
	[19185] = "random_root",         -- Entrapment

	[53359] = "disarm", -- Chimera Shot (Scorpid)
	[50541] = "disarm", -- Snatch (Rank 1)
	[53537] = "disarm", -- Snatch (Rank 2)
	[53538] = "disarm", -- Snatch (Rank 3)
	[53540] = "disarm", -- Snatch (Rank 4)
	[53542] = "disarm", -- Snatch (Rank 5)
	[53543] = "disarm", -- Snatch (Rank 6)
	[64346] = "disarm", -- Fiery Payback
	[64058] = "disarm", -- Psychic Horror Disarm Effect
	[51722] = "disarm", -- Dismantle
	[676]   = "disarm", -- Disarm

	[47476] = "silence", -- Strangulate
	[34490] = "silence", -- Silencing Shot
	[35334] = "silence", -- Nether Shock 1
	[44957] = "silence", -- Nether Shock 2
	[18469] = "silence", -- Silenced - Improved Counterspell (Rank 1)
	[55021] = "silence", -- Silenced - Improved Counterspell (Rank 2)
	[63529] = "silence", -- Silenced - Shield of the Templar
	[15487] = "silence", -- Silence
	[1330]  = "silence", -- Garrote - Silence
	[18425] = "silence", -- Silenced - Improved Kick
	[24259] = "silence", -- Spell Lock
	[43523] = "silence", -- Unstable Affliction 1
	[31117] = "silence", -- Unstable Affliction 2
	[18498] = "silence", -- Silenced - Gag Order (Shield Slam)
	[74347] = "silence", -- Silenced - Gag Order (Heroic Throw?)
	[50613] = "silence", -- Arcane Torrent (Racial, Runic Power)
	[28730] = "silence", -- Arcane Torrent (Racial, Mana)
	[25046] = "silence", -- Arcane Torrent (Racial, Energy)
	[375001] = "silence", -- Arcane Torrent

	[64044] = "horror", -- Psychic Horror
	[6789]  = "horror", -- Death Coil (Rank 1)
	[17925] = "horror", -- Death Coil (Rank 2)
	[17926] = "horror", -- Death Coil (Rank 3)
	[27223] = "horror", -- Death Coil (Rank 4)
	[47859] = "horror", -- Death Coil (Rank 5)
	[47860] = "horror", -- Death Coil (Rank 6)

	[1833]  = "opener_stun", -- Cheap Shot
	[9005]  = "opener_stun", -- Pounce (Rank 1)
	[9823]  = "opener_stun", -- Pounce (Rank 2)
	[9827]  = "opener_stun", -- Pounce (Rank 3)
	[27006] = "opener_stun", -- Pounce (Rank 4)
	[49803] = "opener_stun", -- Pounce (Rank 5)

	[31661] = "scatter", -- Dragon's Breath (Rank 1)
	[33041] = "scatter", -- Dragon's Breath (Rank 2)
	[33042] = "scatter", -- Dragon's Breath (Rank 3)
	[33043] = "scatter", -- Dragon's Breath (Rank 4)
	[42949] = "scatter", -- Dragon's Breath (Rank 5)
	[42950] = "scatter", -- Dragon's Breath (Rank 6)
	[19503] = "scatter", -- Scatter Shot

	[33786] = "cyclone",        -- Cyclone
	[605]   = "mind_control",   -- Mind Control
	[13181] = "mind_control",   -- Gnomish Mind Control Cap
	[67799] = "mind_control",   -- Mind Amplification Dish
	[7922]  = "charge",         -- Charge Stun
	[19306] = "counterattack",  -- Counterattack 1
	[20909] = "counterattack",  -- Counterattack 2
	[20910] = "counterattack",  -- Counterattack 3
	[27067] = "counterattack",  -- Counterattack 4
	[48998] = "counterattack",  -- Counterattack 5
	[48999] = "counterattack",  -- Counterattack 6
}

local function CreateCustomBorder(frame)
	local border = CreateFrame("Frame", nil, frame)
	border:SetAllPoints(frame)
	border:SetFrameLevel(frame:GetFrameLevel() + 1)

	local t = border:CreateTexture(nil, "OVERLAY")
	t:SetTexture(1, 1, 1, 1)
	t:SetPoint("TOPLEFT", border, "TOPLEFT", 0, 0)
	t:SetPoint("TOPRIGHT", border, "TOPRIGHT", 0, 0)
	t:SetHeight(2)

	local b = border:CreateTexture(nil, "OVERLAY")
	b:SetTexture(1, 1, 1, 1)
	b:SetPoint("BOTTOMLEFT", border, "BOTTOMLEFT", 0, 0)
	b:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 0, 0)
	b:SetHeight(2)

	local l = border:CreateTexture(nil, "OVERLAY")
	l:SetTexture(1, 1, 1, 1)
	l:SetPoint("TOPLEFT", border, "TOPLEFT", 0, 0)
	l:SetPoint("BOTTOMLEFT", border, "BOTTOMLEFT", 0, 0)
	l:SetWidth(2)

	local r = border:CreateTexture(nil, "OVERLAY")
	r:SetTexture(1, 1, 1, 1)
	r:SetPoint("TOPRIGHT", border, "TOPRIGHT", 0, 0)
	r:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 0, 0)
	r:SetWidth(2)

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
	local spacing = module.db and module.db.spacing or 3
	local dir = module.db and module.db.growthDirection or "LEFT"

	local visibleFrames = {}
	for i = 1, #drCategories do
		local cat = drCategories[i]
		local frame = drHandler[cat]
		if frame and frame:IsShown() then
			table.insert(visibleFrames, frame)
		end
	end

	if #visibleFrames == 0 then return end

	local prevFrame = drHandler
	for i = 1, #visibleFrames do
		local frame = visibleFrames[i]
		frame:ClearAllPoints()
		if dir == "LEFT" then
			frame:SetPoint("RIGHT", prevFrame, "LEFT", -spacing, 0)
		else
			frame:SetPoint("LEFT", prevFrame, "RIGHT", spacing, 0)
		end
		prevFrame = frame
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
	
	local _, event, sourceGUID, sourceName, _, destGUID, destName, _, spellId, spellName = ...

	if not destGUID or UnitGUID(self.unit) ~= destGUID then return end
	
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
		
		if frame.CustomBorder and severityColor[frame.severity] then
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
		
		if frame.CustomBorder and severityColor[frame.severity] then
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

local function SetIconZoomed(texture)
	if not texture then return end
	texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
end

local function CreateDRHandler(arenaFrame, index)
	local drHandler = CreateFrame("Frame", nil, arenaFrame, "sArenaIconTemplate")
	drHandler.unit = "arena"..index
	drHandler.severity = 1
	drHandler.time = 0
	drHandler.starttime = 0
	drHandler.CustomBorder = CreateCustomBorder(drHandler)
	drHandler.cooldown:ClearAllPoints()
	drHandler.cooldown:SetAllPoints(drHandler)
	drHandler.cooldown:Hide()
	drHandler:Show()
	drHandler.Icon:SetTexture(nil)
	drHandler.Icon:SetAllPoints(drHandler)
	SetIconZoomed(drHandler.Icon)
	if drHandler.texture then
		drHandler.texture:SetAllPoints(drHandler)
	end
	if drHandler.CustomBorder then drHandler.CustomBorder:Hide() end

	for c = 1, #drCategories do
		local cat = drCategories[c]
		local f = CreateFrame("Frame", nil, drHandler, "sArenaIconTemplate")
		f:Hide()
		f.severity = 1
		f.time = 0
		f.starttime = 0
		f.CustomBorder = CreateCustomBorder(f)
		
		f.cooldown:ClearAllPoints()
		f.cooldown:SetAllPoints(f)
		
		f.Icon:SetAllPoints(f)
		SetIconZoomed(f.Icon)
		if f.texture then
			f.texture:SetAllPoints(f)
		end
		
		f:SetScript("OnUpdate", function(self, elapsed)
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
		
		if not drHandler then
			drHandler = CreateDRHandler(arenaFrame, i)
		end

		if event == "ADDON_LOADED" then
			local firstCat = drHandler[drCategories[1]]
			if firstCat then
				firstCat:SetMovable(true)
				if addon.SetupDrag then
					addon:SetupDrag(self, true, firstCat, drHandler)
				end
			end
			drHandler:SetFrameLevel(7)
		
		elseif event == "TEST_MODE" then
			drHandler.Icon:SetTexture(nil)
			if drHandler.CustomBorder then drHandler.CustomBorder:Hide() end
			ResetDR(drHandler)

			if addon.testMode and (not module.db or module.db.enable) then
				local categorySpells = {}
				for spellId, cat in pairs(drList) do
					if not categorySpells[cat] then
						categorySpells[cat] = {}
					end
					table.insert(categorySpells[cat], spellId)
				end

				local numCategories = math.random(1, 5)
				local shuffled = {}
				for c = 1, #drCategories do
					shuffled[c] = drCategories[c]
				end
				for c = #shuffled, 2, -1 do
					local j = math.random(1, c)
					shuffled[c], shuffled[j] = shuffled[j], shuffled[c]
				end

				for c = 1, numCategories do
					local cat = shuffled[c]
					local f = drHandler[cat]
					if f and categorySpells[cat] and #categorySpells[cat] > 0 then
						local randomSpellId = categorySpells[cat][math.random(1, #categorySpells[cat])]
						local _, _, texture = GetSpellInfo(randomSpellId)
						
						f.Icon:SetTexture(texture or "Interface\\Icons\\inv_misc_questionmark")
						f.severity = math.random(1, 3)
						
						if f.CustomBorder and severityColor[f.severity] then
							f.CustomBorder:SetVertexColor(unpack(severityColor[f.severity]))
							f.CustomBorder:Show()
						end
						
						f:Show()
						local timer = math.random(15, 25)
						f.time = timer
						f.starttime = GetTime()
						CooldownFrame_SetTimer(f.cooldown, GetTime(), timer, 1)
					end
				end
				UpdateDRPositions(drHandler)
			end

		elseif event == "UPDATE_SETTINGS" then
			if module.db and not module.db.enable then
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