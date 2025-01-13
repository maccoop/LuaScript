Input = CS.UnityEngine.Input
PlayerPref = CS.UnityEngine.PlayerPref
ImageLoader = CS.ImageLoader
Time = CS.UnityEngine.Time
Random = CS.UnityEngine.Random
GUI = CS.UnityEngine.GUI
Rect = CS.UnityEngine.Rect
Screen = CS.UnityEngine.Screen
Vector3 = CS.UnityEngine.Vector3
Vector2 = CS.UnityEngine.Vector2
Resources = CS.UnityEngine.Resources
RectTransform = CS.UnityEngine.RectTransform
GameObject = CS.UnityEngine.GameObject
Button = CS.UnityEngine.UI.Button
Color = CS.UnityEngine.Color
Text = CS.TMPro.TMP_Text

_die = false

function SetDie(value)
    _die = value
end

function GetDie()
    return _die
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

function split(input, delimiter)
    local result = {}
    for match in (input .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

