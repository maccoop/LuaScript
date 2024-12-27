a = 0
b = 0
next = 0
delay = 0.5
obj = null

function start()
	print("Start...")
	a = 0
	b = 0
	next = 0
	obj = CS.UnityEngine.GameObject("Create Obj")
	local render = obj:AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
	local loader = obj:AddComponent(typeof(CS.ImageLoader))
	loader:LoadImage("https://picsum.photos/200/300", render)
end

function update()
	obj.transform.posiion = CS.UnityEngine.Input.mousePosition
end
