-- Generated by Mochi compiler v0.10.25 on 2025-07-13T12:51:14Z
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
function __starts_with(str, prefix)
    if type(str) ~= 'string' or type(prefix) ~= 'string' then return false end
    return string.sub(str, 1, #prefix) == prefix
end
function test_Q24_finds_voiced_action_movie_with_actress_named_An()
    if not (__eq(result, {{["voiced_char_name"]="Hero Character", ["voicing_actress_name"]="Ann Actress", ["voiced_action_movie_jap_eng"]="Heroic Adventure"}})) then error('expect failed') end
end

aka_name = {{["person_id"]=1}}
char_name = {{["id"]=1, ["name"]="Hero Character"}}
cast_info = {{["movie_id"]=1, ["person_id"]=1, ["person_role_id"]=1, ["role_id"]=1, ["note"]="(voice)"}}
company_name = {{["id"]=1, ["country_code"]="[us]"}}
info_type = {{["id"]=1, ["info"]="release dates"}}
keyword = {{["id"]=1, ["keyword"]="hero"}}
movie_companies = {{["movie_id"]=1, ["company_id"]=1}}
movie_info = {{["movie_id"]=1, ["info_type_id"]=1, ["info"]="Japan: Feb 2015"}}
movie_keyword = {{["movie_id"]=1, ["keyword_id"]=1}}
name = {{["id"]=1, ["name"]="Ann Actress", ["gender"]="f"}}
role_type = {{["id"]=1, ["role"]="actress"}}
title = {{["id"]=1, ["title"]="Heroic Adventure", ["production_year"]=2015}}
matches = (function()
    local _res = {}
    for _, an in ipairs(aka_name) do
        for _, chn in ipairs(char_name) do
            for _, ci in ipairs(cast_info) do
                for _, cn in ipairs(company_name) do
                    for _, it in ipairs(info_type) do
                        for _, k in ipairs(keyword) do
                            for _, mc in ipairs(movie_companies) do
                                for _, mi in ipairs(movie_info) do
                                    for _, mk in ipairs(movie_keyword) do
                                        for _, n in ipairs(name) do
                                            for _, rt in ipairs(role_type) do
                                                for _, t in ipairs(title) do
                                                    if ((((((((((((((((((((((((((((__contains({"(voice)", "(voice: Japanese version)", "(voice) (uncredited)", "(voice: English version)"}, ci.note) and __eq(cn.country_code, "[us]")) and __eq(it.info, "release dates")) and __contains({"hero", "martial-arts", "hand-to-hand-combat"}, k.keyword)) and not __eq(mi.info, nil)) and (((__starts_with(mi.info, "Japan:") and __contains(mi.info, "201")) or (__starts_with(mi.info, "USA:") and __contains(mi.info, "201"))))) and __eq(n.gender, "f")) and __contains(n.name, "An")) and __eq(rt.role, "actress")) and (t.production_year > 2010)) and __eq(t.id, mi.movie_id)) and __eq(t.id, mc.movie_id)) and __eq(t.id, ci.movie_id)) and __eq(t.id, mk.movie_id)) and __eq(mc.movie_id, ci.movie_id)) and __eq(mc.movie_id, mi.movie_id)) and __eq(mc.movie_id, mk.movie_id)) and __eq(mi.movie_id, ci.movie_id)) and __eq(mi.movie_id, mk.movie_id)) and __eq(ci.movie_id, mk.movie_id)) and __eq(cn.id, mc.company_id)) and __eq(it.id, mi.info_type_id)) and __eq(n.id, ci.person_id)) and __eq(rt.id, ci.role_id)) and __eq(n.id, an.person_id)) and (ci.person_id == an.person_id)) and __eq(chn.id, ci.person_role_id)) and __eq(k.id, mk.keyword_id))) then
                                                        _res[#_res+1] = {["voiced_char_name"]=chn.name, ["voicing_actress_name"]=n.name, ["voiced_action_movie_jap_eng"]=t.title}
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return _res
end)()
result = {{["voiced_char_name"]=__min((function()
    local _res = {}
    for _, x in ipairs(matches) do
        _res[#_res+1] = x.voiced_char_name
    end
    return _res
end)()), ["voicing_actress_name"]=__min((function()
    local _res = {}
    for _, x in ipairs(matches) do
        _res[#_res+1] = x.voicing_actress_name
    end
    return _res
end)()), ["voiced_action_movie_jap_eng"]=__min((function()
    local _res = {}
    for _, x in ipairs(matches) do
        _res[#_res+1] = x.voiced_action_movie_jap_eng
    end
    return _res
end)())}}
__json(result)
local __tests = {
    {name="Q24 finds voiced action movie with actress named An", fn=test_Q24_finds_voiced_action_movie_with_actress_named_An},
}
