# Generated by Mochi transpiler v0.10.31 on 2025-07-19 21:22:04 GMT+7
matrix = [[1, 2], [3, 4]]
matrix = List.replace_at(matrix, 1, List.replace_at(Enum.at(matrix, 1), 0, 5))
IO.puts(Enum.at(Enum.at(matrix, 1), 0))
