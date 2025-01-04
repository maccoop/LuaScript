local _sprites = {}
local _loader = null
local _path = "C:/Users/Admin/Project/LuaScript/flappy/"
local _texturePath = _path .. "textures/"
local _coinText =  {"coin_1.png","coin_2.png", "coin_3.png", "coin_4.png","coin_5.png", "coin_6.png"}
local _nextRender = 0
local _delayRender = 1/8
local _indexSprite = 0
local _childs = {}
local _currentSprite = nil
local _isGen = true
local _nextTimeGen = 0
local _timeGenDelay = 1
local _parent
local _indexGen = 0

function start()
	for i = 1,#_coinText
	do
		CS.ImageLoader.LoadImageCallback(
			_texturePath .. _coinText[i], 
			function(texture)
				_sprites[i] = CreateSprite(texture, 0, 0, texture.width, texture.height, 0.5, 0.5)
			end)
	end
    self.transform.position = CS.UnityEngine.Vector3(0,0,0);
    --self.transform.localScale = CS.UnityEngine.Vector3(0.3,0.3,0.3)
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
    if(Time.time > _nextTimeGen) then
        _indexGen = _indexGen + 1
        _nextTimeGen = CS.UnityEngine.Time.time + _timeGenDelay
        -- object
        local render = CS.UnityEngine.GameObject("coin"):AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
        _childs[#_childs+1] = render
        render.transform.localScale = CS.UnityEngine.Vector3(0.3,0.3,0.3)
        render.transform.position = CS.UnityEngine.Vector3(10,CS.UnityEngine.Random.Range(-4,4),0)
        render.gameObject.layer = CS.UnityEngine.Layer
        -- collider
        local collider = render.gameObject:AddComponent(typeof(CS.UnityEngine.CircleCollider2D))
	    collider.isTrigger = true
        collider.radius = 0.6
        -- script
        local script = render.gameObject:AddComponent(typeof(CS.LuaScript))
        if(_indexGen % 2 == 0) then
            script:InitLua(_path .. "score.lua")
            local color = CS.UnityEngine.Color(1,1,1,1)
            render.color = color
        else 
            script:InitLua(_path .. "die.lua")
            local color = CS.UnityEngine.Color(0,0,0,1)
            render.color = color
        end
    end
end

function Moving()
    for i = 1, #_childs do
        _childs[i].transform.position =  _childs[i].transform.position + Vector3(-3 * Time.deltaTime,0,0)
        if(_childs[i].transform.position.x < -10) then
            _childs[i].transform.position = Vector3(10, Random.Range(-4,4),0)
            _childs[i].gameObject:SetActive(true)
            _isGen = false
        end
    end
end

function SpriteSheetForCoin()
    if(Time.time > _nextRender) then
        _indexSprite = _indexSprite + 1
        if(_indexSprite > #_sprites) then
            _indexSprite = 1
        end
        _currentSprite = _sprites[_indexSprite]
        _nextRender = Time.time + _delayRender
        for i = 1, #_childs do
            _childs[i].sprite = _currentSprite
        end
    end
end