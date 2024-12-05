local helpers = {}
function helpers.read_file(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end

function helpers.split_string(inputstr, sep)
    if sep == nil then
      sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
    end
    return t
end

function helpers.string_to_table(str)
  local t={}
  str:gsub(".",function(c) table.insert(t,c) end)
  return t
end

function helpers.table_to_string(o)
  if type(o) == 'table' then
     local s = ''
     for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. helpers.table_to_string(v)
     end
     return s .. ''
  else
     return tostring(o)
  end
end

function helpers.read_range(input, start, stop)
  local text = {}
  for i=start, stop, 1 do
      text[i-start+1] = string.sub(input, i, i)
  end
  return table.concat(text, '')
end

return helpers