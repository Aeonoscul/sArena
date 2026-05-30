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

function module:OnEvent(event, ...)
    if event == "UNIT_AURA" then
        return;
    end

    for i = 1, MAX_ARENA_ENEMIES do
        local castBar = _G["ArenaEnemyFrame" .. i .. "CastingBar"]
        local barSpark = _G[castBar:GetName() .. "Spark"]
        local barText = castBar.Text
        local barIcon = _G[castBar:GetName() .. "Icon"]
        local textBorder
        if castBar.TextBorder then
            textBorder = castBar.TextBorder
        end

        if event == "ADDON_LOADED" then
            castBar:SetMovable(true)
            addon:SetupDrag(self, true, castBar)

            castBar:SetFrameLevel(6)
        elseif event == "TEST_MODE" then
            if addon.testMode and self.db.enable then
                castBar:EnableMouse(true)
                castBar.fadeOut = nil
                castBar.flash = nil
                barIcon:SetTexture(GetMacroIconInfo(math.random(1, GetNumMacroIcons())))
                --barIcon:SetPoint("RIGHT", castBar, "LEFT", 0, 0)
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
        elseif event == "UPDATE_SETTINGS" then
            castBar.showCastbar = self.db.enable
            CastingBarFrame_UpdateIsShown(castBar)

            castBar:ClearAllPoints()
            castBar:SetPoint("CENTER", self.db.x, self.db.y)
            castBar:SetScale(self.db.scale)
            castBar:SetSize(self.db.width, self.db.height)
            barIcon:SetSize(self.db.height*1.2, self.db.height*1.2)
            barIcon:SetPoint("RIGHT", castBar, "LEFT", 0, 0)
            barText:SetDrawLayer("OVERLAY", 0)
            barText:ClearAllPoints()
            barText:SetPoint("CENTER", castBar, "CENTER", 0, 0)
            if textBorder and textBorder:Hide() then
                textBorder:Hide()
            end
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
