-- Generated by Mochi compiler v0.10.26 on 2025-07-15T07:50:43Z
function __eq(a, b)
    if type(a) ~= type(b) then return false end
    if type(a) == 'number' then return math.abs(a-b) < 1e-9 end
    if type(a) ~= 'table' then return a == b end
    if (a[1] ~= nil or #a > 0) and (b[1] ~= nil or #b > 0) then
        if #a ~= #b then return false end
        for i = 1, #a do if not __eq(a[i], b[i]) then return false end end
        return true
    end
    for k, v in pairs(a) do if not __eq(v, b[k]) then return false end end
    for k, _ in pairs(b) do if a[k] == nil then return false end end
    return true
end
function __json(v)
    if type(v) == 'table' and next(v) == nil then print('[]'); return end
    local function sort(x)
        if type(x) ~= 'table' then return x end
        if x[1] ~= nil or #x > 0 then
            local out = {}
            for i=1,#x do out[i] = sort(x[i]) end
            return out
        end
        local keys = {}
        for k in pairs(x) do keys[#keys+1] = k end
        table.sort(keys, function(a,b) return tostring(a)<tostring(b) end)
        local out = {}
        for _,k in ipairs(keys) do out[k] = sort(x[k]) end
        return out
    end
    local function enc(x)
        local t = type(x)
        if t == 'nil' then
            return 'null'
        elseif t == 'boolean' or t == 'number' then
            return tostring(x)
        elseif t == 'string' then
            return string.format('%q', x)
        elseif t == 'table' then
            if x[1] ~= nil or #x > 0 then
                local parts = {}
                for i=1,#x do parts[#parts+1] = enc(x[i]) end
                return '['..table.concat(parts, ',')..']'
            else
                local keys = {}
                for k in pairs(x) do keys[#keys+1] = k end
                table.sort(keys, function(a,b) return tostring(a)<tostring(b) end)
                local parts = {}
                for _,k in ipairs(keys) do parts[#parts+1] = enc(k)..':'..enc(x[k]) end
                return '{'..table.concat(parts, ',')..'}'
            end
        else
            return 'null'
        end
    end
    print(enc(sort(v)))
end
function __run_tests(tests)
    local function format_duration(d)
        if d < 1e-6 then return string.format('%dns', math.floor(d*1e9)) end
        if d < 1e-3 then return string.format('%.1fµs', d*1e6) end
        if d < 1 then return string.format('%.1fms', d*1e3) end
        return string.format('%.2fs', d)
    end
    local failures = 0
    for _, t in ipairs(tests) do
        io.write('   test ' .. t.name .. ' ...')
        local start = os.clock()
        local ok, err = pcall(t.fn)
        local dur = os.clock() - start
        if ok then
            io.write(' ok (' .. format_duration(dur) .. ')\n')
        else
            io.write(' fail ' .. tostring(err) .. ' (' .. format_duration(dur) .. ')\n')
            failures = failures + 1
        end
    end
    if failures > 0 then
        io.write('\n[FAIL] ' .. failures .. ' test(s) failed.\n')
    end
end
function __sum(v)
    local items
    if type(v) == 'table' and v.items ~= nil then
        items = v.items
    elseif type(v) == 'table' then
        items = v
    else
        error('sum() expects list or group')
    end
    local sum = 0
    for _, it in ipairs(items) do sum = sum + it end
    return sum
end
function test_TPCDS_Q87_sample()
    if not ((result == 87.0)) then error('expect failed') end
end

store_sales = {{["cust"]="A", ["price"]=5.0}, {["cust"]="B", ["price"]=30.0}, {["cust"]="C", ["price"]=57.0}}
catalog_sales = {{["cust"]="A"}}
web_sales = {}
store_customers = (function()
    local _res = {}
    for _, s in ipairs(store_sales) do
        _res[#_res+1] = s.cust
    end
    return _res
end)()
catalog_customers = (function()
    local _res = {}
    for _, s in ipairs(catalog_sales) do
        _res[#_res+1] = s.cust
    end
    return _res
end)()
web_customers = (function()
    local _res = {}
    for _, s in ipairs(web_sales) do
        _res[#_res+1] = s.cust
    end
    return _res
end)()
store_only = (function()
    local _res = {}
    for _, c in ipairs(store_customers) do
        if ((#(function()
    local _res = {}
    for _, x in ipairs(catalog_customers) do
        if __eq(x, c) then
            _res[#_res+1] = x
        end
    end
    return _res
end)() == 0) and (#(function()
    local _res = {}
    for _, x in ipairs(web_customers) do
        if __eq(x, c) then
            _res[#_res+1] = x
        end
    end
    return _res
end)() == 0)) then
            _res[#_res+1] = c
        end
    end
    return _res
end)()
result = __sum((function()
    local _res = {}
    for _, s in ipairs(store_sales) do
        if (#(function()
    local _res = {}
    for _, x in ipairs(store_only) do
        if __eq(x, s.cust) then
            _res[#_res+1] = x
        end
    end
    return _res
end)() > 0) then
            _res[#_res+1] = s.price
        end
    end
    return _res
end)())
__json(result)
local __tests = {
    {name="TPCDS Q87 sample", fn=test_TPCDS_Q87_sample},
}
