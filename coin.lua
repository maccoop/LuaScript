local _sprites = {}
local _loader = null
local _texturePath = "C:/Users/Admin/Project/LuaScript/textures/"
local _coinText =  {"coin_1.png","coin_2.png", "coin_3.png", "coin_4.png","coin_5.png", "coin_6.png"}
local _nextRender = 0
local _delayRender = 1/8
local _indexSprite = 0
local _childs = {}
local _currentSprite = nil
local _isGen = true
local _nextTimeGen = 0
local _timeGenDelay = 1

function start()
	_loader = self.gameObject:AddComponent(typeof(CS.ImageLoader))
	for i = 1,#_coinText
	do
		_loader:LoadImageCallback(
			_texturePath .. _coinText[i], 
			function(texture)
				_sprites[i] = CreateSprite(texture, 0, 0, texture.width, texture.height, 0.5, 0.5)
			end)
	end
    self.transform.position = CS.UnityEngine.Vector3(0,0,0);
    --self.transform.localScale = CS.UnityEngine.Vector3(0.3,0.3,0.3)
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

function update()
    if(#_sprites == #_coinText) then
        Generate()
        SpriteSheetForCoin()
        Moving()
    end
end

function Generate()
    if(_isGen == false) then
        return
    end
    if(CS.UnityEngine.Time.time > _nextTimeGen) then
        _nextTimeGen = CS.UnityEngine.Time.time + _timeGenDelay
        _childs[#_childs+1] = CS.UnityEngine.GameObject("coin"):AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
        _childs[#_childs].transform.localScale = CS.UnityEngine.Vector3(0.3,0.3,0.3)
        _childs[#_childs].transform.position = CS.UnityEngine.Vector3(10,CS.UnityEngine.Random.Range(-4,4),0)
        local collider = _childs[#_childs].gameObject:AddComponent(typeof(CS.UnityEngine.CircleCollider2D))
	    collider.isTrigger = true
        collider.radius = 0.6
    end
end

function Moving()
    for i = 1, #_childs do
        _childs[i].transform.position =  _childs[i].transform.position + CS.UnityEngine.Vector3(-3 * CS.UnityEngine.Time.deltaTime,0,0)
        if(_childs[i].transform.position.x < -10) then
            _childs[i].transform.position = CS.UnityEngine.Vector3(10,CS.UnityEngine.Random.Range(-4,4),0)
            _childs[i].gameObject:SetActive(true)
            _isGen = false
        end
    end
end

function SpriteSheetForCoin()
    if(CS.UnityEngine.Time.time > _nextRender) then
        _indexSprite = _indexSprite + 1
        if(_indexSprite > #_sprites) then
            _indexSprite = 1
        end
        _currentSprite = _sprites[_indexSprite]
        _nextRender = CS.UnityEngine.Time.time + _delayRender
        for i = 1, #_childs do
            _childs[i].sprite = _currentSprite
        end
    end
end