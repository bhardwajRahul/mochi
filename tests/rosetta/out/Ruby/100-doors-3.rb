# Generated by Mochi compiler v0.10.30 on 2025-07-19T00:24:42Z
$result = ""
(1...101).each do |i|
	j = 1
	while ((j * j) < i)
		j = (j + 1)
	end
	if ((j * j) == i)
		$result = ($result + "O")
	else
		$result = ($result + "-")
	end
end
puts($result)
