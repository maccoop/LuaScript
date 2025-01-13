
function start()
    local value = {"cai gi co", " the a", "uh nhi"}
    local list = CS.LuaScriptsHelper.ArrayToListNonGeneric(typeof(CS.System.String),value);
    for item in list
    do
        print(item);
    end
end
