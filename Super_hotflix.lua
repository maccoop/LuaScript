Super = CS.FogTeam.GameFramework.Logic.Super

xlua.hotfix(Super, "ShowGameLogin", function(self)
    print("Show Game Login HotFix")
    self.LoadLoginScene()
    local loginGame = CS.FogTeam.KiemThe.UI.CanvasManager.Instance:LoadUIPrefab(CS.LuaScript,"LoginGame/UILoginGame fix")
    CS.FogTeam.KiemThe.UI.CanvasManager.Instance:AddUI(loginGame);
    loginGame.GetComponent(typeof(CS.LuaScript)):Register("LoginSuccess", function()
        self.ShowNetWaiting("Đang tải thông tin Server...")
        CS.FogTeam.KiemThe.UI.CanvasManager.Instance:RemoveUI(self);
        self.ShowSelectServer()
    end)
end)