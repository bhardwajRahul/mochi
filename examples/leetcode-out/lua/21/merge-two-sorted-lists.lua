function __add(a, b)
    if type(a) == "table" and type(b) == "table" then
        local out = {}
        for i = 1, #a do
            out[#out + 1] = a[i]
        end
        for i = 1, #b do
            out[#out + 1] = b[i]
        end
        return out
    elseif type(a) == "string" or type(b) == "string" then
        return tostring(a) .. tostring(b)
    else
        return a + b
    end
end
function __eq(a, b)
    if type(a) ~= type(b) then
        return false
    end
    if type(a) == "number" then
        return math.abs(a - b) < 1e-9
    end
    if type(a) ~= "table" then
        return a == b
    end
    if (a[1] ~= nil or #a > 0) and (b[1] ~= nil or #b > 0) then
        if #a ~= #b then
            return false
        end
        for i = 1, #a do
            if not __eq(a[i], b[i]) then
                return false
            end
        end
        return true
    end
    for k, v in pairs(a) do
        if not __eq(v, b[k]) then
            return false
        end
    end
    for k, _ in pairs(b) do
        if a[k] == nil then
            return false
        end
    end
    return true
end
function __index(obj, i)
    if type(obj) == "string" then
        return __indexString(obj, i)
    elseif type(obj) == "table" then
        if obj[1] ~= nil or #obj > 0 then
            return obj[(i) + 1]
        else
            return obj[i]
        end
    else
        error("cannot index")
    end
end
function __indexString(s, i)
    local len = #s
    if i < 0 then
        i = len + i + 1
    else
        i = i + 1
    end
    if i < 1 or i > len then
        error("index out of range")
    end
    return string.sub(s, i, i)
end
function __run_tests(tests)
    local function format_duration(d)
        if d < 1e-6 then
            return string.format("%dns", math.floor(d * 1e9))
        end
        if d < 1e-3 then
            return string.format("%.1fµs", d * 1e6)
        end
        if d < 1 then
            return string.format("%.1fms", d * 1e3)
        end
        return string.format("%.2fs", d)
    end
    local failures = 0
    for _, t in ipairs(tests) do
        io.write("   test " .. t.name .. " ...")
        local start = os.clock()
        local ok, err = pcall(t.fn)
        local dur = os.clock() - start
        if ok then
            io.write(" ok (" .. format_duration(dur) .. ")\n")
        else
            io.write(" fail " .. tostring(err) .. " (" .. format_duration(dur) .. ")\n")
            failures = failures + 1
        end
    end
    if failures > 0 then
        io.write("\n[FAIL] " .. failures .. " test(s) failed.\n")
    end
end
function mergeTwoLists(l1, l2)
    local i = 0
    local j = 0
    local result = {}
    while ((i < #l1) and (j < #l2)) do
        if (__index(l1, i) <= __index(l2, j)) then
            result = __add(result, {__index(l1, i)})
            i = __add(i, 1)
        else
            result = __add(result, {__index(l2, j)})
            j = __add(j, 1)
        end
        ::__continue0::
    end
    while (i < #l1) do
        result = __add(result, {__index(l1, i)})
        i = __add(i, 1)
        ::__continue1::
    end
    while (j < #l2) do
        result = __add(result, {__index(l2, j)})
        j = __add(j, 1)
        ::__continue2::
    end
    return result
end

function test_example_1()
    if not (__eq(mergeTwoLists({1, 2, 4}, {1, 3, 4}), {1, 1, 2, 3, 4, 4})) then
        error("expect failed")
    end
end

function test_example_2()
    if not (__eq(mergeTwoLists({}, {}), {})) then
        error("expect failed")
    end
end

function test_example_3()
    if not (__eq(mergeTwoLists({}, {0}), {0})) then
        error("expect failed")
    end
end

function test_different_lengths()
    if not (__eq(mergeTwoLists({1, 5, 7}, {2, 3, 4, 6, 8}), {1, 2, 3, 4, 5, 6, 7, 8})) then
        error("expect failed")
    end
end

function test_one_list_empty()
    if not (__eq(mergeTwoLists({1, 2, 3}, {}), {1, 2, 3})) then
        error("expect failed")
    end
end

local __tests = {
    {name = "example 1", fn = test_example_1},
    {name = "example 2", fn = test_example_2},
    {name = "example 3", fn = test_example_3},
    {name = "different lengths", fn = test_different_lengths},
    {name = "one list empty", fn = test_one_list_empty}
}
__run_tests(__tests)
