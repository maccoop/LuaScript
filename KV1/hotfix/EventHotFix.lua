local event = CS.FogTeam.Common.Generic.MonoBehavior_Event_001
xlua.hotfix("FogTeam.Common.Generic.MonoBehavior_Event_001", 
{
    OpenGiftExchange = function(self)
        local eventPrefab = CanvasManager.Instance:LoadUIPrefab(event.EVENT_PREFAB_FOLDER .. "UIGiftExchange_hotfix");
        if not eventPrefab then
            error("Failed to load the prefab!")
        end
        local script = eventPrefab.gameObject:AddComponent(typeof(CS.LuaScript));
        print("script is init: ".. type(script))

        script:InitLuaDef("events/GiftExchangeControl.lua");
        local rect = eventPrefab.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
        
        self:AddContentUI(rect);
    end;
});
