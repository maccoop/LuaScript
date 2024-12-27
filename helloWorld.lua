a = 0
b = 0
next = 0
delay = 0.5

function start()
	print("Start...")
	a = 0
	b = 0
	next = 0
	local obj = CS.UnityEngine.GameObject("Create Obj");
	local render = obj:AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
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
