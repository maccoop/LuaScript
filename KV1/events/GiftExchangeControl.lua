local TCPGameServerCmds = CS.FogTeam.GameEngine.Network.TCPGameServerCmds
local XElement = CS.System.Xml.Linq.XElement
local XName = CS.System.Xml.Linq.XName
local UIItemBox = CS.FogTeam.KiemThe.UI.Main.ItemBox.UIItemBox
local LuaHelper = CS.LuaScriptsHelper
local SocketConnectEventArgs = CS.HSGameEngine.GameEngine.Network.SocketConnectEventArgs
local indx

function awake()
    --indx = LuaHelper.Enum2Int(TCPGameServerCmds.CMD_KT_GIFT_EXCHANGE)
    indx = TCPGameServerCmds.CMD_KT_GIFT_EXCHANGE
    print('gift awake');
    InitPrefabs();
end

function InitPrefabs()
    CS.TimeCount.Ping()
    local exchangePrefab = self.transform:Find("Content/ExchangePrefab").gameObject
    local nodeName = XName.Get("Exchange")
    local xml = XElement.Parse(Loader.KT_UIData:get_Item("GiftExchange"))
    local nodes = LuaHelper.GetElementsAsArray(xml,"Exchange")
    for i = 0, nodes.Length - 1 do
        local exchangeData = nodes[i]
        local giftItemID = KTGlobal.GetXMLAttribute_Int(exchangeData, "GiftID");
        local giftItemData = Loader.Items[giftItemID]
        if (giftItemData ~= nil)
        then
            local exchangeObject = GameObject.Instantiate(exchangePrefab, exchangePrefab.transform.parent);
            exchangeObject.name = giftItemID;
            local buttonGift = exchangeObject.transform:Find("Button_Gift");
            buttonGift:GetComponentInChildren(typeof(Text)).text = "Tặng "..giftItemData.Name;
            buttonGift:GetComponent(typeof(Button)).onClick:AddListener(function() 
                SendGift(giftItemID)
            end);
            local textStatus = exchangeObject.transform:Find("Text_Status");
            local milestonePrefab = exchangeObject.transform:Find("Milestones/MilestonePrefab");
            local index = 0;
            local miles = LuaHelper.GetElementsAsArray(exchangeData,"Milestone")
            for i = 0, miles.Length - 1 do
                local milestoneXML = miles[i]
                local milestoneCount = KTGlobal.GetXMLAttribute_String(milestoneXML, "Count");
                local milestoneObject = GameObject.Instantiate(milestonePrefab, milestonePrefab.transform.parent);
                milestoneObject.name = index.."_"..milestoneCount
                local textCount = milestoneObject:Find("Count");
                textCount:GetComponentInChildren(typeof(Text)).text = milestoneCount;
                local itemBox = milestoneObject.transform:Find("ItemPrefab"):GetComponent(typeof(UIItemBox));
                local ItemName = XName.Get("Item")
                local itemXML = milestoneXML:Element(ItemName)
                local itemID = KTGlobal.GetXMLAttribute_Int(itemXML, "ID");
                local itemCount = KTGlobal.GetXMLAttribute_Int(itemXML, "Count");
                local outputGoods = Loader.Items[itemID]
                if (outputGoods ~= nil)
                then
                    itemBox.Data = KTGlobal.CreateItemPreview(outputGoods)
                    itemBox.Data.GCount = itemCount;
                    if (itemCount > 1)
                    then
                        print('1')
                        local txt_newCountTag = itemBox.transform:Find("tag/count"):GetComponent(typeof(Text));
                        txt_newCountTag.text = tostring(itemCount);
                        GameObject.Destroy(itemBox.transform:Find("Quantity Text").gameObject);
                    else
                        GameObject.Destroy(itemBox.transform:Find("tag").gameObject);
                    end
                    local button = milestoneObject:Find("Button_Receive"):GetComponent(typeof(Button));
                    button.onClick:AddListener(ReceiveReward);
                    index = index + 1;
                end
            end
            GameObject.Destroy(milestonePrefab.gameObject);
        else
            print('get_Item error')
        end
    end
    
    print(status)
    GameObject.Destroy(exchangePrefab);
    CS.TimeCount.Pong("Gift Exchange Lua Init Prefabs");
end

function start()
    print("lua gift exchange start!")
    LuaHelper.SendSimpleDataWithCallback(indx, CommandCallback, 0);
    print(status)
end

function CommandCallback(evt)
    print("hit command: ")
    local data = LuaHelper.ByteToDictionaryListIntInt(evt.bytesData);
    UpdateState(data);
end

 function UpdateState(data)
    print("get data from server: ")
    for giftId, status in pairs(data)
    do 
        local sended = status[0];
        local received = status[1];
        local gameObj = self.transform:Find("Content/"..giftId);
        local text_Status = gameObj:Find("Text_Status"):GetComponent(typeof(Text));
        text_Status.text = "Đã tặng "..status[0].." thiệp. Trong túi đồ có "..KTGlobal.GetItemCountInBag(giftId).." thiệp.";
        local milestonesContainer = gameObj:Find("Milestones");
        for i = 0, milestonesContainer.childCount - 1
        do
            local c = milestonesContainer:GetChild(i)
            local buttonReceive = c:Find("Button_Receive"):GetComponent(typeof(Button));
            local fields = split(c.gameObject.name, "_")
            local order = tonumber(fields[1])
            local count = tonumber(fields[2])
            local button_Text = buttonReceive:GetComponentInChildren(typeof(Text));
            local button_TextColor = button_Text.color;
            local button_TextColorEnable = Color(button_TextColor.r, button_TextColor.g, button_TextColor.b, 1);
            local button_TextColorDisable = Color(button_TextColor.r, button_TextColor.g, button_TextColor.b, 0.25);
            if (sended >= count)
            then
                if (order <= received)
                then
                    --đã nhận
                    buttonReceive.interactable = false;
                    button_Text.text = "Đã nhận";
                    button_Text.color = button_TextColorDisable;
                else
                    --chưa nhận
                    buttonReceive.interactable = true;
                    button_Text.text = "Nhận";
                    button_Text.color = button_TextColorEnable;
                end
            else
                -- không thể nhận
                buttonReceive.interactable = false;
                button_Text.text = "Chưa đủ điều kiện";
                button_Text.color = button_TextColorDisable;
            end
        end
    end
end

 function SendGift(giftItemID)
    local status, giftItemData = pcall(function() return Loader.Items[giftItemID] end);
    local currentInBag = KTGlobal.GetItemCountInBag(giftItemID);
    if (currentInBag == 0)
    then
        KTGlobal.ShowMessageBox("Thông báo", "Bằng hữu không có "..giftItemData.Name.." trong túi đồ!", true);
        return;
    end

    KTGlobal.ShowInputNumber(
        "Hãy chọn số lượng "..giftItemData.Name.." bằng hữu muốn tặng.",
        function(value)
            LuaHelper.SendSimpleData(indx, 1,tonumber(giftItemID), tonumber(value))
        end)
end

 function ReceiveReward()
    LuaHelper.SendSimpleData(indx, 2)
end

function ondestroyremove()
    CS.PlayZone.GlobalPlayZone.RemoveHandler();
end