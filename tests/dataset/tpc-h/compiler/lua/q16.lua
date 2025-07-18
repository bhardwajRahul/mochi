-- Generated by Mochi compiler v0.10.28 on 2025-07-18T03:35:39Z
function __contains(container, item)
    if type(container) == 'table' then
        if container[1] ~= nil or #container > 0 then
            for _, v in ipairs(container) do
                if v == item then return true end
            end
            return false
        else
            return container[item] ~= nil
        end
    elseif type(container) == 'string' then
        local i = string.find(container, item, 1, true)
        if i then return i else return 0 end
    else
        return false
    end
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
function __query(src, joins, opts)
    local whereFn = opts.where
    local items = {}
    if #joins == 0 and whereFn then
        for _, v in ipairs(src) do if whereFn(v) then items[#items+1] = {v, n=1} end end
    else
        for _, v in ipairs(src) do items[#items+1] = {v, n=1} end
    end
    for ji, j in ipairs(joins) do
        local joined = {}
        local jitems = j.items or {}
        if j.right and j.left then
            local matched = {}
            for _, left in ipairs(items) do
                local m = false
                for ri, right in ipairs(jitems) do
                    local leftLen = left.n or #left
                    local keep = true
                    if j.on then
                        local args = {table.unpack(left,1,leftLen)}
                        args[leftLen+1] = right
                        keep = j.on(table.unpack(args,1,leftLen+1))
                    end
                    if keep then
                        m = true; matched[ri] = true
                        local row = {table.unpack(left,1,leftLen)}
                        row[leftLen+1] = right
                        row.n = leftLen + 1
                        if ji == #joins and whereFn and not whereFn(table.unpack(row,1,row.n or #row)) then
                        else
                            joined[#joined+1] = row
                        end
                    end
                end
                if not m then
                    local leftLen = left.n or #left
                    local row = {table.unpack(left,1,leftLen)}
                    row[leftLen+1] = nil
                    row.n = leftLen + 1
                    if ji == #joins and whereFn and not whereFn(table.unpack(row,1,row.n or #row)) then
                    else
                        joined[#joined+1] = row
                    end
                end
            end
            for ri, right in ipairs(jitems) do
                if not matched[ri] then
                    local row = {}
                    for _=1,ji do row[#row+1] = nil end
                    row[#row+1] = right
                    if ji == #joins and whereFn and not whereFn(table.unpack(row,1,row.n or #row)) then
                    else
                        joined[#joined+1] = row
                    end
                end
            end
        elseif j.right then
            for _, right in ipairs(jitems) do
                local m = false
                for _, left in ipairs(items) do
                    local leftLen = left.n or #left
                    local keep = true
                    if j.on then
                        local args = {table.unpack(left,1,leftLen)}
                        args[leftLen+1] = right
                        keep = j.on(table.unpack(args,1,leftLen+1))
                    end
                    if keep then
                        m = true
                        local row = {table.unpack(left,1,leftLen)}
                        row[leftLen+1] = right
                        row.n = leftLen + 1
                        if ji == #joins and whereFn and not whereFn(table.unpack(row,1,row.n or #row)) then
                        else
                            joined[#joined+1] = row
                        end
                    end
                end
                if not m then
                    local row = {}
                    for _=1,ji do row[#row+1] = nil end
                    row[#row+1] = right
                    row.n = ji + 1
                    if ji == #joins and whereFn and not whereFn(table.unpack(row,1,row.n or #row)) then
                    else
                        joined[#joined+1] = row
                    end
                end
            end
        else
            for _, left in ipairs(items) do
                local m = false
                for _, right in ipairs(jitems) do
                    local leftLen = left.n or #left
                    local keep = true
                    if j.on then
                        local args = {table.unpack(left,1,leftLen)}
                        args[leftLen+1] = right
                        keep = j.on(table.unpack(args,1,leftLen+1))
                    end
                    if keep then
                        m = true
                        local row = {table.unpack(left,1,leftLen)}
                        row[leftLen+1] = right
                        row.n = leftLen + 1
                        if ji == #joins and whereFn and not whereFn(table.unpack(row,1,row.n or #row)) then
                        else
                            joined[#joined+1] = row
                        end
                    end
                end
                if j.left and not m then
                    local leftLen = left.n or #left
                    local row = {table.unpack(left,1,leftLen)}
                    row[leftLen+1] = nil
                    row.n = leftLen + 1
                    if ji == #joins and whereFn and not whereFn(table.unpack(row,1,row.n or #row)) then
                    else
                        joined[#joined+1] = row
                    end
                end
            end
        end
        items = joined
    end
    if opts.sortKey then
        local pairs = {}
        for _, it in ipairs(items) do pairs[#pairs+1] = {item=it, key=opts.sortKey(table.unpack(it,1,it.n or #it))} end
        table.sort(pairs, function(a,b)
            local ak, bk = a.key, b.key
            if type(ak)=='number' and type(bk)=='number' then return ak < bk end
            if type(ak)=='string' and type(bk)=='string' then return ak < bk end
            return tostring(ak) < tostring(bk)
        end)
        items = {}
        for i,p in ipairs(pairs) do items[i] = p.item end
    end
    if opts.skip ~= nil then
        local n = opts.skip
        if n < #items then
            for i=1,n do table.remove(items,1) end
        else
            items = {}
        end
    end
    if opts.take ~= nil then
        local n = opts.take
        if n < #items then
            for i=#items, n+1, -1 do table.remove(items) end
        end
    end
    local res = {}
    for _, r in ipairs(items) do res[#res+1] = opts.selectFn(table.unpack(r,1,r.n or #r)) end
    return res
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
function test_Q16_returns_suppliers_not_linked_to_certain_parts_or_complaints()
    if not ((result == {})) then error('expect failed') end
end

supplier = {{["s_suppkey"]=100, ["s_name"]="AlphaSupply", ["s_address"]="123 Hilltop", ["s_comment"]="Reliable and efficient"}, {["s_suppkey"]=200, ["s_name"]="BetaSupply", ["s_address"]="456 Riverside", ["s_comment"]="Known for Customer Complaints"}}
part = {{["p_partkey"]=1, ["p_brand"]="Brand#12", ["p_type"]="SMALL ANODIZED", ["p_size"]=5}, {["p_partkey"]=2, ["p_brand"]="Brand#23", ["p_type"]="MEDIUM POLISHED", ["p_size"]=10}}
partsupp = {{["ps_partkey"]=1, ["ps_suppkey"]=100}, {["ps_partkey"]=2, ["ps_suppkey"]=200}}
excluded_suppliers = (function()
    local _src = partsupp
    return __query(_src, {
        { items = part, on = function(ps, p) return (p.p_partkey == ps.ps_partkey) end }
    }, { selectFn = function(ps, p) return ps.ps_suppkey end, where = function(ps, p) return ((((p.p_brand == "Brand#12") and __contains(p.p_type, "SMALL")) and (p.p_size == 5))) end })
end)()
result = (function()
    local _res = {}
    for _, s in ipairs(supplier) do
        if ((not ((function(_l,_v) for _,x in ipairs(_l) do if x == _v then return true end end return false end)(excluded_suppliers,s.s_suppkey)) and (not __contains(s.s_comment, "Customer"))) and (not __contains(s.s_comment, "Complaints"))) then
            _res[#_res+1] = {__key = s.s_name, __val = {["s_name"]=s.s_name, ["s_address"]=s.s_address}}
        end
    end
    local items = _res
    table.sort(items, function(a,b)
        local ak, bk = a.__key, b.__key
        if type(ak)=='number' and type(bk)=='number' then return ak < bk end
        if type(ak)=='string' and type(bk)=='string' then return ak < bk end
        return tostring(ak) < tostring(bk)
    end)
    local tmp = {}
    for _, it in ipairs(items) do tmp[#tmp+1] = it.__val end
    items = tmp
    _res = items
    return _res
end)()
__json(result)
local __tests = {
    {name="Q16 returns suppliers not linked to certain parts or complaints", fn=test_Q16_returns_suppliers_not_linked_to_certain_parts_or_complaints},
}
