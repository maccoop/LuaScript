function OnTrigger(target)
    target:CallLuaFunc("Score", null)
    self.gameObject:SetActive(false);
end