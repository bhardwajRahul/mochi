//go:build ignore

// Generated by Mochi compiler v0.10.26 on 2025-07-16T01:04:54Z

package main

import (
	"encoding/json"
	"fmt"
	"mochi/runtime/data"
	"reflect"
	"sort"
	"time"

	"golang.org/x/exp/constraints"
)

type After struct {
	W   any     `json:"w"`
	I   any     `json:"i"`
	Qty float64 `json:"qty"`
}

type Before struct {
	W   any     `json:"w"`
	I   any     `json:"i"`
	Qty float64 `json:"qty"`
}

type DateDim struct {
	D_date_sk int    `json:"d_date_sk"`
	D_date    string `json:"d_date"`
}

type Date_dim struct {
	D_date_sk int    `json:"d_date_sk"`
	D_date    string `json:"d_date"`
}

type GKey struct {
	W int `json:"w"`
	I int `json:"i"`
}

type Inventory struct {
	Inv_item_sk          int `json:"inv_item_sk"`
	Inv_warehouse_sk     int `json:"inv_warehouse_sk"`
	Inv_date_sk          int `json:"inv_date_sk"`
	Inv_quantity_on_hand int `json:"inv_quantity_on_hand"`
}

type Item struct {
	I_item_sk int    `json:"i_item_sk"`
	I_item_id string `json:"i_item_id"`
}

type Joined struct {
	W_name     string  `json:"w_name"`
	I_id       string  `json:"i_id"`
	Before_qty float64 `json:"before_qty"`
	After_qty  float64 `json:"after_qty"`
	Ratio      float64 `json:"ratio"`
}

type Result struct {
	W_warehouse_name string  `json:"w_warehouse_name"`
	I_item_id        string  `json:"i_item_id"`
	Inv_before       float64 `json:"inv_before"`
	Inv_after        float64 `json:"inv_after"`
}

type Warehouse struct {
	W_warehouse_sk   int    `json:"w_warehouse_sk"`
	W_warehouse_name string `json:"w_warehouse_name"`
}

type v = Result

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

func test_TPCDS_Q21_inventory_ratio() {
	expect(_equal(result, []v{v{
		W_warehouse_name: "Backup",
		I_item_id:        "ITEM2",
		Inv_before:       20,
		Inv_after:        20,
	}, v{
		W_warehouse_name: "Main",
		I_item_id:        "ITEM1",
		Inv_before:       30,
		Inv_after:        40,
	}}))
}

var inventory []Inventory
var warehouse []Warehouse
var item []Item
var date_dim []Date_dim
var before []Before
var after []After
var joined []Joined
var result []Result

