# Generated by Mochi compiler v0.10.26 on 2025-07-16T12:22:06Z
def sortRunes(s)
	arr = []
	i = 0
	while (i < (s).length)
		arr = (arr + [s[i...(i + 1)]])
		i = (i + 1)
	end
	n = (arr).length
	m = 0
	while (m < n)
		j = 0
		while (j < (n - 1))
			if (arr[j] > arr[(j + 1)])
				tmp = arr[j]
				arr[j] = arr[(j + 1)]
				arr[(j + 1)] = tmp
			end
			j = (j + 1)
		end
		m = (m + 1)
	end
	out = ""
	i = 0
	while (i < n)
		out = (out + arr[i])
		i = (i + 1)
	end
	return out
end

def deranged(a, b)
	if ((a).length != (b).length)
		return false
	end
	i = 0
	while (i < (a).length)
		if (a[i...(i + 1)] == b[i...(i + 1)])
			return false
		end
		i = (i + 1)
	end
	return true
end

def main()
	words = ["constitutionalism", "misconstitutional"]
	m = {}
	bestLen = 0
	w1 = ""
	w2 = ""
	words.each do |w|
		if ((w).length <= bestLen)
			next
		end
		k = sortRunes(w)
		if (!((m.to_h.key?(k))))
			m[k] = [w]
			next
		end
		m[k].each_key do |c|
			if deranged(w, c)
				bestLen = (w).length
				w1 = c
				w2 = w
				break
			end
		end
		m[k] = (m[k] + [w])
	end
	puts(((((w1 + " ") + w2) + " : Length ") + (bestLen).to_s))
end

main()
