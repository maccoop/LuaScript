a = 0
b = 0
next = 0
delay = 0.5

function start()
	print("Start...")
	a = 0
	b = 0
	next = 0
	local obj = CS.UnityEngine.GameObject("Create Obj")
	local render = obj:AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
	LoadAndApplyImage(obj,"https://picsum.photos/200/300")
end

function LoadAndApplyImage(gameObject, url)
    CS.UnityEngine.Coroutine.Start(function()
        local www = CS.UnityEngine.WWW(url)
        while not www.isDone do
            CS.UnityEngine.Yield(nil)
        end

        if www.error ~= nil then
            print("Error downloading image: " .. www.error)
        else
            local texture = www.texture
            local renderer = gameObject:GetComponent(typeof(CS.UnityEngine.Renderer))
            if renderer then
                renderer.material.mainTexture = texture
            end
        end
    end)
end

function update()
	print("Update...")
	if(CS.UnityEngine.Time.time > next)
	then
		a = a + 1
		b = b + 2
		next = CS.UnityEngine.Time.time + delay
		print(string.format("haa = %s, bbb = %s",a,b))
	end
end