func main() {
	inventory = []Inventory{
		Inventory{
			Inv_item_sk:          1,
			Inv_warehouse_sk:     1,
			Inv_date_sk:          1,
			Inv_quantity_on_hand: 30,
		},
		Inventory{
			Inv_item_sk:          1,
			Inv_warehouse_sk:     1,
			Inv_date_sk:          2,
			Inv_quantity_on_hand: 40,
		},
		Inventory{
			Inv_item_sk:          2,
			Inv_warehouse_sk:     2,
			Inv_date_sk:          1,
			Inv_quantity_on_hand: 20,
		},
		Inventory{
			Inv_item_sk:          2,
			Inv_warehouse_sk:     2,
			Inv_date_sk:          2,
			Inv_quantity_on_hand: 20,
		},
	}
	warehouse = []Warehouse{Warehouse{
		W_warehouse_sk:   1,
		W_warehouse_name: "Main",
	}, Warehouse{
		W_warehouse_sk:   2,
		W_warehouse_name: "Backup",
	}}
	item = []Item{Item{
		I_item_sk: 1,
		I_item_id: "ITEM1",
	}, Item{
		I_item_sk: 2,
		I_item_id: "ITEM2",
	}}
	date_dim = []Date_dim{Date_dim{
		D_date_sk: 1,
		D_date:    "2000-03-01",
	}, Date_dim{
		D_date_sk: 2,
		D_date:    "2000-03-20",
	}}
	before = func() []Before {
		groups := map[string]*data.Group{}
		order := []string{}
		for _, inv := range inventory {
			for _, d := range date_dim {
				if !(inv.Inv_date_sk == d.D_date_sk) {
					continue
				}
				if d.D_date < "2000-03-15" {
					key := GKey{
						W: inv.Inv_warehouse_sk,
						I: inv.Inv_item_sk,
					}
					ks := fmt.Sprint(key)
					g, ok := groups[ks]
					if !ok {
						g = &data.Group{Key: key}
						groups[ks] = g
						order = append(order, ks)
					}
					g.Items = append(g.Items, inv)
				}
			}
		}
		items := []*data.Group{}
		for _, ks := range order {
			items = append(items, groups[ks])
		}
		results := []Before{}
		for _, g := range items {
			results = append(results, Before{
				W: g.Key.(GKey).W,
				I: g.Key.(GKey).I,
				Qty: _sumOrdered[int](func() []int {
					results := []int{}
					for _, xRaw := range g.Items {
						x := xRaw.(Inventory)
						results = append(results, x.Inv_quantity_on_hand)
					}
					return results
				}()),
			})
		}
		return results
	}()
	after = func() []After {
		groups := map[string]*data.Group{}
		order := []string{}
		for _, inv := range inventory {
			for _, d := range date_dim {
				if !(inv.Inv_date_sk == d.D_date_sk) {
					continue
				}
				if d.D_date >= "2000-03-15" {
					key := GKey{
						W: inv.Inv_warehouse_sk,
						I: inv.Inv_item_sk,
					}
					ks := fmt.Sprint(key)
					g, ok := groups[ks]
					if !ok {
						g = &data.Group{Key: key}
						groups[ks] = g
						order = append(order, ks)
					}
					g.Items = append(g.Items, inv)
				}
			}
		}
		items := []*data.Group{}
		for _, ks := range order {
			items = append(items, groups[ks])
		}
		results := []After{}
		for _, g := range items {
			results = append(results, After{
				W: g.Key.(GKey).W,
				I: g.Key.(GKey).I,
				Qty: _sumOrdered[int](func() []int {
					results := []int{}
					for _, xRaw := range g.Items {
						x := xRaw.(Inventory)
						results = append(results, x.Inv_quantity_on_hand)
					}
					return results
				}()),
			})
		}
		return results
	}()
	joined = func() []Joined {
		results := []Joined{}
		for _, b := range before {
			for _, a := range after {
				if !(_equal(b.W, a.W) && _equal(b.I, a.I)) {
					continue
				}
				for _, w := range warehouse {
					if !(_equal(w.W_warehouse_sk, b.W)) {
						continue
					}
					for _, it := range item {
						if !(_equal(it.I_item_sk, b.I)) {
							continue
						}
						results = append(results, Joined{
							W_name:     w.W_warehouse_name,
							I_id:       it.I_item_id,
							Before_qty: b.Qty,
							After_qty:  a.Qty,
							Ratio:      (a.Qty / b.Qty),
						})
					}
				}
			}
		}
		return results
	}()
	result = func() []Result {
		src := _toAnySlice(joined)
		resAny := _query(src, []_joinSpec{}, _queryOpts{selectFn: func(_a ...any) any {
			tmp0 := _a[0]
			var r Joined
			if tmp0 != nil {
				r = tmp0.(Joined)
			}
			_ = r
			return Result{
				W_warehouse_name: r.W_name,
				I_item_id:        r.I_id,
				Inv_before:       r.Before_qty,
				Inv_after:        r.After_qty,
			}
		}, where: func(_a ...any) bool {
			tmp0 := _a[0]
			var r Joined
			if tmp0 != nil {
				r = tmp0.(Joined)
			}
			_ = r
			return ((r.Ratio >= (2.0 / 3.0)) && (r.Ratio <= (3.0 / 2.0)))
		}, sortKey: func(_a ...any) any {
			tmp0 := _a[0]
			var r Joined
			if tmp0 != nil {
				r = tmp0.(Joined)
			}
			_ = r
			return []string{r.W_name, r.I_id}
		}, skip: -1, take: -1})
		out := make([]Result, len(resAny))
		for i, v := range resAny {
			out[i] = v.(Result)
		}
		return out
	}()
	func() { b, _ := json.Marshal(result); fmt.Println(string(b)) }()
	test_TPCDS_Q21_inventory_ratio()
}

