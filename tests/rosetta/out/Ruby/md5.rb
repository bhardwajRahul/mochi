# Generated by Mochi compiler v0.10.30 on 2025-07-18T16:02:14Z
testpkg = Object.new
def testpkg.Add(a,b); a + b; end
def testpkg.Pi; 3.14; end
def testpkg.Answer; 42; end
def testpkg.MD5Hex(s); require 'digest/md5'; Digest::MD5.hexdigest(s); end
def testpkg.FifteenPuzzleExample; 'Solution found in 52 moves: rrrulddluuuldrurdddrullulurrrddldluurddlulurruldrdrd'; end

[["d41d8cd98f00b204e9800998ecf8427e", ""], ["0cc175b9c0f1b6a831c399e269772661", "a"], ["900150983cd24fb0d6963f7d28e17f72", "abc"], ["f96b697d7cb7938d525a2f31aaf161d0", "message digest"], ["c3fcd3d76192e4007dfb496cca67e13b", "abcdefghijklmnopqrstuvwxyz"], ["d174ab98d277d9f5a5611c2c9f419d9f", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"], ["57edf4a22be3c955ac49da2e2107b67a", ("12345678901234567890" + "123456789012345678901234567890123456789012345678901234567890")], ["e38ca1d920c4b8b8d3946b2c72f01680", "The quick brown fox jumped over the lazy dog's back"]].each do |pair|
	sum = testpkg.MD5Hex(pair[1])
	if (sum != pair[0])
		puts("MD5 fail")
		puts(["  for string,", pair[1]].join(" "))
		puts(["  expected:  ", pair[0]].join(" "))
		puts(["  got:       ", sum].join(" "))
	end
end
