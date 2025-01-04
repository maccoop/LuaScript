local _sprites = {}
local _loader = null
local _texturePath = "C:/Users/Admin/Project/LuaScript/textures/"
local _textures = {"bird_0.png","bird_1.png", "bird_2.png"}
local _coinText =  {"coin_0.png","coin_1.png", "coin_2.png"}
local _birdRender = null
local _nextRender = 0
local _delayRender = 1/8
local _indexSprite = 0
local _isFlying = false
local _timeFlyEnd = 0
local _timeFlying = 1/8
_g = 1

function start()
	self.transform.localScale = CS.UnityEngine.Vector3.one * 2
	_birdRender = self.gameObject:AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
	_loader = self.gameObject:AddComponent(typeof(CS.ImageLoader))
	local collider = self.gameObject:AddComponent(typeof(CS.UnityEngine.CircleCollider2D))
	collider.isTrigger = true
	collider.radius = 0.17
	local rigid = self.gameObject:AddComponent(typeof(CS.UnityEngine.Rigidbody2D))
	rigid.bodyType = CS.UnityEngine.RigidbodyType2D.Kinematic
	for i = 1,#_textures
	do
		print("Load from: " .. _texturePath .. _textures[i])
		_loader:LoadImageCallback(
			_texturePath .. _textures[i], 
			function(texture)
				_sprites[i] = CreateSprite(texture, 0, 0, texture.width, texture.height, 0.5, 0.5)
			end)
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

function update()
	if(#_sprites == #_textures) then
		Control()
		SpriteSheetForBird()
		Drop()
		GoldFunc()
	end
end

function GoldFunc()
	
end

function SpriteSheetForBird()
	if(CS.UnityEngine.Time.time > _nextRender) then
		_indexSprite = _indexSprite + 1
		if(_indexSprite > #_sprites) then
			_indexSprite = 1
		end
		_birdRender.sprite = _sprites[_indexSprite]
		_nextRender = CS.UnityEngine.Time.time + _delayRender
	end
end

function Drop()
	if(_isFlying == true) then
		self.transform.position = self.transform.position + CS.UnityEngine.Vector3.up * CS.UnityEngine.Time.deltaTime * 5
		if(CS.UnityEngine.Time.time > _timeFlyEnd) then
			_isFlying = false;
		end
		_g = 1
	else
		if(self.transform.position.y < -5) then
			return
		end
		self.transform.position = self.transform.position + CS.UnityEngine.Vector3.down * CS.UnityEngine.Time.deltaTime * _g
		self.transform.rotation = CS.UnityEngine.Quaternion.Euler(0, 0, 10 -_g*5) 
		_g = _g + _g/50 + CS.UnityEngine.Time.deltaTime
	end
end

function Control()
	if(_isFlying == false and CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Space)) then
		Fly();
	end
end

function Fly()
	_isFlying = true
	_timeFlyEnd = CS.UnityEngine.Time.time + _timeFlying
	self.transform.rotation = CS.UnityEngine.Quaternion.Euler(0, 0, 15) 
end

function onTriggerEnter2D(trigger)
    trigger.gameObject:SetActive(false)
end