local helpers = require '../helpers'

local content = helpers.read_file('C:/Users/marti/Documents/AoC/AoC-2024/4/input.txt')
local string_rows = helpers.split_string(content, '\n')

local rows = {}
for i, row in pairs(string_rows) do
    local columns = row
    table.insert(rows, helpers.string_to_table(columns))
end

local function get_rows(tbl)
    local rows = {}
    for _, row in pairs(tbl) do
        table.insert(rows, helpers.table_to_string(row))
    end
    return rows
end

local function get_cols(tbl)
    local cols = {}

    for i, row in pairs(tbl) do
        local c = {}
        for j, col in pairs(row) do
            table.insert(c, tbl[j][i])
        end
        table.insert(cols, table.concat(c))
    end
    return cols
end

local function get_diagonals(tbl)
    local diagonals = {}
    
    for i=1, #tbl, 1 do
        local diagonal = {}

        for j=1, #tbl - i + 1, 1 do
            table.insert(diagonal, tbl[j][j+i-1])
        end
        table.insert(diagonals, helpers.table_to_string(diagonal))
    end

    for i=2, #tbl, 1 do
        local diagonal = {}

        for j=1, #tbl, 1 do
            table.insert(diagonal, tbl[j][j-i+1])
        end
        table.insert(diagonals, helpers.table_to_string(diagonal))
    end

    for i=1, #tbl, 1 do
        local diagonal = {}
        for j=i, #tbl, 1 do
            table.insert(diagonal, tbl[j][#tbl-j+i])
        end
        table.insert(diagonals, helpers.table_to_string(diagonal))
    end

    for i=1, #tbl, 1 do
        local diagonal = {}
        for j=1, #tbl - i + 1, 1 do
            table.insert(diagonal, tbl[j][#tbl - j - i + 1])
        end
        table.insert(diagonals, helpers.table_to_string(diagonal))
    end

    return diagonals
end

local function x_kernel(tbl, row, col)
    local diagonal1 = {
        tbl[row-1][col-1],
        tbl[row][col],
        tbl[row+1][col+1]
    }
    local diagonal2 = {
        tbl[row-1][col+1],
        tbl[row][col],
        tbl[row+1][col-1]
    }
    local diagonals = {diagonal1, diagonal2}
    return diagonals
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


-- local diag = get_diagonals(rows)
-- local count = 0
-- for _, i in pairs(diag) do
--     for s in string.gmatch(i, 'XMAS') do
--         count = count + 1
--     end

--     for s in string.gmatch(i, 'SAMX') do
--         count = count + 1
--     end

-- end

-- local r = get_rows(rows)
-- for _, i in pairs(r) do
--     for s in string.gmatch(i, 'XMAS') do
--         count = count + 1
--     end

--     for s in string.gmatch(i, 'SAMX') do
--         count = count + 1
--     end 
-- end

-- local c = get_cols(rows)
-- for _, i in pairs(c) do
--     for s in string.gmatch(i, 'XMAS') do
--         count = count + 1
--     end

--     for s in string.gmatch(i, 'SAMX') do
--         count = count + 1
--     end 
-- end


local r = get_rows(rows)

local valid = {
    'MASMAS',
    'MASSAM',
    'SAMMAS',
    'SAMSAM'
}
local count = 0
local a_count = 0
local a2 = 0
for i=2, #r - 1, 1 do
    for j, e in pairs(rows[i]) do
        if e == 'A' then
            local x_pattern = x_kernel(rows, i, j)
            local x_string = helpers.table_to_string(x_pattern)
            for _, v in pairs(valid) do
                if x_string == v then
                    count = count + 1
                    break
                end
            end
            a_count = a_count + 1
        end
    end
end
print(count)
print(a_count)
print(a2)

