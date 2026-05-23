local addonName, addon = ...
local layout = addon:AddLayout("Blizz Arena Default", "|cff00b4ffBlizz|r Arena Default")

function layout:SetFrameStyle(frame, db)
    frame.name:ClearAllPoints()
    frame.classPortrait:ClearAllPoints()
    frame.healthbar:ClearAllPoints()
    frame.manabar:ClearAllPoints()
    frame.texture:ClearAllPoints()

    if frame.portraitFrame then
        frame.classPortrait:SetParent(frame)
        frame.portraitFrame:Hide()
    end

    addon.squareClassPortrait = false
    frame.backgroundFrame:Hide()

    frame:SetSize(120, 40)

    if db.mirroredFrames then
        frame.texture:Show()
        frame.texture:SetTexture("Interface/Custom/HUD")
        frame.texture:SetTexCoord(0.7333984375, 0.5458984375, 0.3623046875, 0.427734375)
        frame.texture:SetSize(120, 40)
        frame.texture:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -2)

        frame.healthbar:SetSize(78, 12)
        frame.healthbar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -16)

        frame.manabar:SetSize(82, 7)
        frame.manabar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -28)

        frame.classPortrait:SetSize(38, 38)
        frame.classPortrait:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -3)

        frame.name:SetSize(57, 12)
        frame.name:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
        frame.name:SetJustifyH("RIGHT")
    else
        frame.texture:Show()
        frame.texture:SetTexture("Interface/Custom/HUD")
        frame.texture:SetTexCoord(0.5458984375, 0.7333984375, 0.3623046875, 0.427734375)
        frame.texture:SetSize(120, 40)
        frame.texture:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -2)

        frame.healthbar:SetSize(78, 12)
        frame.healthbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -16)

        frame.manabar:SetSize(82, 7)
        frame.manabar:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -28)

        frame.classPortrait:SetSize(38, 38)
        frame.classPortrait:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -3)

        frame.name:SetSize(57, 12)
        frame.name:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
        frame.name:SetJustifyH("LEFT")
    end

    frame.petFrame.healthbar:ClearAllPoints()
    frame.petFrame.manabar:ClearAllPoints()
    local petPortrait = frame.petFrame.portrait or frame.petFrame.classPortrait
    if petPortrait then
        petPortrait:SetParent(frame.petFrame)
        petPortrait:ClearAllPoints()
        petPortrait:SetAlpha(1)
    end

    frame.petFrame:SetSize(120, 40)

    frame.petFrame.healthbar:SetSize(78, 12)
    frame.petFrame.healthbar:SetPoint("TOPLEFT", frame.petFrame, "TOPLEFT", 1, -16)
    frame.petFrame.healthbar:SetFrameLevel(frame.petFrame:GetFrameLevel())

    frame.petFrame.manabar:SetSize(82, 7)
    frame.petFrame.manabar:SetPoint("TOPLEFT", frame.petFrame, "TOPLEFT", 0, -28)
    frame.petFrame.manabar:SetFrameLevel(frame.petFrame:GetFrameLevel())

    if petPortrait then
        petPortrait:SetSize(38, 38)
        petPortrait:SetPoint("TOPRIGHT", frame.petFrame, "TOPRIGHT", -4, -3)
    end

    if not frame.petTexture then
        frame.petTexture = frame.petFrame:CreateTexture(nil, "OVERLAY", nil, 7)
    end
    frame.petTexture:SetDrawLayer("OVERLAY", 7)
    frame.petTexture:SetTexture("Interface/Custom/HUD")
    frame.petTexture:SetTexCoord(0.5458984375, 0.7333984375, 0.3623046875, 0.427734375)
    frame.petTexture:SetSize(120, 40)
    frame.petTexture:ClearAllPoints()
    frame.petTexture:SetPoint("TOPRIGHT", frame.petFrame, "TOPRIGHT", -1, -2)
    frame.petTexture:SetParent(frame.petFrame)
    frame.petTexture:Show()
end
