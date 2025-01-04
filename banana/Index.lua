-- for data
local _sprites = {}
local _path = "C:/Users/Admin/Project/LuaScript/banana/"
local _texturePath = _path .. "textures/"
local _texture = "banana_"
local _render = nil
local _amountDay = 12
local _fps = 8
local _day = 1
local _dataJob = {
    1, 2, 1, 1, 2, 1, 1, 1,
    0, 0, 0, 0
}
local _jobDone = 0
-- render
local _nextTimeGen = 0
local _timeGenDelay = 1/_fps
local _indexFrame = 1

function start()
    _day = CS.UnityEngine.PlayerPref.GetInt("day", 1)
    _jobScore = CS.UnityEngine.PlayerPref.GetInt("jobScore", 1)
    local status = CS.UnityEngine.PlayerPref.GetString("status", "good")
    if(status ~= "die")
        local requireScore = 0
        for i = 1, _day
        do 
            requireScore = requireScore + _dataJob[i]
        end
        local dayOverCount = _jobScore - requireScore
        status = "good"
        if(dayOverCount > 3 or dayOverCount < -3)
        then status = "die"
        else if (dayOverCount == 2 or dayOverCount == -2)
            then
                status = "bad"
            end
        end
        CS.UnityEngine.PlayerPref.SetString("status", status)
        CS.UnityEngine.PlayerPref.Save()
    end
    for(i = 1, _fps) do
        CS.ImageLoader.LoadImageCallback(
            _texturePath..status.."/".._day.."/".._texture..i..".png",
            function(texture)
                _sprites[i] = CreateSprite(texture, 0, 0, texture.width, texture.height, 0.5, 0.5)
            end)
    end
    _render = self.gameObject:AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
    _render.sprite = _sprites[1]
end

function update()
    OnRender()
end

function OnRender()
    if(CS.UnityEngine.Time.time > _nextTimeGen)
    then
        _nextTimeGen = CS.UnityEngine.Time.time + _timeGenDelay
        _indexFrame = _indexFrame + 1
        if(_indexFrame > _fps)
        then
            _indexFrame = 1
        end
        _render.sprite = _sprites[_indexFrame]
    end
end