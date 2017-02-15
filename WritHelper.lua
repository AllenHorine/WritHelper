WritHelper = {}
local isCraft = false

WritHelper.name = "WritHelper"
WritHelper.smithing = ""
WritHelper.clothing = ""
WritHelper.enchanting = ""
WritHelper.alchemy = ""
WritHelper.provisioning = ""
WritHelper.woodworking = ""
WritHelper.hasSmithing = false
WritHelper.hasClothing = false
WritHelper.hasEnchanting = false
WritHelper.hasAlchemy = false
WritHelper.hasProvisioning = false
WritHelper.hasWoodworking = false
WritHelper.objective = ""

function WritHelper:OnIndicatorMoveStop()
  WritHelper.savedVariables.left = WritHelperCrafting:GetLeft()
  WritHelper.savedVariables.top = WritHelperCrafting:GetTop()
end

function WritHelper:RestorePosition()
  local left = self.savedVariables.left
  local top = self.savedVariables.top
  WritHelperCrafting:ClearAnchors()
  WritHelperCrafting:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end
 
function WritHelper:Initialize()
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_CRAFTING_STATION_INTERACT, self.crafting)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_END_CRAFTING_STATION_INTERACT, self.crafting)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_QUEST_ADDED, self.getWritQuest)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_QUEST_COMPLETE, self.endWrit)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_QUEST_REMOVED, self.delWrit)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_QUEST_CONDITION_COUNTER_CHANGED, self.updateWrit)

  self.savedVariables = ZO_SavedVars:New("WritHelperSavedVariables", 1, nil, {})
  self.RestorePosition()
end

function WritHelper:getWritQuest(index, name)
  local type = GetJournalQuestType(index)
  if type == 4 then
    local p1, p2, p3, p4 = ''
    p1 = GetJournalQuestConditionInfo(index, 1, 1)
    p2 = GetJournalQuestConditionInfo(index, 1, 2)
    p3 = GetJournalQuestConditionInfo(index, 1, 3)
    p4 = GetJournalQuestConditionInfo(index, 1, 4)
    if p1 ~= '' then
      WritHelper.objective = WritHelper.objective .. p1 .. '\n'
    end
    if p2 ~= '' then
      WritHelper.objective = WritHelper.objective .. p2 .. '\n'
    end
    if p3 ~= '' then
      WritHelper.objective = WritHelper.objective .. p3 .. '\n'
    end
    if p4 ~= '' then
      WritHelper.objective = WritHelper.objective .. p4
    end
    if name == 'Blacksmith Writ' then 
      WritHelper.smithing = WritHelper.objective
      WritHelper.hasSmithing = true
    elseif name == 'Clothier Writ' then
      WritHelper.clothing = WritHelper.objective
      WritHelper.hasClothing = true
    elseif name == 'Enchanter Writ' then
      WritHelper.enchanting = WritHelper.objective
      WritHelper.hasEnchanting = true
    elseif name == 'Alchemist Writ' then
      WritHelper.alchemy = WritHelper.objective
      WritHelper.hasAlchemy = true
    elseif name == 'Provisioner Writ' then
      WritHelper.provisioning = WritHelper.objective
      WritHelper.hasProvisioning = true
    elseif name == 'Woodworker Writ' then
      WritHelper.woodworking = WritHelper.objective
      WritHelper.hasWoodworking = true
    end
    WritHelper.objective = ''
  end
end

function WritHelper:updateWrit(index, name)
  WritHelper:getWritQuest(index, name)
  WritHelper:updateCraft(GetCraftingInteractionType())
end

function WritHelper:delWrit(code, completed, index, name)
  if name == 'Blacksmith Writ' then 
    WritHelperCraftingTitle:SetText(string.format(''))
    WritHelperCraftingObjective:SetText(string.format(''))
    WritHelper.smithing = ''
    WritHelper.hasSmithing = false
  elseif name == 'Clothier Writ' then
    WritHelperCraftingTitle:SetText(string.format(''))
    WritHelperCraftingObjective:SetText(string.format(''))
    WritHelper.clothing = ''
    WritHelper.hasClothing = false
  elseif name == 'Enchanter Writ' then
    WritHelperCraftingTitle:SetText(string.format(''))
    WritHelperCraftingObjective:SetText(string.format(''))
    WritHelper.enchanting = ''
    WritHelper.hasEnchanting = false
  elseif name == 'Alchemist Writ' then
    WritHelperCraftingTitle:SetText(string.format(''))
    WritHelperCraftingObjective:SetText(string.format(''))
    WritHelper.alchemy = ''
    WritHelper.hasAlchemy = false
  elseif name == 'Provisioner Writ' then
    WritHelperCraftingTitle:SetText(string.format(''))
    WritHelperCraftingObjective:SetText(string.format(''))
    WritHelper.provisioning = ''
    WritHelper.hasProvisioning = false
  elseif name == 'Woodworker Writ' then
    WritHelperCraftingTitle:SetText(string.format(''))
    WritHelperCraftingObjective:SetText(string.format(''))
    WritHelper.woodworking = ''
    WritHelper.hasWoodworking = false
  end
end

function WritHelper:endWrit(code, name)
  WritHelper.delWrit(nil, nil, nil, name)
end

function WritHelper:updateCraft(craftSkill)
  if craftSkill == 1 and WritHelper.hasSmithing then
    WritHelperCraftingTitle:SetText(string.format('Blacksmith Writ'))
    WritHelperCraftingObjective:SetText(string.format(WritHelper.smithing))
  elseif craftSkill == 2 and WritHelper.hasClothing then
    WritHelperCraftingTitle:SetText(string.format('Clothier Writ'))
    WritHelperCraftingObjective:SetText(string.format(WritHelper.clothing))
  elseif craftSkill == 3 and WritHelper.hasEnchanting then
    WritHelperCraftingTitle:SetText(string.format('Enchanter Writ'))
    WritHelperCraftingObjective:SetText(string.format(WritHelper.enchanting))
  elseif craftSkill == 4 and WritHelper.hasAlchemy then
    WritHelperCraftingTitle:SetText(string.format('Alchemist Writ'))
    WritHelperCraftingObjective:SetText(string.format(WritHelper.alchemy))
  elseif craftSkill == 5 and WritHelper.hasProvisioning then
    WritHelperCraftingTitle:SetText(string.format('Provisioner Writ'))
    WritHelperCraftingObjective:SetText(string.format(WritHelper.provisioning))
  elseif craftSkill == 6 and WritHelper.hasWoodworking then
    WritHelperCraftingTitle:SetText(string.format('Woodworker Writ'))
    WritHelperCraftingObjective:SetText(string.format(WritHelper.woodworking))
  end
end

function WritHelper:crafting(craftSkill)
  WritHelper.updateCraft(craftSkill)
  isCraft = not isCraft
  WritHelperCrafting:SetHidden(not isCraft)
end

-- function WritHelper:initQuests()
--   d(GetNumJournalQuests())
--   for i = 1, GetNumJournalQuests(), 1 do
--     d(GetJournalQuestType(i))
--   end
-- end

function WritHelper:OnAddOnLoaded(event, addonName)
  if addonName == WritHelper.name then
    WritHelper.Initialize()
    -- zo_callLater(function()WritHelper.initQuests()end, 5000)
  end
end
 
EVENT_MANAGER:RegisterForEvent(WritHelper.name, EVENT_ADD_ON_LOADED, WritHelper.OnAddOnLoaded)
