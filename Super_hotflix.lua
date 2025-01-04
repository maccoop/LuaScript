xlua.hotfix("FogTeam.GameFramework.Logic.Super", "ShowGameLogin", function(self)
    print("Show Game Login HotFix")
    CS.FogTeam.GameFramework.Logic.Super.LoadLoginScene()
    local obj = CS.FogTeam.KiemThe.UI.CanvasManager.Instance:LoadUIPrefab("LoginGame/UILoginGame 1")
    local loginGame = obj:GetComponent(typeof(CS.LuaScript))
    loginGame:InitLua("C:/Users/Admin/Project/LuaScript/login.lua")
    CS.FogTeam.KiemThe.UI.CanvasManager.Instance:AddUI(loginGame);
    loginGame:Register("LoginSuccess", function()
        print("login call")
        CS.FogTeam.GameFramework.Logic.Super.ShowNetWaiting("Đang tải thông tin Server...")
        CS.FogTeam.KiemThe.UI.CanvasManager.Instance:RemoveUI(loginGame);
        CS.FogTeam.GameFramework.Logic.Super.ShowSelectServer()
    end)
end)