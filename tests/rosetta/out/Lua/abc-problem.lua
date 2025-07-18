-- Generated by Mochi compiler v0.10.26 on 2025-07-16T09:29:44Z
function __add(a, b)
    if type(a) == 'table' and type(b) == 'table' then
        local out = {}
        for i = 1, #a do out[#out+1] = a[i] end
        for i = 1, #b do out[#out+1] = b[i] end
        return out
    elseif type(a) == 'string' or type(b) == 'string' then
        return tostring(a) .. tostring(b)
    else
        return a + b
    end
end
function __append(lst, v)
    local out = {}
    if lst then for i = 1, #lst do out[#out+1] = lst[i] end end
    out[#out+1] = v
    return out
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
function __index(obj, i)
    if type(obj) == 'string' then
        return __indexString(obj, i)
    elseif type(obj) == 'table' then
        if obj[1] ~= nil or #obj > 0 then
            return obj[(i)+1]
        else
            return obj[i]
        end
    else
        error('cannot index')
    end
end
function __indexString(s, i)
    local len = #s
    if i < 0 then
        i = len + i + 1
    else
        i = i + 1
    end
    if i < 1 or i > len then error('index out of range') end
    return string.sub(s, i, i)
end
function __slice(obj, i, j)
    if i == nil then i = 0 end
    if type(obj) == 'string' then
        local len = #obj
        if j == nil then j = len end
        if i < 0 then i = len + i end
        if j < 0 then j = len + j end
        if i < 0 then i = 0 end
        if j > len then j = len end
        return string.sub(obj, i+1, j)
    elseif type(obj) == 'table' then
        local len = #obj
        if j == nil then j = len end
        if i < 0 then i = len + i end
        if j < 0 then j = len + j end
        if i < 0 then i = 0 end
        if j > len then j = len end
        local out = {}
        for k = i+1, j do
            out[#out+1] = obj[k]
        end
        return out
    else
        return {}
    end
end
function fields(s)
    local res = {}
    local cur = ""
    local i = 0
    while (i < #s) do
        local c = __slice(s, i, __add(i, 1))
        if __eq(c, " ") then
            if (#cur > 0) then
                res = __append(res, cur)
                cur = ""
            end
        else
            cur = __add(cur, c)
        end
        i = __add(i, 1)
    end
    if (#cur > 0) then
        res = __append(res, cur)
    end
    return res
end

function canSpell(word, blks)
    if (#word == 0) then
        return true
    end
    local c = string.lower(__slice(word, 0, 1))
    local i = 0
    while (i < #blks) do
        local b = __index(blks, i)
        if (__eq(c, string.lower(__slice(b, 0, 1))) or __eq(c, string.lower(__slice(b, 1, 2)))) then
            local rest = {}
            local j = 0
            while (j < #blks) do
                if not __eq(j, i) then
                    rest = __append(rest, __index(blks, j))
                end
                j = __add(j, 1)
            end
            if canSpell(__slice(word, 1, nil), rest) then
                return true
            end
        end
        i = __add(i, 1)
    end
    return false
end

function newSpeller(blocks)
    local bl = fields(blocks)
    return function(w)
        return canSpell(w, bl)
end
end

function main()
    local sp = newSpeller("BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM")
    for _, word in ipairs({"A", "BARK", "BOOK", "TREAT", "COMMON", "SQUAD", "CONFUSE"}) do
        print((__add(word, " ") .. tostring(sp(word))))
    end
end

main()
