xlua.hotfix("main", "Update", function(self)
    self:CreateTime();
    for i = 1,10000
    do
        print("call at " .. self.Index .. ": " .. i);
    end
    self.Index = self.Index + 1
    self:End()
end)
xlua.hotfix(main, "Start", function(self)
    print("Create from hotfix")
end)