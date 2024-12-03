
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
    local content = file:read "*a"
    file:close()
    return content
end

local function read_range(input, start, stop)
    local text = {}
    for i=start, stop, 1 do
        text[i-start+1] = string.sub(input, i, i)
    end
    return table.concat(text, '')
end

local function get_next_token(input, patterns, init)
    
    local current_start = #input
    local current_end = #input

    if init == nil then
        for i, pattern in pairs(patterns) do
            local m_start, m_end = string.find(input, pattern)

            if m_start < current_start then 
                current_start = m_start
                current_end = m_end
            end
        end

    else
        for i, pattern in pairs(patterns) do
            local m_start, m_end  = string.find(input, pattern, init)
            
            if m_start == nil then
                
            
            elseif m_start < current_start then 
                current_start = m_start
                current_end = m_end
            end
        end
    end
    return current_start, current_end
end

local content = read_file('C:/Users/marti/Documents/AoC/AoC-2024/3/input.txt')
local sum = 0
local is_mul_enabled = true

local tokens = {
    "mul%(%d+,%d+%)",
    "don't%(%)",
    "do%(%)",
    
}

local init = 1

while init < #content do
    local s, e  = get_next_token(content, tokens, init)
    local matching_string = read_range(content, s, e)

    local operator = split_string(matching_string, '(')[1]

    if operator == "do" then
        is_mul_enabled = true
    end

    if operator == "don't" then
        is_mul_enabled = false
    end

    if operator == 'mul' and is_mul_enabled then
        local product = 1
        for operand in string.gmatch(matching_string, '%d+') do
            product = product * tonumber(operand)
        end
        sum = sum + product
    end
    init = s + 1
end
print(sum)

