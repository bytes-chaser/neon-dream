
nd_utils = {
  arr_contains = function(arr, val)
    for index, value in ipairs(arr) do
        if value == val then
            return true
        end
    end

    return false
  end,

  copy = function(source)
    local result = {}

    for k, v in pairs(source) do
      result[k] = v
    end

    return result
  end
}
