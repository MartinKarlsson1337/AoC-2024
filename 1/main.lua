local function calculate_total_distance(a, b)
    local diffs = 0
    for k, _ in pairs(a) do
        diffs = diffs + math.abs(a[k] - b[k])  
    end
    return diffs
end

local function calculate_similarity_score(a, b)
  local left_index = 1
  local right_index = 1

  local similarity_score = 0

  while left_index <= #a and right_index <= #b do

    if a[left_index] == b[right_index] then
      similarity_score = similarity_score + a[left_index]
      right_index = right_index + 1

    elseif a[left_index] < b[right_index] then
      left_index = left_index + 1

    elseif a[left_index] > b[right_index] then
      right_index = right_index + 1
    end

  end

  return similarity_score
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

local function read_file(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local line = file:read "*l"

    local list1 = {}
    local list2 = {}

    while line ~= nil do
        local split = split_string(line, " ")
        table.insert(list1, split[1])
        table.insert(list2, split[2])

        line = file:read "*l"
    end
    file:close()
    return list1, list2
end

local list1, list2 = read_file('C:/Users/marti/Documents/AoC/advent-of-code/2024/martin/1/part_one/input.txt')

if list1 ~= nil and list2 ~= nil then
    table.sort(list1)
    table.sort(list2)

    local distance = calculate_similarity_score(list1, list2)
    print(distance)
end




