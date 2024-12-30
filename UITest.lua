
button = nil

function start()
	local prefab = CS.UnityEngine.Resources.Load("UITest");
	local ui = CS.UnityEngine.Object.Instantiate(prefab, nil)
	button = ui:GetComponentInChildren(typeof(CS.UnityEngine.UI.Button))
	button.onClick:AddListener(OnClick)
end

function OnClick()
	print("Button Click!")
	local flappy = require "flappy"
	flappy.Fly();
end
