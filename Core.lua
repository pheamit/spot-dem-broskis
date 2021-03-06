local addonName = "SDB"

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

frame:SetScript(
    "OnEvent",
    function(self, event, unit)
        if event == "NAME_PLATE_UNIT_ADDED" and UnitInParty(unit) and unitIsValid(unit) then
            local namePlate = GetNamePlateForUnit(unit)
            local _, class = UnitClass(unit)
            local guid = UnitGUID(unit)
            if iconTexture[class] then
                local icon = namePlate[iconKey]
                if not icon then
                    icon = namePlate:CreateTexture(nil, "OVERLAY")
                    icon:SetPoint("TOPLEFT", 10, 10)
                    icon:SetSize(32, 32)
                    namePlate[iconKey] = icon
                end
                icon:SetTexture(iconTexture[class])
                icon:Show()
            end
        elseif event == "PLAYER_ENTERING_WORLD" then
            print(UnitName("player") .. " entered world!")
            print("Hiding friendly nameplates.")
            SetCVar("nameplateShowFriends", 0)
            SetCVar("nameplateShowAll", 0)
        elseif event == "PLAYER_ENTERING_BATTLEGROUND" then
            print(UnitName("player") .. " entered battleground!")
            print("Displaying friendly nameplates.")
            SetCVar("nameplateShowFriends", 1)
            SetCVar("nameplateShowAll", 1)
        elseif unitIsValid(unit) then
            GetNamePlateForUnit(unit):Hide()
        end
    end
)

local function unitIsValid(unit)
    return UnitIsFriend(unit) and UnitIsPlayer(unit)--[[  and UnitInBattleground(unit) ]]
end


frame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
frame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
frame:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
