ui_login_game = CS.FogTeam.KiemThe.UI.LoginGame.UILoginGame

xlua.hotfix(ui_login_game, "InitPrefabs", function(self)
    print("hotfix uiLoginGame");
    self.gameObject:GetComponentInChildren(typeof(CS.FogTeam.KiemThe.Utilities.UnityUI.UITabPanel)).enabled = true
    self.Button_Login.onClick:AddListener( function()
        print("Login click !!")
        self:ButtonLogin_Click();
    end)
    --self.Button_Register.onClick:AddListener(self:ButtonRegister_Click);
end)