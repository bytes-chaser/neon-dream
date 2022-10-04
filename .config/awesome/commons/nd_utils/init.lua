
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
  end,

  split = function(text, delimiter)
      result = {};

      for match in (text .. delimiter):gmatch("(.-)"..delimiter) do
          table.insert(result, match);
      end

      return result;
  end,

  is_file_exists = function(path)
      local f= io.open(path,"r")
      if f ~= nil then
          io.close(f)
          return true
      else
          return false
      end
  end
}
