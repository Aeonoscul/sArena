local addonName, addon = ...
local module = addon:CreateModule("Frame Styles")
local Media = LibStub("LibSharedMedia-3.0")

module.defaultSettings = {
    frameStyle = "Blizz Arena Default",
    mirroredFrames = false,
    barTexture = "Interface\\AddOns\\sArena\\Media\\statusbar",
    width = 150,
    height = 32,
    healthBarHeight = 18,
    powerBarHeight = 8,
    healthBarFontSize = 8,
    powerBarFontSize = 8
}

module.optionsTable = {
    frameStyle = {
        order = 1,
        type = "select",
        name = "Style",
        values = addon:GetLayouts(),
        set = module.UpdateSettings
    },
    barTexture = {
        order = 2,
        type = "select",
        name = "Bar Textures",
        values = function()
            local list = {}
            local mediaList = Media:List("statusbar")
            for _, name in ipairs(mediaList) do
                list[Media:Fetch("statusbar", name)] = name
            end
            return list
        end,
        set = module.UpdateSettings
    },
    width = {
        order = 3,
        name = "Width (for custom Styles)",
        type = "range",
        min = 40,
        max = 400,
        step = 1,
        set = module.UpdateSettings
    },
    break1 = {
        order = 4,
        type = "header",
        name = ""
    },
    healthBarHeight = {
        order = 6,
        name = "Health Bar Height (for custom Styles)",
        type = "range",
        min = 1,
        max = 50,
        step = 1,
        set = module.UpdateSettings
    },
    powerBarHeight = {
        order = 6,
        name = "Power Bar Height (for custom Styles)",
        type = "range",
        min = 1,
        max = 50,
        step = 1,
        set = module.UpdateSettings
    },
    healthBarFontSize = {
        order = 7,
        name = "Health Bar Font Size",
        type = "range",
        min = 0,
        max = 50,
        step = 1,
        set = module.UpdateSettings
    },
    powerBarFontSize = {
        order = 8,
        name = "Power Bar Font Size",
        type = "range",
        min = 0,
        max = 50,
        step = 1,
        set = module.UpdateSettings
    },
    mirroredFrames = {
        order = 9,
        type = "toggle",
        name = "Mirrored Frames",
        set = module.UpdateSettings
    }
}

local UnitClass = UnitClass
local unpack = unpack
local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS

-- Выносим общую функцию защиты полос наверх
local function ProtectBar(bar, barTexture)
    if not bar then return end

    -- 1. Ставим твою текстуру
    bar:SetStatusBarTexture(barTexture)
    
    -- 2. Убиваем близовскую нарезку координат
    local tex = bar:GetStatusBarTexture()
    if tex then
        if not tex.Hooked then
            tex:SetTexCoord(0, 1, 0, 1)
            tex.SetTexCoord = function() end 
            tex.Hooked = true
        else
            tex:SetTexCoord(0, 1, 0, 1)
        end
    end
end

function module:OnEvent(event, ...)
    if event == "UNIT_AURA" then
        return;
    end

    for i = 1, MAX_ARENA_ENEMIES do
        local arenaFrame = _G["ArenaEnemyFrame" .. i]
        if event == "ADDON_LOADED" then
            arenaFrame.texture = _G["ArenaEnemyFrame" .. i .. "Texture"]
            arenaFrame.CastingBar = _G["ArenaEnemyFrame" .. i .. "CastingBar"]
            arenaFrame.backgroundFrame = _G["ArenaEnemyFrame" .. i .. "Background"]
            arenaFrame.petTexture = _G["ArenaEnemyFrame" .. i .. "PetFrameTexture"]

        elseif event == "UPDATE_SETTINGS" then
            local _layout = addon.layouts[self.db.frameStyle]

            if _layout then
                _layout:SetFrameStyle(arenaFrame, self.db)
            end
            
            -- Применяем объединенную защиту ко всем полосам игрока
            ProtectBar(arenaFrame.healthbar, self.db.barTexture)
            ProtectBar(arenaFrame.manabar, self.db.barTexture)
            ProtectBar(arenaFrame.CastingBar, self.db.barTexture)

            local font, _, flags = arenaFrame.healthbar.TextString:GetFont()

            if self.db.healthBarFontSize > 0 then
                arenaFrame.healthbar.TextString:SetFont(font, self.db.healthBarFontSize, flags)
                arenaFrame.healthbar.TextString:Show()
            else
                arenaFrame.healthbar.TextString:Hide()
            end

            if self.db.powerBarFontSize > 0 then
                arenaFrame.manabar.TextString:SetFont(font, self.db.powerBarFontSize, flags)
                arenaFrame.manabar.TextString:Show()
            else
                arenaFrame.manabar.TextString:Hide()
            end
        end
    end

    if event == "UPDATE_SETTINGS" then
        -- reshape class portrait during test mode
        if addon.testMode and addon.modules["Unit Frames"] then
            addon.modules["Unit Frames"]:OnEvent("TEST_MODE")
        end
    elseif event == "ADDON_LOADED" then
        self:OnEvent("UPDATE_SETTINGS")
    end
end


for i = 1, MAX_ARENA_ENEMIES do
    local arenaFrame = _G["ArenaEnemyFrame" .. i]

    arenaFrame.healthbar.TextString:ClearAllPoints()
    arenaFrame.healthbar.TextString:SetPoint("CENTER", arenaFrame.healthbar)
    arenaFrame.manabar.TextString:ClearAllPoints()
    arenaFrame.manabar.TextString:SetPoint("CENTER", arenaFrame.manabar)
end

local classIcons = {"DRUID", "HUNTER", "MAGE", "PALADIN", "PRIEST", "ROGUE", "SHAMAN", "WARLOCK", "WARRIOR",
                    "DEATHKNIGHT"}

hooksecurefunc("ArenaEnemyFrame_UpdatePlayer", function(self)
    local _, class = UnitClass(self.unit)

    local raceData = addon.detectConstellation(self.unit)

    if raceData and self.racial then
        self.racial.Icon:SetTexture(raceData.icon)
    end

    if class then
        if addon.squareClassPortrait then
            self.classPortrait:SetTexture("Interface\\WorldStateFrame\\ICONS-CLASSES")
        else
            self.classPortrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
        end
        self.classPortrait:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]))
    end
end)

hooksecurefunc("ArenaEnemyFrame_SetMysteryPlayer", function(self)
    local i = random(1, 10)

    if addon.squareClassPortrait then
        self.classPortrait:SetTexture("Interface\\WorldStateFrame\\ICONS-CLASSES")
    else
        self.classPortrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
    end

    self.classPortrait:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classIcons[i]]))
end)
