local Super = CS.FogTeam.GameFramework.Logic.Super
local CanvasManager = CS.FogTeam.KiemThe.UI.CanvasManager

xlua.hotfix("FogTeam.GameFramework.Logic.Super", "ShowGameLogin", function(self)
    print("Show Game Login HotFix")
    Super.LoadLoginScene()
    local obj = CanvasManager.Instance:LoadUIPrefab("LoginGame/UILoginGame 1")
    local loginGame = obj:GetComponent(typeof(CS.LuaScript))
    loginGame:InitLua("login", "C:/Users/Admin/Project/LuaScript/KV1/login.lua")
    CanvasManager.Instance:AddUI(loginGame);
    loginGame:Register("LoginSuccess", function()
        print("login call")
        Super.ShowNetWaiting("Đang tải thông tin Server...")
        CanvasManager.Instance:RemoveUI(loginGame);
        Super.ShowSelectServer()
    end)
end)