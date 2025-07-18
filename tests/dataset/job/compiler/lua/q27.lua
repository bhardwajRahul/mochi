-- Generated by Mochi compiler v0.10.25 on 2025-07-13T12:51:15Z
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
        return string.find(container, item, 1, true) ~= nil
    else
        return false
    end
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
    local ok, json = pcall(require, 'json')
    if not ok then ok, json = pcall(require, 'cjson') end
    if ok then
        print(json.encode(sort(v)))
        return
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
function __min(v)
    local items
    if type(v) == 'table' and v.items ~= nil then
        items = v.items
    elseif type(v) == 'table' then
        items = v
    else
        error('min() expects list or group')
    end
    if #items == 0 then return 0 end
    local m = items[1]
    if type(m) == 'string' then
        for i=2,#items do
            local it = items[i]
            if type(it) == 'string' and it < m then m = it end
        end
        return m
    else
        m = tonumber(m)
        for i=2,#items do
            local n = tonumber(items[i])
            if n < m then m = n end
        end
        return m
    end
end
function __query(src, joins, opts)
    local whereFn = opts.where
    local items = {}
    if #joins == 0 and whereFn then
        for _, v in ipairs(src) do if whereFn(v) then items[#items+1] = {v} end end
    else
        for _, v in ipairs(src) do items[#items+1] = {v} end
    end
    for ji, j in ipairs(joins) do
        local joined = {}
        local jitems = j.items or {}
        if j.right and j.left then
            local matched = {}
            for _, left in ipairs(items) do
                local m = false
                for ri, right in ipairs(jitems) do
                    local keep = true
                    if j.on then
                        local args = {table.unpack(left)}
                        args[#args+1] = right
                        keep = j.on(table.unpack(args))
                    end
                    if keep then
                        m = true; matched[ri] = true
                        local row = {table.unpack(left)}
                        row[#row+1] = right
                        if ji == #joins and whereFn and not whereFn(table.unpack(row)) then
                        else
                            joined[#joined+1] = row
                        end
                    end
                end
                if not m then
                    local row = {table.unpack(left)}
                    row[#row+1] = nil
                    if ji == #joins and whereFn and not whereFn(table.unpack(row)) then
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
                    if ji == #joins and whereFn and not whereFn(table.unpack(row)) then
                    else
                        joined[#joined+1] = row
                    end
                end
            end
        elseif j.right then
            for _, right in ipairs(jitems) do
                local m = false
                for _, left in ipairs(items) do
                    local keep = true
                    if j.on then
                        local args = {table.unpack(left)}
                        args[#args+1] = right
                        keep = j.on(table.unpack(args))
                    end
                    if keep then
                        m = true
                        local row = {table.unpack(left)}
                        row[#row+1] = right
                        if ji == #joins and whereFn and not whereFn(table.unpack(row)) then
                        else
                            joined[#joined+1] = row
                        end
                    end
                end
                if not m then
                    local row = {}
                    for _=1,ji do row[#row+1] = nil end
                    row[#row+1] = right
                    if ji == #joins and whereFn and not whereFn(table.unpack(row)) then
                    else
                        joined[#joined+1] = row
                    end
                end
            end
        else
            for _, left in ipairs(items) do
                local m = false
                for _, right in ipairs(jitems) do
                    local keep = true
                    if j.on then
                        local args = {table.unpack(left)}
                        args[#args+1] = right
                        keep = j.on(table.unpack(args))
                    end
                    if keep then
                        m = true
                        local row = {table.unpack(left)}
                        row[#row+1] = right
                        if ji == #joins and whereFn and not whereFn(table.unpack(row)) then
                        else
                            joined[#joined+1] = row
                        end
                    end
                end
                if j.left and not m then
                    local row = {table.unpack(left)}
                    row[#row+1] = nil
                    if ji == #joins and whereFn and not whereFn(table.unpack(row)) then
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
        for _, it in ipairs(items) do pairs[#pairs+1] = {item=it, key=opts.sortKey(table.unpack(it))} end
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
    for _, r in ipairs(items) do res[#res+1] = opts.selectFn(table.unpack(r)) end
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
function test_Q27_selects_minimal_company__link_and_title()
    if not (__eq(result, {["producing_company"]="Best Film", ["link_type"]="follows", ["complete_western_sequel"]="Western Sequel"})) then error('expect failed') end
end

comp_cast_type = {{["id"]=1, ["kind"]="cast"}, {["id"]=2, ["kind"]="crew"}, {["id"]=3, ["kind"]="complete"}}
complete_cast = {{["movie_id"]=1, ["subject_id"]=1, ["status_id"]=3}, {["movie_id"]=2, ["subject_id"]=2, ["status_id"]=3}}
company_name = {{["id"]=1, ["name"]="Best Film", ["country_code"]="[se]"}, {["id"]=2, ["name"]="Polish Film", ["country_code"]="[pl]"}}
company_type = {{["id"]=1, ["kind"]="production companies"}, {["id"]=2, ["kind"]="other"}}
keyword = {{["id"]=1, ["keyword"]="sequel"}, {["id"]=2, ["keyword"]="remake"}}
link_type = {{["id"]=1, ["link"]="follows"}, {["id"]=2, ["link"]="related"}}
movie_companies = {{["movie_id"]=1, ["company_id"]=1, ["company_type_id"]=1, ["note"]=nil}, {["movie_id"]=2, ["company_id"]=2, ["company_type_id"]=1, ["note"]="extra"}}
movie_info = {{["movie_id"]=1, ["info"]="Sweden"}, {["movie_id"]=2, ["info"]="USA"}}
movie_keyword = {{["movie_id"]=1, ["keyword_id"]=1}, {["movie_id"]=2, ["keyword_id"]=2}}
movie_link = {{["movie_id"]=1, ["link_type_id"]=1}, {["movie_id"]=2, ["link_type_id"]=2}}
title = {{["id"]=1, ["production_year"]=1980, ["title"]="Western Sequel"}, {["id"]=2, ["production_year"]=1999, ["title"]="Another Movie"}}
matches = (function()
    local _src = complete_cast
    return __query(_src, {
        { items = comp_cast_type, on = function(cc, cct1) return __eq(cct1.id, cc.subject_id) end },
        { items = comp_cast_type, on = function(cc, cct1, cct2) return __eq(cct2.id, cc.status_id) end },
        { items = title, on = function(cc, cct1, cct2, t) return __eq(t.id, cc.movie_id) end },
        { items = movie_link, on = function(cc, cct1, cct2, t, ml) return __eq(ml.movie_id, t.id) end },
        { items = link_type, on = function(cc, cct1, cct2, t, ml, lt) return __eq(lt.id, ml.link_type_id) end },
        { items = movie_keyword, on = function(cc, cct1, cct2, t, ml, lt, mk) return __eq(mk.movie_id, t.id) end },
        { items = keyword, on = function(cc, cct1, cct2, t, ml, lt, mk, k) return __eq(k.id, mk.keyword_id) end },
        { items = movie_companies, on = function(cc, cct1, cct2, t, ml, lt, mk, k, mc) return __eq(mc.movie_id, t.id) end },
        { items = company_type, on = function(cc, cct1, cct2, t, ml, lt, mk, k, mc, ct) return __eq(ct.id, mc.company_type_id) end },
        { items = company_name, on = function(cc, cct1, cct2, t, ml, lt, mk, k, mc, ct, cn) return __eq(cn.id, mc.company_id) end },
        { items = movie_info, on = function(cc, cct1, cct2, t, ml, lt, mk, k, mc, ct, cn, mi) return __eq(mi.movie_id, t.id) end }
    }, { selectFn = function(cc, cct1, cct2, t, ml, lt, mk, k, mc, ct, cn, mi) return {["company"]=cn.name, ["link"]=lt.link, ["title"]=t.title} end, where = function(cc, cct1, cct2, t, ml, lt, mk, k, mc, ct, cn, mi) return ((((((((((((((((((((((((__eq(cct1.kind, "cast") or __eq(cct1.kind, "crew"))) and __eq(cct2.kind, "complete")) and not __eq(cn.country_code, "[pl]")) and ((__contains(cn.name, "Film") or __contains(cn.name, "Warner")))) and __eq(ct.kind, "production companies")) and __eq(k.keyword, "sequel")) and __contains(lt.link, "follow")) and __eq(mc.note, nil)) and ((((__eq(mi.info, "Sweden") or __eq(mi.info, "Germany")) or __eq(mi.info, "Swedish")) or __eq(mi.info, "German")))) and (t.production_year >= 1950)) and (t.production_year <= 2000)) and __eq(ml.movie_id, mk.movie_id)) and __eq(ml.movie_id, mc.movie_id)) and __eq(mk.movie_id, mc.movie_id)) and __eq(ml.movie_id, mi.movie_id)) and __eq(mk.movie_id, mi.movie_id)) and __eq(mc.movie_id, mi.movie_id)) and (ml.movie_id == cc.movie_id)) and (mk.movie_id == cc.movie_id)) and (mc.movie_id == cc.movie_id)) and (mi.movie_id == cc.movie_id)))) end })
end)()
result = {["producing_company"]=__min((function()
    local _res = {}
    for _, x in ipairs(matches) do
        _res[#_res+1] = x.company
    end
    return _res
end)()), ["link_type"]=__min((function()
    local _res = {}
    for _, x in ipairs(matches) do
        _res[#_res+1] = x.link
    end
    return _res
end)()), ["complete_western_sequel"]=__min((function()
    local _res = {}
    for _, x in ipairs(matches) do
        _res[#_res+1] = x.title
    end
    return _res
end)())}
__json(result)
local __tests = {
    {name="Q27 selects minimal company, link and title", fn=test_Q27_selects_minimal_company__link_and_title},
}
