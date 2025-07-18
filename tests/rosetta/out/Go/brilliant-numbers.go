//go:build ignore

// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z

package main

import (
	"fmt"
	"reflect"
	"strings"
)

type v map[string]any

// line 4
func primesUpTo(n int) []int {
	var sieve []bool = []bool{}
	i := 0
	for i <= n {
		sieve = append(_toAnySlice(sieve), any(true))
		i = (i + 1)
	}
	p := 2
	for (p * p) <= n {
		if sieve[p] {
			m := (p * p)
			for m <= n {
				sieve[m] = false
				m = (m + p)
			}
		}
		p = (p + 1)
	}
	var res []int = []int{}
	x := 2
	for x <= n {
		if sieve[x] {
			res = append(_toAnySlice(res), any(x))
		}
		x = (x + 1)
	}
	return res
}

// line 31
func sortInts(xs []int) []int {
	var res []int = []int{}
	tmp := xs
	for len(any(tmp)) > 0 {
		min := tmp[0]
		idx := 0
		i := 1
		for i < len(any(tmp)) {
			if tmp[i] < min {
				min = tmp[i]
				idx = i
			}
			i = (i + 1)
		}
		res = append(_toAnySlice(res), any(min))
		var out []int = []int{}
		j := 0
		for j < len(any(tmp)) {
			if j != idx {
				out = append(_toAnySlice(out), any(tmp[j]))
			}
			j = (j + 1)
		}
		tmp = out
	}
	return res
}

// line 57
func commatize(n int) string {
	s := fmt.Sprint(any(n))
	i := (len(any(s)) - 3)
	for i >= 1 {
		s = string([]rune(s)[0:i]) + "," + string([]rune(s)[i:len(any(s))])
		i = (i - 3)
	}
	return s
}

// line 69
func getBrilliant(digits int, limit int, countOnly bool) map[string]any {
	var brilliant []int = []int{}
	count := 0
	pow := 1
	next := 999999999999999
	k := 1
	for k <= digits {
		var s []int = []int{}
		for _, p := range primes {
			if p >= (pow * 10) {
				break
			}
			if p > pow {
				s = append(_toAnySlice(s), any(p))
			}
		}
		i := 0
		for i < len(any(s)) {
			j := i
			for j < len(any(s)) {
				prod := (s[i] * s[j])
				if prod < limit {
					if countOnly {
						count = (count + 1)
					} else {
						brilliant = append(_toAnySlice(brilliant), any(prod))
					}
				} else {
					if prod < next {
						next = prod
					}
					break
				}
				j = (j + 1)
			}
			i = (i + 1)
		}
		pow = (pow * 10)
		k = (k + 1)
	}
	if countOnly {
		return map[string]any(map[string]int{"bc": count, "next": next})
	}
	return map[string]any{"bc": brilliant, "next": next}
}

// line 107
func main() {
	fmt.Println(strings.TrimSuffix(fmt.Sprintln(any("First 100 brilliant numbers:")), "\n"))
	r := getBrilliant(2, 10000, false)
	br := sortInts((r["bc"]).([]int))
	br = br[0:100]
	i := 0
	for i < len(any(br)) {
		fmt.Println(strings.TrimSuffix(fmt.Sprintln(fmt.Sprint(fmt.Sprint(any(br[i]))(4, " "))+" ", func() int {
			if false {
				return 1
			}
			return 0
		}()), "\n"))
		if ((i + 1) % 10) == 0 {
			fmt.Println(strings.TrimSuffix(fmt.Sprintln(any(""), func() int {
				if true {
					return 1
				}
				return 0
			}()), "\n"))
		}
		i = (i + 1)
	}
	fmt.Println(strings.TrimSuffix(fmt.Sprintln(any(""), func() int {
		if true {
			return 1
		}
		return 0
	}()), "\n"))
	k := 1
	for k <= 13 {
		limit := pow(10, k)
		r2 := getBrilliant(k, (limit).(int), true)
		total := r2["bc"]
		next := r2["next"]
		climit := commatize((limit).(int))
		_ = climit
		ctotal := commatize(int(((total).(float64) + float64(1))))
		_ = ctotal
		cnext := commatize((next).(int))
		_ = cnext
		fmt.Println(strings.TrimSuffix(fmt.Sprintln("First >= "+fmt.Sprint(_getField(climit, "padStart")(18, " "))+" is "+fmt.Sprint(_getField(ctotal, "padStart")(14, " "))+" in the series: "+fmt.Sprint(_getField(cnext, "padStart")(18, " "))), "\n"))
		k = (k + 1)
	}
}

var primes []int

func main() {
	primes = primesUpTo(3200000)
}

func _convertMapAny(m map[any]any) map[string]any {
	out := make(map[string]any, len(m))
	for k, v := range m {
		key := fmt.Sprint(k)
		if sub, ok := v.(map[any]any); ok {
			out[key] = _convertMapAny(sub)
		} else {
			out[key] = v
		}
	}
	return out
}

func _getField(v any, name string) any {
	switch m := v.(type) {
	case map[string]any:
		return m[name]
	case map[string]string:
		if s, ok := m[name]; ok {
			return s
		}
	case map[any]any:
		return _convertMapAny(m)[name]
	default:
		rv := reflect.ValueOf(m)
		if rv.Kind() == reflect.Struct {
			rt := rv.Type()
			for i := 0; i < rv.NumField(); i++ {
				fn := rt.Field(i)
				field := fn.Name
				if tag := fn.Tag.Get("json"); tag != "" {
					if c := strings.Index(tag, ","); c >= 0 {
						tag = tag[:c]
					}
					if tag != "-" {
						field = tag
					}
				}
				if field == name {
					return rv.Field(i).Interface()
				}
			}
		}
	}
	return nil
}

func _toAnySlice[T any](s []T) []any {
	out := make([]any, len(s))
	for i, v := range s {
		out[i] = v
	}
	return out
}
