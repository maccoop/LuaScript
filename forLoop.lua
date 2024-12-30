array = {"one", "two", "three"}
function start()
  for index, value in ipairs(array) 
  do
    print("Index: " .. index .. ", Value: " .. value)
  end
end