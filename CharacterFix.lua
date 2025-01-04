
xlua.hotfix("FogTeam.KiemThe.Control.Component.Character", 
{
    ReloadAnimation = function(self)
        CS.TimeCount.Ping()
        coroutine.create(function()
            coroutine.yield(null)
            self.animation:sReload()
            self:ResumeCurrentAction()
            CS.TimeCount.Pong("ReloadAnimation")
        end)
    end;
});
