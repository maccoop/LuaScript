-- import
local PlayerPref = CS.UnityEngine.PlayerPref
local ImageLoader = CS.ImageLoader
local Time = CS.UnityEngine.Time
local Random = CS.UnityEngine.Random
local GUI = CS.UnityEngine.GUI
local Rect = CS.UnityEngine.Rect
local Screen = CS.UnityEngine.Screen

-- for data
local _sprites = {}
local _path = "C:/Users/Admin/Project/LuaScript/banana/"
local _texturePath = _path .. "textures/"
local _texture = "banana_"
local _render = nil
local _amountDay = 12
local _totalFrame = 8
local _day = 1
local _dataJob = {
    1, 2, 1, 1, 2, 1, 1, 1,
    0, 0, 0, 0
}
local _jobDone = 0
-- render
local _fps = 8
local _nextTimeGen = 0
local _timeGenDelay = 1/_fps
local _indexFrame = 1
local _die = false

function start()
    _day = PlayerPref.GetInt("day", 1)
    _jobScore = PlayerPref.GetInt("jobScore", 1)
    local status = PlayerPref.GetString("status", "good")
    if(status ~= "die") then
        local requireScore = 0
        for i = 1, _day
        do 
            requireScore = requireScore + _dataJob[i]
        end
        local dayOverCount = _jobScore - requireScore
        status = "good"
        if(dayOverCount > 3 or dayOverCount < -3)
        then 
            status = "die"
            _die = true
        else if (dayOverCount == 2 or dayOverCount == -2)
            then
                status = "bad"
            end
        end
        PlayerPref.SetString("status", status)
        PlayerPref.Save()
    else
        _die = true
    end
    for(i = 1, _totalFrame) do
        ImageLoader.LoadImageCallback(
            _texturePath..status.."/".._day.."/".._texture..i..".png",
            function(texture)
                _sprites[i] = CreateSprite(texture, 0, 0, texture.width, texture.height, 0.5, 0.5)
            end)
    end
    _render = self.gameObject:AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
    _render.sprite = _sprites[1]
end

function update()
    OnRenderSpriteSheet()
end

function ongui()
    if(_die) then
        if(GUI.Button(Rect(Screen.width/2, Screen.height/2, 100, 66), "Restart")) then
            PlayerPref.SetInt("day", 1)
            PlayerPref.SetInt("jobScore", 1)
            PlayerPref.SetInt("status", "good")
            _die = false
            start()
        end
    else

    end
end

function OnRenderSpriteSheet()
    if(Time.time > _nextTimeGen)
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

function CreateSprite(texture, x, y, width, height, pivotX, pivotY)
    if texture == nil then
        print("Texture is nil")
        return nil
    end

    local rect = CS.UnityEngine.Rect(x, y, width, height)
    local pivot = CS.UnityEngine.Vector2(pivotX or 0.5, pivotY or 0.5)
    local sprite = CS.UnityEngine.Sprite.Create(texture, rect, pivot)
    return sprite
end