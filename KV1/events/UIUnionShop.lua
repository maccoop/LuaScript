local OverlayReceive
local UIButton_Close
local rechargeAwardPrefab = nil
local rechargeItemsList
local XElement = CS.System.Xml.Linq.XElement
local XName = CS.System.Xml.Linq.XName
local RechargeAward = CS.FogTeam.KiemThe.UI.Main.RechargeAward
local DateTime = CS.System.DateTime
local CultureInfo = CS.System.Globalization.CultureInfo
local cs_coroutine = require('cs_coroutine')
local util = require 'xlua.util'
local KT_TCPHandler = CS.FogTeam.KiemThe.Network.KT_TCPHandler
local UIRechageAwardsList = {}

function InitPrefab(rawData, option, buttonStatus)
    print("ui uniion")
    OverlayReceive = self.transform:Find("OverlayReceive"):GetComponent(typeof(RectTransform))
    local data = XElement.Parse(rawData);
    local rechargeAward = RechargeAward.Parse(data)
    local awardIndex = 0;
    print("xml data", data, option)
    if (option == KT_TCPHandler.OPTION_DAY_RECHARGE)
    then
        local strStartDate = data:Element(XName.Get("DayRecharge")):Attribute(XName.Get("StartDate")).Value;
        local strEndDate = data:Element(XName.Get("DayRecharge")):Attribute(XName.Get("EndDate")).Value;
        local startDate = DateTime.Parse(strStartDate, CultureInfo.InvariantCulture);
        local endDate = DateTime.Parse(strEndDate, CultureInfo.InvariantCulture);

        local text_Info = self.transform:Find("Background/Content/DayRecharge/InfoText"):GetComponent(typeof(Text));
        text_Info.text = string.gsub(text_Info.text,"DATERANGE", startDate:ToString("HH:mm dd/MM").."-"..endDate:ToString("HH:mm dd/MM"))
        rechargeItemsList = self.transform:Find("Background/Content/DayRecharge/Scroll View/Viewport/DailyRechargeItemsList"):GetComponent(typeof(RectTransform))


        rechargeAwardPrefab = self.transform:Find("DayRechageAwardPrefab"):GetComponent(typeof(RectTransform))
        for rechargeAwardElement in rechargeAward.DailyRechargeAwards
        do
            AddAwardItem(rechargeAwardElement, buttonStatus[awardIndex], awardIndex, option);
            awardIndex = awardIndex + 1;
        end
    elseif (option == KT_TCPHandler.OPTION_ACCUMULATE_RECHARGE)
    then
        local strStartDate = data:Element(XName.Get("AccumulateRecharge")):Attribute(XName.Get("StartDate")).Value;
        local strEndDate = data:Element(XName.Get("AccumulateRecharge")):Attribute(XName.Get("EndDate")).Value;
        local startDate = DateTime.Parse(strStartDate, CultureInfo.InvariantCulture);
        local endDate = DateTime.Parse(strEndDate, CultureInfo.InvariantCulture);
        local text_Info = self.transform:Find("Background/Content/AccumulateRecharge/InfoText"):GetComponent(typeof(Text));
        text_Info.text = string.gsub(text_Info.text,"DATERANGE", startDate:ToString("HH:mm dd/MM").."-"..endDate:ToString("HH:mm dd/MM"));
        rechargeItemsList = self.transform:Find("Background/Content/AccumulateRecharge/Scroll View/Viewport/AccumulateRechargeItemsList"):GetComponent(typeof(RectTransform))
        rechargeAwardPrefab = rechargeItemsList.transform:Find("AccumulateRechageAwardPrefab"):GetComponent(typeof(RectTransform))
        if(rechargeAward.AccumulateRechargeAwards ~= nil) then
        for index, rechargeAwardElement in ipairs(rechargeAward.AccumulateRechargeAwards)
            do
                print("loop ", index)
                AddAwardItem(rechargeAwardElement, buttonStatus[awardIndex], awardIndex, option);
                awardIndex = awardIndex + 1;
            end
        end
    end
    RebuildLayout();
end

function AddAwardItem(rechargeAwardElement, bstatus, awardIndex, option)
    print("Add award item: ", rechargeAwardElement)
    if (rechargeAwardPrefab == nil)
    then
        KTDebug.LogError("khong tim thay prefab");
        return;
    end
    local dayRechargeAwardGO = GameObject.Instantiate(rechargeAwardPrefab, rechargeItemsList, false).gameObject;

    print("dayRechargeAwardGO: ", dayRechargeAwardGO)
    local dayRecharge = CS. FogTeam.KiemThe.UI.Main.UIDayRechargeAward();
    dayRecharge.behaviourScript = dayRechargeAwardGO:AddComponent(typeof(CS.BehaviourScript));
    dayRecharge.behaviourScript.VMMonoBehaviour = dayRecharge;

    dayRecharge.GetRechargeAward = function()
        KT_TCPHandler.SendGetRechargeAward(rechargeAwardElement.MinYuanBao, awardIndex, option);
        SetButtonStatus(awardIndex, 1);
    end
    dayRecharge:InitPrefab(rechargeAwardElement, bstatus);
    UIRechageAwardsList[#UIRechageAwardsList + 1] = dayRecharge;
    dayRechargeAwardGO:SetActive(true);
    print("end Add Award Item", #UIRechageAwardsList)
end

function RebuildLayout()
    cs_coroutine.start(function()
        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.1))
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(rechargeItemsList);
    end)
end

function SetButtonStatus(awardIndex, buttonStatus)
    print("Set Button Status ", awardIndex)
    local rechageAward = UIRechageAwardsList[awardIndex];
    rechageAward:SetButtonStatus(buttonStatus);
    cs_coroutine.start(function()
        OverlayReceive.gameObject:SetActive(true);
        coroutine.yield(CS.UnityEngine.WaitForSeconds(.65))
        OverlayReceive.gameObject:SetActive(false);
    end)
end
