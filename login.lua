selfScript = nil

LoginSuccess = {}
-- tab login
Input_LoginUserName = nil
Input_LoginPassword = nil
UIToggle_SaveAccountInfo = nil
Button_Login = nil
-- tab register
Input_RegisterUserName = nil
Input_RegisterPassword = nil
Input_RegisterRepassword = nil
Button_Register = nil
-- private
accountInfoManager = nil
_flagSDKLoginSuccess = false

function LoginSuccessAdd()
    LoginSuccess[#LoginSuccess+1] = function()
        selfScript:CallAction("LoginSuccess")
    end
end

function LoginSuccessInvoke()
    print("Login Success Invoke")
    for _, func in ipairs(LoginSuccess) do
        func()
        print("func Invoke")
    end
end

function RegisterCallBackAdd()
    if(#RegisterCallBack ~= 0)
    then 
        return
    end

    RegisterCallBack[#RegisterCallBack+1] = function()
        selfScript:CallAction("RegisterCallBack")
    end
    RegisterCallBack[#RegisterCallBack+1] = function ()
        CS.FogTeam.GameFramework.Super.ShowMessageBox("Đăng ký thành công", "Đăng ký tài khoản thành công.", true)
    end
end

function RegisterCallBackInvoke()
    for _, func in ipairs(RegisterCallBack) do
        func()
    end
end

function GetChild(parent, pathChild)
    childs = splitString(pathChild, "/")
    result = nil
    for i = 1,#childs
    do
        result = parent.transform:GetChild(childs[i])
        parent = result
    end
    return result
end

function splitString(input, delimiter)
    local result = {}
    for match in (input .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end


function start()
    --
    -- Awake
    selfScript = self:GetComponent(typeof(CS.LuaScript));
    LoginSuccessAdd()
    -- login
    Input_LoginUserName =   GetChild(self,"1/1/0/0"):GetComponent(typeof(CS.TMPro.TMP_InputField))
    Input_LoginPassword =   GetChild(self,"1/1/0/1"):GetComponent(typeof(CS.TMPro.TMP_InputField))
    Button_Login =          GetChild(self,"1/1/0/2"):GetComponent(typeof(CS.UnityEngine.UI.Button))
    UIToggle_SaveAccountInfo =  GetChild(self,"1/1/1/3"):GetComponent(typeof(CS.TMPro.TMP_InputField))

    -- register
    Input_RegisterUserName =    GetChild(self,"1/1/1/0"):GetComponent(typeof(CS.TMPro.TMP_InputField))
    Input_RegisterPassword =    GetChild(self,"1/1/1/1"):GetComponent(typeof(CS.TMPro.TMP_InputField))
    Input_RegisterRepassword =  GetChild(self,"1/1/1/2"):GetComponent(typeof(CS.TMPro.TMP_InputField))
    Button_Register =           GetChild(self,"1/1/1/3"):GetComponent(typeof(CS.UnityEngine.UI.Button))

    accountInfoManager = self:AddComponent(typeof(CS.FogTeam.KiemThe.Loader.LoadSavedAccountInfo))
    accountInfoManager.Done = function(account,password)
        Input_LoginUserName.text = account
        Input_LoginPassword.text = password
    end

    local lastSavedAccount = CS.UnityEngine.PlayerPrefs.GetString("Last Saved Account");
    if (#lastSavedAccount > 0) then
        Input_LoginUserName.text = lastSavedAccount
        Input_LoginPassword.text = password
    end
    --
    -- Start
    _flagSDKLoginSuccess = false
    if(selfScript:is_Android() == true and selfScript:is_Editor() == false)
    then
        CS.UnityEngine.GameObject.Find("Tab Header"):SetActive(false)
        CS.SDK.SDKUtils.Instance:ShowLogin(function(username, token)
            CS.FogTeam.GameEngine.Logic.Global.RootParams:set_Item("uid", username);
            CS.FogTeam.GameEngine.Logic.Global.RootParams:set_Item("n", username);
            CS.FogTeam.GameEngine.Logic.Global.RootParams:set_Item("t", CS.System.DateTimeOffset.Now:ToUnixTimeSeconds());
            CS.FogTeam.GameEngine.Logic.Global.RootParams:set_Item("cm", "1");
            CS.FogTeam.GameEngine.Logic.Global.RootParams:set_Item("token", token);

            CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.UserID = username;
            CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.UserName = username;
            CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.TimeActive = CS.System.DateTimeOffset.Now.ToUnixTimeSeconds();
            CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.Cm = "1";
            CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.TokenGS = token;

            CS.FogTeam.GameEngine.Network.SDKSession.AccessToken = token;
            CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.UserToken = token;
            CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.LastLoginIP = "192.168.1.1";
            CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.LastLoginTime = "" + CS.System.DateTime.Now.Ticks;

            if(this.LoginSuccess ~= nil) then
                LoginSuccessInvoke()
            end
        end)
    end
    InitPrefabs()
    local co = coroutine.create(loginSuccessOnMainThread)
end

function loginSuccessOnMainThread()
    while _flagSDKLoginSuccess == false do
        coroutine.yield(true) -- Continue coroutine
    end
    coroutine.yield(false) -- End coroutine
    LoginSuccessInvoke()
end

function InitPrefabs()
    self:GetComponentInChildren(typeof(CS.FogTeam.KiemThe.Utilities.UnityUI.UITabPanel)).enabled = true
    Button_Login.onClick:AddListener(ButtonLogin_Click)
    Button_Register.onClick:AddListener(ButtonRegister_Click)
end

function ButtonLogin_Click()
    local account = Input_LoginUserName.text
    local password = Input_LoginPassword.text;
    if(selfScript:is_Editor() == true)
    then
        local pathLoginXML = CS.FogTeam.GameEngine.Logic.Global.WebPath("login.xml", false)
        if(pathLoginXML ~= nil)
        then
            pathLoginXML = string.gsub(pathLoginXML,"file:///", "/")
            if (CS.System.IO.File.Exists(pathLoginXML))
            then
                local xmlNode = CS.System.Xml.Linq.XElement.Parse(CS.System.IO.File.ReadAllText(pathLoginXML))
    
                -- lay gia tri account
                account = xmlNode.Attribute("account").Value
                password = ""
            end
        end
    end
    
    CS.FogTeam.GameEngine.Logic.Global.RootParams:set_Item("uid", account);
    CS.FogTeam.GameEngine.Logic.Global.RootParams:set_Item("n", account);
    CS.FogTeam.GameEngine.Logic.Global.RootParams:set_Item("t", CS.System.DateTimeOffset.Now:ToUnixTimeSeconds());
    CS.FogTeam.GameEngine.Logic.Global.RootParams:set_Item("cm", "1");
    CS.FogTeam.GameEngine.Logic.Global.RootParams:set_Item("token", c011ebe6eb85229289163ce9b2861ead);

    CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.UserID = account;
    CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.UserName = account;
    CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.TimeActive = CS.System.DateTimeOffset.Now:ToUnixTimeSeconds();
    CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.Cm = "1";
    CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.TokenGS = "c011ebe6eb85229289163ce9b2861ead";


    CS.FogTeam.GameEngine.Network.SDKSession.AccessToken = "c011ebe6eb85229289163ce9b2861ead";
    CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.UserToken = "c011ebe6eb85229289163ce9b2861ead";
    CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.LastLoginIP = "192.168.1.1";
    CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.LastLoginTime = "" .. CS.System.DateTime.Now.Ticks;
    
    -- UnityEditor
    if(selfScript:is_Editor() == true)
    then
        local unixEpoch = CS.System.DateTime(1970, 1, 1, 0, 0, 0, CS.System.DateTimeKind.Utc);
        local now = CS.System.DateTime.UtcNow:Add(CS.System.TimeSpan.FromMinutes(60))
        local cache = now:Subtract(unixEpoch)
        local totalSeconds = CS.System.Math.Round(cache.TotalSeconds)
        local payload =
        {
            ["exp"] = totalSeconds,
            [ "sub"] = account 
        }
        local secretKey = "xMVSEaJ220T6mDM84HAVvN68EJFZIrnXFyWWCbqG4mBUMeOeu2Rl2aYgKPYvbdCA";
        local token = CS.JWT.JsonWebToken.Encode(payload, secretKey, CS.JWT.JwtHashAlgorithm.HS256);
        
        CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.TokenGS = token;
        CS.FogTeam.GameEngine.Logic.Global.RootParams:set_Item("token", token);
        CS.FogTeam.GameEngine.Network.SDKSession.AccessToken = token;
        CS.FogTeam.GameEngine.Network.GameInstance.Game.CurrentSession.UserToken = token;
    end
    -- EndEditor

    _flagSDKLoginSuccess = true
    if(LoginSuccess ~= nil) then
        LoginSuccessInvoke()
    end

end

function ButtonRegister_Click()
    CS.FogTeam.GameFramework.Logic.Super.ShowNetWaiting("Đang đăng ký tài khoản, xin đợi giây lát...")

    local account = Input_RegisterUserName.text;
    local password = Input_RegisterPassword.text;
    local repassword = Input_RegisterRepassword.text;

    -- Nếu mật khẩu nhập vào khác nhau
    if (password ~= repassword)
    then
        CS.FogTeam.GameFramework.Logic.Super.ShowMessageBox("Lỗi đăng ký", "Mật khẩu nhập vào không khớp!", true)
        return;
    end
    RegisterCallBackAdd()
    RequestRegister(account, password, "unknow@email.com", "01234567891")
end

--- SDK Đăng ký
RegisterCallBack = nil

function RequestRegister(UserName,Password,Email,PhoneNumber)
    coroutine.wrap(function()
        local url = CS.MainGame.GameInfo.RegisterAccountSDK
        print(url)

        local wwwForm = CS.UnityEngine.WWWForm()

        wwwForm:AddField("UserName", UserName)
        wwwForm:AddField("Password", Password)
        wwwForm:AddField("Email", Email)
        wwwForm:AddField("PhoneNumber", PhoneNumber)

        local www = CS.UnityEngine.Networking.UnityWebRequest.Post(url, wwwForm)
        coroutine.yield(www:SendWebRequest())

        if (IsNullOrEmpty(www.error) ~= nil)
        then
            print(www.error)
            CS.FogTeam.GameFramework.Logic.Super.HideNetWaiting();
            CS.FogTeam.GameFramework.Logic.Super.ShowMessageBox("Lỗi đăng ký", "Đăng ký thất bại, vui lòng kiểm tra lại mạng.", true);
            coroutine.yield(false)
        end

        local RegisterRep =
            CS.Server.Tools.DataHelper.BytesToObject(www.downloadHandler.data, 0, www.downloadHandler.data.Length);
        if (RegisterRep == null)
        then
            CS.FogTeam.GameFramework.Logic.Super.HideNetWaiting();
            CS.FogTeam.GameFramework.Logic.Super.ShowMessageBox("Lỗi đăng ký", "Đăng ký thất bại, vui lòng thử lại sau.", true);
            return
        else
            if (RegisterRep.ErrorCode ~= 0)
            then
                CS.FogTeam.GameFramework.Logic.Super.HideNetWaiting();
                CS.FogTeam.GameFramework.Logic.Super.ShowMessageBox("Lỗi đăng ký", RegisterRep.ErorrMsg, true)
            else
                CS.FogTeam.GameFramework.Logic.Super.HideNetWaiting();
                RegisterCallBackInvoke();
                CS.FogTeam.GameFramework.Logic.Super.ShowMessageBox("Đăng ký", "Đăng ký thành công!", true);
            end
        end
        www:Dispose();
    end)()
end


function IsNullOrEmpty(str)
    return str == nil or str == ''
end




