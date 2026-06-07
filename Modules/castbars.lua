local addonName, addon = ...
local module = addon:CreateModule("Cast Bars")

module.defaultSettings = {
    enable = true,
    x = -130,
    y = -1,
    scale = 1,
    width = 80,
    height = 12
}

module.optionsTable = {
    enable = {
        order = 1,
        type = "toggle",
        name = "Enable",
        set = module.UpdateSettings
    },
    break1 = {
        order = 2,
        type = "header",
        name = ""
    },
    scale = {
        order = 3,
        type = "range",
        name = "Scale",
        min = 0.1,
        max = 5.0,
        step = 0.01,
        bigStep = 0.1,
        set = module.UpdateSettings
    },
    width = {
        order = 4,
        type = "range",
        name = "Width",
        min = 10,
        max = 400,
        step = 1,
        bigStep = 5,
        set = module.UpdateSettings
    },
    height = {
        order = 5,
        type = "range",
        name = "Height",
        min = 5,
        max = 100,
        step = 1,
        bigStep = 5,
        set = module.UpdateSettings
    }
}

-- ---------------------------------------------------------------------------
-- Event handlers
-- ---------------------------------------------------------------------------

local function HandleADDON_LOADED(castBar)
    castBar:SetMovable(true)
    addon:SetupDrag(module, true, castBar)
    castBar:SetFrameLevel(6)
end

local function HandleTEST_MODE(castBar, barSpark, barText, barIcon)
    if addon.testMode and module.db.enable then
        castBar:EnableMouse(true)
        castBar.fadeOut = nil
        castBar.flash = nil
        barIcon:SetTexture(GetMacroIconInfo(math.random(1, GetNumMacroIcons())))
        barText:SetText(GetSpellInfo(118))
        barSpark:SetPoint("CENTER", castBar, "LEFT", castBar:GetWidth() * 0.5, 0)
        castBar:SetMinMaxValues(0, 100)
        castBar:SetValue(50)
        castBar:Show()
        barSpark:Show()
    else
        castBar:EnableMouse(false)
        CastingBarFrame_FinishSpell(castBar)
    end
end

local function HandleUPDATE_SETTINGS(castBar, barSpark, barText, barIcon, textBorder)
    castBar.showCastbar = module.db.enable
    CastingBarFrame_UpdateIsShown(castBar)

    castBar:ClearAllPoints()
    castBar:SetPoint("CENTER", module.db.x, module.db.y)
    castBar:SetScale(module.db.scale)
    castBar:SetSize(module.db.width, module.db.height)
    barIcon:SetSize(module.db.height * 1.2, module.db.height * 1.2)
    barIcon:SetPoint("RIGHT", castBar, "LEFT", 0, 0)
    barText:SetDrawLayer("OVERLAY", 0)
    barText:ClearAllPoints()
    barText:SetPoint("CENTER", castBar, "CENTER", 0, 0)
    if textBorder and textBorder:Hide() then
        textBorder:Hide()
    end
end

-- ---------------------------------------------------------------------------
-- Module event dispatcher
-- ---------------------------------------------------------------------------

function module:OnEvent(event, ...)
    if event == "UNIT_AURA" then
        return
    end

    for i = 1, MAX_ARENA_ENEMIES do
        local castBar = _G["ArenaEnemyFrame" .. i .. "CastingBar"]
        local barSpark = _G[castBar:GetName() .. "Spark"]
        local barText = castBar.Text
        local barIcon = _G[castBar:GetName() .. "Icon"]
        local textBorder = castBar.TextBorder

        if event == "ADDON_LOADED" then
            HandleADDON_LOADED(castBar)
        elseif event == "TEST_MODE" then
            HandleTEST_MODE(castBar, barSpark, barText, barIcon)
        elseif event == "UPDATE_SETTINGS" then
            HandleUPDATE_SETTINGS(castBar, barSpark, barText, barIcon, textBorder)
        end
    end

    if event == "ADDON_LOADED" then
        self:OnEvent("UPDATE_SETTINGS")
    elseif event == "UPDATE_SETTINGS" then
        if addon.testMode then
            self:OnEvent("TEST_MODE")
        end
    end
end
