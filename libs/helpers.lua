local module = {}

module.sleep = function(n)
  local t = os.clock()
  while os.clock() - t <= n do
    -- nothing
  end
end
return module
