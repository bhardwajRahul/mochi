# Generated by Mochi compiler v0.10.26 on 2025-07-16T12:22:03Z
def pfacSum(i)
	sum = 0
	p = 1
	while (p <= (i / 2))
		if ((i % p) == 0)
			sum = (sum + p)
		end
		p = (p + 1)
	end
	return sum
end

def pad(n, width)
	s = (n).to_s
	while ((s).length < width)
		s = (" " + s)
	end
	return s
end

def main()
	sums = []
	i = 0
	while (i < 20000)
		sums = (sums + [0])
		i = (i + 1)
	end
	i = 1
	while (i < 20000)
		sums[i] = pfacSum(i)
		i = (i + 1)
	end
	puts("The amicable pairs below 20,000 are:")
	n = 2
	while (n < 19999)
		m = sums[n]
		if (((m > n) && (m < 20000)) && (n == sums[m]))
			puts(((("  " + pad(n, 5)) + " and ") + pad(m, 5)))
		end
		n = (n + 1)
	end
end

main()
