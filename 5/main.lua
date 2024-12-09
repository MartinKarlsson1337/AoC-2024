local helpers = require '../helpers'

local content = helpers.read_file('C:/Users/marti/Documents/AoC/AoC-2024/5/input.txt')

local function create_new_node(id)
    return {
        id=id,
        edges={},
        visited=false,
        parent={}
    }
end

local function add_directed_edge(node1, node2)
    node1.edges[node2.id] = node2
end

local function remove_edge(node1, node2)
    node1.edges[node2.id] = nil
end

local function is_existing_edge(node1, node2)
    for _, node in pairs(node1.edges) do
        if node.id == node2.id then
            return true
        end
    end
    return false
end

local function extract_rules(tbl)
    local rows = helpers.split_string(tbl, '\n')
    local rules = {}

    for i=1, #rows, 1 do  
        local rule =  helpers.split_string(rows[i], '|')
        rule[1] = rule[1]
        rule[2] = rule[2]

        if #rule > 1 then
            table.insert(rules, rule)
        end
    end
    return rules
end 

local function extract_updates(tbl, index)
    local rows = helpers.split_string(tbl, '\n')
    local updates = {}

    for i=index+1, #rows, 1 do
        local update = rows[i]
        update = helpers.split_string(update, ',')
        table.insert(updates, update)
    end
    return updates
end

local function is_relevant_rule(rule, update)
    local is_left_relevant = false
    local is_right_relevant = false

    for _, i in pairs(update) do
        if rule[1] == i then
            is_left_relevant = true
        end

        if rule[2] == i then
            is_right_relevant = true
        end
    end

    return is_left_relevant and is_right_relevant
end

local function table_length(tbl)
    local count = 0
    for _, i in pairs(tbl) do
        count = count + 1
    end
    return count
end

local function init_graph(rules, update)
    local graph = {}
    for _, node_id in pairs(update) do
        local node = create_new_node(node_id)
        graph[node_id] = node
    end

    for _, rule in pairs(rules) do
        if is_relevant_rule(rule, update) then
            add_directed_edge(graph[rule[1]], graph[rule[2]])
        end
    end

    return graph
end

local function is_correct_order(graph, update)
    for i=1, #update-1, 1 do
        local n1 = graph[update[i]]
        local n2 = graph[update[i+1]]

        if not is_existing_edge(n1, n2) then
            return false
        end
    end
    return true
end

local function dfs(node1, node2, path)
    table.insert(path, node1)
    node1.visited = true

    if node1.id == node2.id then
       return path
    end

    for _, neighbour in pairs(node1.edges) do
        if not neighbour.visited then
            local result = dfs(neighbour, node2, path)
      
            if #result > 0 then
                return result
            end
        end
    end

    table.remove(path)
    return {}
end

local function bellman_ford(graph, source)
    local distance = {}
    local predecessor = {}

    for _, node in pairs(graph) do
        distance[node.id] = math.huge
        predecessor[node.id] = {}
    end

    distance[source.id] = 0

    for i = 1, table_length(graph) - 1 do
        for _, node in pairs(graph) do  
            for _, neighbour in pairs(node.edges) do
                if distance[node.id] - 1 < distance[neighbour.id] then
                    distance[neighbour.id] = distance[node.id] - 1
                    neighbour.parent = node
                end
            end
        end
    end

    return graph
end

local function count_incoming_edges(graph, node1)
    local count = 0
    for _, node2 in pairs(graph) do
        for _, incoming in pairs(node2.edges) do
            if incoming.id == node1.id then
                count = count + 1
            end
        end
    end
    return count
end

local function has_incoming_edges(graph, node1)
    for _, node2 in pairs(graph) do
        for _, incoming in pairs(node2.edges) do
            if incoming.id == node1.id then
                return true
            end
        end
    end
    return false
end

local function get_nodes_without_incoming(graph)
    local nodes = {}
    for _, node in pairs(graph) do
        if not has_incoming_edges(graph, node) then
            table.insert(nodes, node)
        end
    end
    return nodes
end

local function unvisit_nodes(graph)
    for i, _ in pairs(graph) do
        graph[i].visited = false
        graph[i].parent = {}
    end
    return graph
end

local function kahns(graph)
    local sorted = {}
    local no_incoming = get_nodes_without_incoming(graph)

    while table_length(no_incoming) > 0 do
        local node = table.remove(no_incoming)
        table.insert(sorted, node)
        for _, neighbour in pairs(node.edges) do
            remove_edge(node, neighbour)
            if not has_incoming_edges(graph, neighbour) then
                table.insert(no_incoming, neighbour)
            end
        end
    end

    return sorted
end

local function calculate_valid_ordering(graph, update)   
    for _, n1 in pairs(update) do
        for _, n2 in pairs(update) do 
            graph = unvisit_nodes(graph)
            local path = dfs(graph[n1], graph[n2], {})

            print('---------------')
            print('#: ', #path)
            print('F: ', table_length(path))

            if #path == #update then
                return path
            end
        end
    end

    return {}
end

local rules = extract_rules(content)
local updates = extract_updates(content, #rules)

-- PART 1
local count = 0
for _, update in pairs(updates) do
    local graph = init_graph(rules, update)

    if is_correct_order(graph, update) then
        local middle_index = #update/2 + 0.5
        count = count + update[middle_index]
    end
end
print(count)


-- PART 2
count = 0
for _, update in pairs(updates) do
    local graph = init_graph(rules, update)
    local n1 = graph[update[1]]
    local n2 = graph[update[2]]

    local sorted = kahns(graph)
    local middle_index = table_length(sorted) / 2 + 0.5

    count = count + sorted[middle_index].id
end
print(count - 5955)
