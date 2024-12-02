
local function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

local function copy_table(table_to_copy)
    local copy = {}
    for k, v in pairs(table_to_copy) do
        table.insert(copy, k, v)
    end
    return copy
end

local function split_string(inputstr, sep)
    if sep == nil then
      sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
    end
    return t
  end

local function calculate_diffs(line)
    local array = line
    local diffs = {}

    for i = 1, #array - 1, 1 do
        local current = array[i]
        local next = array[i + 1]
        table.insert(diffs, current - next)
    end
    return diffs
end

local function is_report_safe(line)
    local diffs = calculate_diffs(line)
    local count = 0

    for i=1, #diffs, 1 do
        local diff = diffs[i]
        if -4 < diff and diff < 0 then
            count = count - 1
        
        elseif 0 < diff and diff < 4 then
            count = count + 1

        else
            return false
        end
    end

    return math.abs(count) == #diffs
end

local function read_file(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end

local function get_permutations(array)
    local permutations = {}
    for i, _ in pairs(array) do
        local copy = copy_table(array)
        table.remove(copy, i)
        table.insert(permutations, copy)
    end
    return permutations
end

local content = read_file('C:/Users/marti/Documents/AoC/AoC-2024/2/input.txt')
local reports = split_string(content, "\n")

local safe_reports = 0
for i, report in pairs(reports) do
    local permutations = get_permutations(split_string(report, " "))
    print(dump(permutations))
    for _, permutation in pairs(permutations) do
        if is_report_safe(permutation) then
            safe_reports = safe_reports + 1
            break
        end
    end
end

print(safe_reports)