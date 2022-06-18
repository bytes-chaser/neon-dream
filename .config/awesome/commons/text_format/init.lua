local text_format = {}

text_format.shorting = function(text, threshold, last_index)

  if last_index == nil then
    last_index = threshold
  end

  if #text > threshold then
    text = text:sub(1, last_index) .. "..."
  end
  
  return text
end

return text_format