func _equal(a, b any) bool {
	av := reflect.ValueOf(a)
	bv := reflect.ValueOf(b)
	if av.Kind() == reflect.Slice && bv.Kind() == reflect.Slice {
		if av.Len() != bv.Len() {
			return false
		}
		for i := 0; i < av.Len(); i++ {
			if !_equal(av.Index(i).Interface(), bv.Index(i).Interface()) {
				return false
			}
		}
		return true
	}
	if av.Kind() == reflect.Map && bv.Kind() == reflect.Map {
		if av.Len() != bv.Len() {
			return false
		}
		for _, k := range av.MapKeys() {
			bvVal := bv.MapIndex(k)
			if !bvVal.IsValid() {
				return false
			}
			if !_equal(av.MapIndex(k).Interface(), bvVal.Interface()) {
				return false
			}
		}
		return true
	}
	if (av.Kind() == reflect.Int || av.Kind() == reflect.Int64 || av.Kind() == reflect.Float64) &&
		(bv.Kind() == reflect.Int || bv.Kind() == reflect.Int64 || bv.Kind() == reflect.Float64) {
		return av.Convert(reflect.TypeOf(float64(0))).Float() == bv.Convert(reflect.TypeOf(float64(0))).Float()
	}
	return reflect.DeepEqual(a, b)
}

type _joinSpec struct {
	items    []any
	on       func(...any) bool
	leftKey  func(...any) any
	rightKey func(any) any
	left     bool
	right    bool
}
type _queryOpts struct {
	selectFn func(...any) any
	where    func(...any) bool
	sortKey  func(...any) any
	skip     int
	take     int
}

