//go:build ignore

// Generated by Mochi compiler v0.10.28 on 2025-07-18T06:59:53Z

package main

import (
	"encoding/json"
	"fmt"
	"time"

	"golang.org/x/exp/constraints"
)

type v map[string]any

type Part struct {
	P_partkey   int    `json:"p_partkey"`
	P_brand     string `json:"p_brand"`
	P_container string `json:"p_container"`
}

type Lineitem struct {
	L_partkey       int     `json:"l_partkey"`
	L_quantity      int     `json:"l_quantity"`
	L_extendedprice float64 `json:"l_extendedprice"`
}

func expect(cond bool) {
	if !cond {
		panic("expect failed")
	}
}

func formatDuration(d time.Duration) string {
	switch {
	case d < time.Microsecond:
		return fmt.Sprintf("%dns", d.Nanoseconds())
	case d < time.Millisecond:
		return fmt.Sprintf("%.1fµs", float64(d.Microseconds()))
	case d < time.Second:
		return fmt.Sprintf("%.1fms", float64(d.Milliseconds()))
	default:
		return fmt.Sprintf("%.2fs", d.Seconds())
	}
}

func printTestStart(name string) {
	fmt.Printf("   test %-30s ...", name)
}

func printTestPass(d time.Duration) {
	fmt.Printf(" ok (%s)\n", formatDuration(d))
}

func printTestFail(err error, d time.Duration) {
	fmt.Printf(" fail %v (%s)\n", err, formatDuration(d))
}

func test_Q17_returns_average_yearly_revenue_for_small_quantity_orders() {
	expected := (100.0 / 7.0)
	_ = expected
	expect((result == expected))
}

var part []Part
var lineitem []Lineitem
var brand string
var container string
var filtered []float64
var result float64

func main() {
	part = []Part{Part{
		P_partkey:   1,
		P_brand:     "Brand#23",
		P_container: "MED BOX",
	}, Part{
		P_partkey:   2,
		P_brand:     "Brand#77",
		P_container: "LG JAR",
	}}
	lineitem = []Lineitem{
		Lineitem{
			L_partkey:       1,
			L_quantity:      1,
			L_extendedprice: 100.0,
		},
		Lineitem{
			L_partkey:       1,
			L_quantity:      10,
			L_extendedprice: 1000.0,
		},
		Lineitem{
			L_partkey:       1,
			L_quantity:      20,
			L_extendedprice: 2000.0,
		},
		Lineitem{
			L_partkey:       2,
			L_quantity:      5,
			L_extendedprice: 500.0,
		},
	}
	brand = "Brand#23"
	container = "MED BOX"
	filtered = func() []float64 {
		results := []float64{}
		for _, l := range lineitem {
			for _, p := range part {
				if !(p.P_partkey == l.L_partkey) {
					continue
				}
				if ((p.P_brand == brand) && (p.P_container == container)) && (float64(l.L_quantity) < (0.2 * _avgOrdered[int](func() []int {
					results := []int{}
					for _, x := range lineitem {
						if x.L_partkey == p.P_partkey {
							if x.L_partkey == p.P_partkey {
								results = append(results, x.L_quantity)
							}
						}
					}
					return results
				}()))) {
					if ((p.P_brand == brand) && (p.P_container == container)) && (float64(l.L_quantity) < (0.2 * _avgOrdered[int](func() []int {
						results := []int{}
						for _, x := range lineitem {
							if x.L_partkey == p.P_partkey {
								if x.L_partkey == p.P_partkey {
									results = append(results, x.L_quantity)
								}
							}
						}
						return results
					}()))) {
						results = append(results, l.L_extendedprice)
					}
				}
			}
		}
		return results
	}()
	result = (_sumOrdered[float64](any(filtered)) / 7.0)
	func() { b, _ := json.Marshal(any(result)); fmt.Println(string(b)) }()
	test_Q17_returns_average_yearly_revenue_for_small_quantity_orders()
}

func _avgOrdered[T constraints.Integer | constraints.Float](s []T) float64 {
	if len(s) == 0 {
		return 0
	}
	var sum float64
	for _, v := range s {
		sum += float64(v)
	}
	return sum / float64(len(s))
}

func _sumOrdered[T constraints.Integer | constraints.Float](s []T) float64 {
	var sum float64
	for _, v := range s {
		sum += float64(v)
	}
	return sum
}
