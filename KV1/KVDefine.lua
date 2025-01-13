Loader = CS.FogTeam.KiemThe.Loader.Loader
XElement = CS.System.Xml.Linq.XElement
KTGlobal = CS.FogTeam.KiemThe.KTGlobal
ItemData = CS.FogTeam.KiemThe.Entities.Config
DataHelper = CS.Server.Tools.DataHelper
GameInstance = CS.FogTeam.GameEngine.Network.GameInstance
CanvasManager = CS.FogTeam.KiemThe.UI.CanvasManager

function BytesToObject(bytesData)
    local dictionary = {}
    local index = 1

    -- Giả sử dữ liệu đã là một chuỗi byte đơn giản (ví dụ: "1|10,20,30;2|40,50")
    for entry in string.gmatch(bytesData, "([^;]+)") do
        local key, values = entry:match("(%d+)|(.+)")
        key = tonumber(key)
        dictionary[key] = {}

        for value in string.gmatch(values, "([^,]+)") do
            table.insert(dictionary[key], tonumber(value))
        end
    end

    return dictionary
end