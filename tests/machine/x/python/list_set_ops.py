print(list(dict.fromkeys([1, 2] + [2, 3])))
print([it for it in [1, 2, 3] if it not in [2]])
print(list(dict.fromkeys([it for it in [1, 2, 3] if it in [2, 4]])))
print(len([1, 2] + [2, 3]))
