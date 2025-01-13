local Super = CS.FogTeam.GameFramework.Logic.Super
local CanvasManager = CS.FogTeam.KiemThe.UI.CanvasManager

xlua.hotfix("FogTeam.GameFramework.Logic.Super",
{
    ShowGameLogin = function(self)
        print("Show Game Login HotFix")
        Super.LoadLoginScene()
        local obj = CanvasManager.Instance:LoadUIPrefab("LoginGame/UILoginGame 1")
        local loginGame = obj:GetComponent(typeof(CS.LuaScript))
        loginGame:InitLuaDef("login.lua", nil)
        CanvasManager.Instance:AddUI(loginGame);
        loginGame:Register("LoginSuccess", 
            function()
                print("login call")
                Super.ShowNetWaiting("Đang tải thông tin Server...")
                CanvasManager.Instance:RemoveUI(loginGame);
                Super.ShowSelectServer()
            end
        )
    end;
});

function LoadLoginScene233()
    print("Load Login Scene Hotfix")
    if (Super.LoginScene ~= nil)
    then
        return
    end
    local loginScene = Resources.Load("KiemThe/Prefabs/Login Scene");
    Super.LoginScene = GameObject.Instantiate(loginScene):GetComponent(typeof(CS.UnityEngine.RectTransform));
    CanvasManager.Instance:AddUI(LoginScene);
end