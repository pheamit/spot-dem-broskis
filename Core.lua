local addonName = ...

local iconKey = addonName .. "Icon"

local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit

local iconTexture = {
    ["DEATHKNIGHT"] = 135771,
    ["DEMONHUNTER"] = 236415,
    ["DRUID"] = 625999,
    ["HUNTER"] = 626000,
    ["MAGE"] = 626001,
    ["MONK"] = 626002,
    ["PALADIN"] = 626003,
    ["PRIEST"] = 626004,
    ["ROGUE"] = 626005,
    ["SHAMAN"] = 626006,
    ["WARLOCK"] = 626007,
    ["WARRIOR"] = 626008
}

local frame = CreateFrame("Frame")
 
frame:SetScript("OnEvent", function(self, event, unit)
    local namePlate = GetNamePlateForUnit(unit)
    if event == "NAME_PLATE_UNIT_ADDED" and UnitIsFriend("player", unit) then
        local _, class = UnitClass(unit)
        if iconTexture[class] then
            local icon = namePlate[iconKey]
            if not icon then
                icon = namePlate:CreateTexture(nil, "OVERLAY")
                icon:SetPoint('TOPLEFT', 10, 10)
                icon:SetSize(32, 32)
                namePlate[iconKey] = icon
            end
            icon:SetTexture(iconTexture[class])
            icon:Show()
            return
        end
    end
    if namePlate[iconKey] then
        namePlate[iconKey]:Hide()
    end
end)

frame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
frame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")