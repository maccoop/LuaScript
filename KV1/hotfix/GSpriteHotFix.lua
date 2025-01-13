
xlua.hotfix("FogTeam.GameEngine.Sprite.GSprite",
{
    ProcessWalk = function(self)
        print("ProcessWalk hotfix")
        CS.TimeCount.Ping()
        if (self.ComponentCharacter ~= nil)
        then
            self.ComponentCharacter:Walk();
        -- Nếu là quái
        elseif (self.ComponentMonster ~= nil)
        then
            self.ComponentMonster:Run()
        end
        CS.TimeCount.Pong("Hotfix GSprite")
    end;
    ProcessRun = function(self)
        print("ProcessRun hotfix")
        CS.TimeCount.Ping()
        if (self.ComponentCharacter ~= nil)
        then
            self.ComponentCharacter:Run();
        -- Nếu là quái
        elseif (self.ComponentMonster ~= nil)
        then
            self.ComponentMonster:Run()
        end
        CS.TimeCount.Pong("Hotfix GSprite")
    end;
});
