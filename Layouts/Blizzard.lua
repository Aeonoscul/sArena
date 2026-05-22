local addonName, addon = ...
local layout = addon:AddLayout("Blizz Arena Default", "|cff00b4ffBlizz|r Arena Default")

function layout:SetFrameStyle(frame, db)
    -- 1. СБРОС И ОЧИСТКА ХВОСТОВ XARYU
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

    -- 2. ГЛАВНЫЙ ФРЕЙМ (Данные из твоего дампа)
    frame:SetSize(120, 53)

    frame.texture:Show()
    frame.texture:SetTexture("Interface/Custom/HUD")
    frame.texture:SetSize(120, 49)
    frame.texture:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -2)

    frame.healthbar:SetSize(70, 10)
    frame.healthbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -19)

    frame.manabar:SetSize(74, 7)
    frame.manabar:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -30)

    frame.classPortrait:SetSize(37, 37)
    frame.classPortrait:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -6, -5)

    frame.name:SetSize(57, 12)
    frame.name:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -5)

    -- PET
    frame.petFrame.healthbar:ClearAllPoints()
    frame.petFrame.manabar:ClearAllPoints()
    local petPortrait = frame.petFrame.portrait or frame.petFrame.classPortrait
    if petPortrait then
        petPortrait:SetParent(frame.petFrame)
        petPortrait:ClearAllPoints()
        petPortrait:SetAlpha(1)
    end

    frame.petFrame:SetSize(120, 53)

    frame.petFrame.healthbar:SetSize(70, 10)
    frame.petFrame.healthbar:SetPoint("TOPLEFT", frame.petFrame, "TOPLEFT", 5, -19)

    frame.petFrame.manabar:SetSize(74, 7)
    frame.petFrame.manabar:SetPoint("TOPLEFT", frame.petFrame, "TOPLEFT", 5, -30)

    local petPortrait = frame.petFrame.portrait or frame.petFrame.classPortrait
    if petPortrait then
        petPortrait:SetSize(37, 37)
        petPortrait:SetPoint("TOPRIGHT", frame.petFrame, "TOPRIGHT", -6, -5)
    end

    -- Исправление: Создаем или возвращаем родную текстуру-рамку для пета
    if not frame.petTexture then
        frame.petTexture = frame.petFrame:CreateTexture(nil, "BACKGROUND")
    end
    frame.petTexture:SetTexture("Interface/Custom/HUD")
    frame.petTexture:SetSize(120, 49)
    frame.petTexture:ClearAllPoints()
    frame.petTexture:SetPoint("TOPRIGHT", frame.petFrame, "TOPRIGHT", -1, -2)
    frame.petTexture:SetParent(frame.petFrame)
    frame.petTexture:Show()
end
