function await(awaitable, continuation)
    local awaiter = awaitable:GetAwaiter()
    if awaiter.IsCompleted then
        local result = awaiter:GetResult()
        continuation(result)
    else
        awaiter:UnsafeOnCompleted(function ()
            local result = awaiter:GetResult()
            continuation(result)
        end)
    end
end