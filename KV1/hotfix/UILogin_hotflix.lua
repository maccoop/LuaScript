local UnityUI = CS.FogTeam.KiemThe.Utilities.UnityUI 

xlua.hotfix("FogTeam.KiemThe.UI.LoginGame.UILoginGame", "InitPrefabs", function(self)
    print("hotfix uiLoginGame");
    self.gameObject:GetComponentInChildren(typeof(UnityUI.UITabPanel)).enabled = true
    self.Button_Login.onClick:AddListener( function()
        print("Login click !!")
        self:ButtonLogin_Click();
    end)
end)