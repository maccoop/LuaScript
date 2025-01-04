function OnTrigger(target)
    target:CallLuaFunc("Die", nil)
    self.gameObject:SetActive(false);
end