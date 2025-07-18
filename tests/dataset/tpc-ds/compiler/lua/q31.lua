-- Generated by Mochi compiler v0.10.26 on 2025-07-15T07:50:43Z
function __append(lst, v)
    local out = {}
    if lst then for i = 1, #lst do out[#out+1] = lst[i] end end
    out[#out+1] = v
    return out
end
function __div(a, b)
    if math.type and math.type(a) == 'integer' and math.type(b) == 'integer' then
        return a // b
    end
    return a / b
end
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
function test_TPCDS_Q31_simplified()
    if not (__eq(result, {{["ca_county"]="A", ["d_year"]=2000, ["web_q1_q2_increase"]=1.5, ["store_q1_q2_increase"]=1.2, ["web_q2_q3_increase"]=1.6666666666666667, ["store_q2_q3_increase"]=1.3333333333333333}})) then error('expect failed') end
end

store_sales = {{["ca_county"]="A", ["d_qoy"]=1, ["d_year"]=2000, ["ss_ext_sales_price"]=100.0}, {["ca_county"]="A", ["d_qoy"]=2, ["d_year"]=2000, ["ss_ext_sales_price"]=120.0}, {["ca_county"]="A", ["d_qoy"]=3, ["d_year"]=2000, ["ss_ext_sales_price"]=160.0}, {["ca_county"]="B", ["d_qoy"]=1, ["d_year"]=2000, ["ss_ext_sales_price"]=80.0}, {["ca_county"]="B", ["d_qoy"]=2, ["d_year"]=2000, ["ss_ext_sales_price"]=90.0}, {["ca_county"]="B", ["d_qoy"]=3, ["d_year"]=2000, ["ss_ext_sales_price"]=100.0}}
web_sales = {{["ca_county"]="A", ["d_qoy"]=1, ["d_year"]=2000, ["ws_ext_sales_price"]=100.0}, {["ca_county"]="A", ["d_qoy"]=2, ["d_year"]=2000, ["ws_ext_sales_price"]=150.0}, {["ca_county"]="A", ["d_qoy"]=3, ["d_year"]=2000, ["ws_ext_sales_price"]=250.0}, {["ca_county"]="B", ["d_qoy"]=1, ["d_year"]=2000, ["ws_ext_sales_price"]=80.0}, {["ca_county"]="B", ["d_qoy"]=2, ["d_year"]=2000, ["ws_ext_sales_price"]=90.0}, {["ca_county"]="B", ["d_qoy"]=3, ["d_year"]=2000, ["ws_ext_sales_price"]=95.0}}
counties = {"A", "B"}
result = {}
for _, county in ipairs(counties) do
    local ss1 = __sum((function()
    local _res = {}
    for _, s in ipairs(store_sales) do
        if (__eq(s.ca_county, county) and __eq(s.d_qoy, 1)) then
            _res[#_res+1] = s.ss_ext_sales_price
        end
    end
    return _res
end)())
    local ss2 = __sum((function()
    local _res = {}
    for _, s in ipairs(store_sales) do
        if (__eq(s.ca_county, county) and __eq(s.d_qoy, 2)) then
            _res[#_res+1] = s.ss_ext_sales_price
        end
    end
    return _res
end)())
    local ss3 = __sum((function()
    local _res = {}
    for _, s in ipairs(store_sales) do
        if (__eq(s.ca_county, county) and __eq(s.d_qoy, 3)) then
            _res[#_res+1] = s.ss_ext_sales_price
        end
    end
    return _res
end)())
    local ws1 = __sum((function()
    local _res = {}
    for _, w in ipairs(web_sales) do
        if (__eq(w.ca_county, county) and __eq(w.d_qoy, 1)) then
            _res[#_res+1] = w.ws_ext_sales_price
        end
    end
    return _res
end)())
    local ws2 = __sum((function()
    local _res = {}
    for _, w in ipairs(web_sales) do
        if (__eq(w.ca_county, county) and __eq(w.d_qoy, 2)) then
            _res[#_res+1] = w.ws_ext_sales_price
        end
    end
    return _res
end)())
    local ws3 = __sum((function()
    local _res = {}
    for _, w in ipairs(web_sales) do
        if (__eq(w.ca_county, county) and __eq(w.d_qoy, 3)) then
            _res[#_res+1] = w.ws_ext_sales_price
        end
    end
    return _res
end)())
    local web_g1 = __div(ws2, ws1)
    local store_g1 = __div(ss2, ss1)
    local web_g2 = __div(ws3, ws2)
    local store_g2 = __div(ss3, ss2)
    if ((web_g1 > store_g1) and (web_g2 > store_g2)) then
        result = __append(result, {["ca_county"]=county, ["d_year"]=2000, ["web_q1_q2_increase"]=web_g1, ["store_q1_q2_increase"]=store_g1, ["web_q2_q3_increase"]=web_g2, ["store_q2_q3_increase"]=store_g2})
    end
end
__json(result)
local __tests = {
    {name="TPCDS Q31 simplified", fn=test_TPCDS_Q31_simplified},
}
