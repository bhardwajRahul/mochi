# Generated by Mochi compiler v0.10.28 on 2025-07-18T04:04:21Z
print(list(dict.fromkeys([1, 2] + [2, 3])))
print([it for it in [1, 2, 3] if it not in [2]])
print(list(dict.fromkeys([it for it in [1, 2, 3] if it in [2, 4]])))
print(len([1, 2] + [2, 3]))
