nums = [1, 2, 3]
letters = ["A", "B"]
pairs = [{"n": n, "l": l} for n in nums if n % 2 == 0 for l in letters]
print("--- Even pairs ---")
for p in pairs:
    print(p["n"], p["l"])
