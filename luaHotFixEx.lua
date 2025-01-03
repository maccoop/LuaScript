local main = CS.main
xlua.hotfix(main, "Update", function(self)
    local first = CS.DateTime.Now
    for i = 1,10000
    then
        print("call at " ... self.Index ... ": " + i);
    end
    local second = CS.DateTime.Now
    local difference = second:Subtract(first) -- Use the Subtract method
    print("Time difference in milliseconds: " .. difference.TotalMilliseconds)
end)
xlua.hotfix(main, "Start", function(self)
    print("Create from hotfix")
end)