func _query(src []any, joins []_joinSpec, opts _queryOpts) []any {
	items := make([][]any, len(src))
	for i, v := range src {
		items[i] = []any{v}
	}
	for _, j := range joins {
		if j.leftKey != nil && j.rightKey != nil {
			if j.right && !j.left {
				lmap := map[string][]int{}
				for li, l := range items {
					key := fmt.Sprint(j.leftKey(l...))
					lmap[key] = append(lmap[key], li)
				}
				joined := [][]any{}
				for _, right := range j.items {
					key := fmt.Sprint(j.rightKey(right))
					if is, ok := lmap[key]; ok {
						for _, li := range is {
							left := items[li]
							keep := true
							if j.on != nil {
								args := append(append([]any(nil), left...), right)
								keep = j.on(args...)
							}
							if !keep {
								continue
							}
							joined = append(joined, append(append([]any(nil), left...), right))
						}
					} else {
						undef := make([]any, len(items[0]))
						joined = append(joined, append(undef, right))
					}
				}
				items = joined
				continue
			}
			rmap := map[string][]int{}
			for ri, r := range j.items {
				key := fmt.Sprint(j.rightKey(r))
				rmap[key] = append(rmap[key], ri)
			}
			joined := [][]any{}
			matched := make([]bool, len(j.items))
			for _, left := range items {
				key := fmt.Sprint(j.leftKey(left...))
				if is, ok := rmap[key]; ok {
					m := false
					for _, ri := range is {
						right := j.items[ri]
						keep := true
						if j.on != nil {
							args := append(append([]any(nil), left...), right)
							keep = j.on(args...)
						}
						if !keep {
							continue
						}
						m = true
						matched[ri] = true
						joined = append(joined, append(append([]any(nil), left...), right))
					}
					if j.left && !m {
						joined = append(joined, append(append([]any(nil), left...), nil))
					}
				} else if j.left {
					joined = append(joined, append(append([]any(nil), left...), nil))
				}
			}
			if j.right {
				lw := 0
				if len(items) > 0 {
					lw = len(items[0])
				}
				for ri, right := range j.items {
					if !matched[ri] {
						undef := make([]any, lw)
						joined = append(joined, append(undef, right))
					}
				}
			}
			items = joined
			continue
		}
		joined := [][]any{}
		if j.right && j.left {
			matched := make([]bool, len(j.items))
			for _, left := range items {
				m := false
				for ri, right := range j.items {
					keep := true
					if j.on != nil {
						args := append(append([]any(nil), left...), right)
						keep = j.on(args...)
					}
					if !keep {
						continue
					}
					m = true
					matched[ri] = true
					joined = append(joined, append(append([]any(nil), left...), right))
				}
				if !m {
					joined = append(joined, append(append([]any(nil), left...), nil))
				}
			}
			for ri, right := range j.items {
				if !matched[ri] {
					undef := make([]any, len(items[0]))
					joined = append(joined, append(undef, right))
				}
			}
		} else if j.right {
			for _, right := range j.items {
				m := false
				for _, left := range items {
					keep := true
					if j.on != nil {
						args := append(append([]any(nil), left...), right)
						keep = j.on(args...)
					}
					if !keep {
						continue
					}
					m = true
					joined = append(joined, append(append([]any(nil), left...), right))
				}
				if !m {
					undef := make([]any, len(items[0]))
					joined = append(joined, append(undef, right))
				}
			}
		} else {
			for _, left := range items {
				m := false
				for _, right := range j.items {
					keep := true
					if j.on != nil {
						args := append(append([]any(nil), left...), right)
						keep = j.on(args...)
					}
					if !keep {
						continue
					}
					m = true
					joined = append(joined, append(append([]any(nil), left...), right))
				}
				if j.left && !m {
					joined = append(joined, append(append([]any(nil), left...), nil))
				}
			}
		}
		items = joined
	}
	if opts.where != nil {
		filtered := [][]any{}
		for _, r := range items {
			if opts.where(r...) {
				filtered = append(filtered, r)
			}
		}
		items = filtered
	}
	if opts.sortKey != nil {
		type pair struct {
			item []any
			key  any
		}
		pairs := make([]pair, len(items))
		for i, it := range items {
			pairs[i] = pair{it, opts.sortKey(it...)}
		}
		sort.Slice(pairs, func(i, j int) bool {
			a, b := pairs[i].key, pairs[j].key
			switch av := a.(type) {
			case int:
				switch bv := b.(type) {
				case int:
					return av < bv
				case float64:
					return float64(av) < bv
				}
			case float64:
				switch bv := b.(type) {
				case int:
					return av < float64(bv)
				case float64:
					return av < bv
				}
			case string:
				bs, _ := b.(string)
				return av < bs
			}
			return fmt.Sprint(a) < fmt.Sprint(b)
		})
		for i, p := range pairs {
			items[i] = p.item
		}
	}
	if opts.skip >= 0 {
		if opts.skip < len(items) {
			items = items[opts.skip:]
		} else {
			items = [][]any{}
		}
	}
	if opts.take >= 0 {
		if opts.take < len(items) {
			items = items[:opts.take]
		}
	}
	res := make([]any, len(items))
	for i, r := range items {
		res[i] = opts.selectFn(r...)
	}
	return res
}

func _sumOrdered[T constraints.Integer | constraints.Float](s []T) float64 {
	var sum float64
	for _, v := range s {
		sum += float64(v)
	}
	return sum
}

func _toAnySlice[T any](s []T) []any {
	out := make([]any, len(s))
	for i, v := range s {
		out[i] = v
	}
	return out
}
