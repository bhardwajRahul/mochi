nums = {1, 2}
letters = {"A", "B"}
bools = {true, false}
combos = (function()
    local _res = {}
    for _, n in ipairs(nums) do
        for _, l in ipairs(letters) do
            for _, b in ipairs(bools) do
                _res[#_res+1] = {["n"]=n, ["l"]=l, ["b"]=b}
            end
        end
    end
    return _res
end)()
print("--- Cross Join of three lists ---")
for _, c in ipairs(combos) do
    print(c.n, c.l, c.b)
end
