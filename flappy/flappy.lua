local _sprites = {}
local _loader = null
local _path = "C:/Users/Admin/Project/LuaScript/flappy/"
local _texturePath = _path .. "textures/"
local _textures = {"bird_0.png","bird_1.png", "bird_2.png"}
local _birdRender = null
local _nextRender = 0
local _delayRender = 1/8
local _indexSprite = 0
local _isFlying = false
local _timeFlyEnd = 0
local _timeFlying = 1/8
local _g = 1
local _coin = 0

function start()
	self.transform.localScale = CS.UnityEngine.Vector3.one * 2
	_birdRender = self.gameObject:AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
	local collider = self.gameObject:AddComponent(typeof(CS.UnityEngine.CircleCollider2D))
	collider.isTrigger = true
	collider.radius = 0.17
	local rigid = self.gameObject:AddComponent(typeof(CS.UnityEngine.Rigidbody2D))
	rigid.bodyType = CS.UnityEngine.RigidbodyType2D.Kinematic
	for i = 1,#_textures
	do
		CS.ImageLoader.LoadImageCallback(
			_texturePath .. _textures[i], 
			function(texture)
				_sprites[i] = CreateSprite(texture, 0, 0, texture.width, texture.height, 0.5, 0.5)
			end)
	end
end

function update()
	if(#_sprites == #_textures) then
		Control()
		SpriteSheetForBird()
		Drop()
	end
end

function SpriteSheetForBird()
	if(GetDie() == true)then return end
	if(Time.time > _nextRender) then
		_indexSprite = _indexSprite + 1
		if(_indexSprite > #_sprites) then
			_indexSprite = 1
		end
		_birdRender.sprite = _sprites[_indexSprite]
		_nextRender = Time.time + _delayRender
	end
end

function Drop()
	if(_isFlying == true) then
		self.transform.position = self.transform.position + Vector3.up * Time.deltaTime * 7
		if(Time.time > _timeFlyEnd) then
			_isFlying = false;
		end
		_g = 1
	else
		if(self.transform.position.y < -4.5) then
			return
		end
		self.transform.position = self.transform.position + Vector3.down * Time.deltaTime * _g
		local rotation = 25 -_g*5
		if(rotation < -90) then
			rotation = -90
		end
		self.transform.rotation = CS.UnityEngine.Quaternion.Euler(0, 0, rotation) 
		_g = _g + _g/20 + Time.deltaTime
	end
end

function Control()
	if(GetDie() == true)
	then
		if( Input.GetKeyDown(CS.UnityEngine.KeyCode.R)) then
			SetDie(false)
			_coin = 0
		end
		return
	end
	if(_isFlying == false and Input.GetKeyDown(CS.UnityEngine.KeyCode.Space)) then
		Fly();
	end
end

function Fly()
	_isFlying = true
	_timeFlyEnd = CS.UnityEngine.Time.time + _timeFlying
	self.transform.rotation = CS.UnityEngine.Quaternion.Euler(0, 0, 25) 
end

function onTriggerEnter2D(trigger)
	if(trigger == nil)
	then
		print("trigger is null!")
		return
	end
    trigger.gameObject:GetComponent(typeof(CS.LuaScript)):CallLuaFunc("OnTrigger", self)
end

function Score()
	_coin = _coin + 1
	print("Current coin: " .. _coin)
end

function Die()
	SetDie(true)
	print("Die with coin: " .. _coin)
end