local event = CS.FogTeam.Common.Generic.MonoBehavior_Event_001
local KT_TCPHandler = CS.FogTeam.KiemThe.Network.KT_TCPHandler
local cs_coroutine = require('cs_coroutine')
local MonoBehavior_Event_001 = CS.FogTeam.Common.Generic.MonoBehavior_Event_001

xlua.hotfix("PlayZone",
{
    OpenUIRechargeAward = function(self, dayRechageAwards, parentTransform)
        local rawData = dayRechageAwards.Item1
        local option = dayRechageAwards.Item2[0]
        local buttonStatus = dayRechageAwards.Item3
        local UIName = ""

        if option == KT_TCPHandler.OPTION_ACCUMULATE_RECHARGE
        then 
            UIName = "UIRechargeAward_Accumulate"
        elseif option == KT_TCPHandler.OPTION_DAY_RECHARGE
        then 
            UIName = "UIRechargeAward_Day_Fix"
        else return
        end

        if(parentTransform == nil)
        then 
            parentTransform = KTGlobal.canvasManager:GetDynamicUI():GetComponent(typeof(RectTransform))
        end
        print("parent Transform: ", parentTransform)

        local eventPrefab =  KTGlobal.canvasManager:LoadUIPrefab(event.EVENT_PREFAB_FOLDER .. UIName);
        print("event prefabL ", eventPrefab)
        local ui = eventPrefab.transform:GetComponent(typeof(CS.UnityEngine.RectTransform))
        MonoBehavior_Event_001.Instance:AddContentUI(ui);
        eventPrefab.transform:SetParent(parentTransform);


        local script = eventPrefab.gameObject:AddComponent(typeof(CS.LuaScript));
        print("script is init: ".. type(script))
        script:InitLuaDef("events/UIUnionShop.lua")
        cs_coroutine.start(function()
            print(os.clock())
            coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
            print(os.clock())
            script:CallLuaFunc("InitPrefab", rawData, option, buttonStatus)
        end)
    end;
});
