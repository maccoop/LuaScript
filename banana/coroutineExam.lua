local util = require 'xlua.util'
local cs_coroutine = require 'cs_coroutine'

local cs = cs_coroutine.start(function()
    print('start coroutine')
    coroutine.yield(CS.UnityEngine.WaitForSeconds(3));
    print('yield wait 3s done')
end);