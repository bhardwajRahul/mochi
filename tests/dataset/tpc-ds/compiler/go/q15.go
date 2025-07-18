//go:build ignore

// Generated by Mochi compiler v0.10.26 on 2025-07-16T01:04:42Z

package main

import (
	"encoding/json"
	"fmt"
	"mochi/runtime/data"
	"reflect"
	"slices"
	"sort"
	"time"

	"golang.org/x/exp/constraints"
)

type CatalogSale struct {
	Cs_bill_customer_sk int     `json:"cs_bill_customer_sk"`
	Cs_sales_price      float64 `json:"cs_sales_price"`
	Cs_sold_date_sk     int     `json:"cs_sold_date_sk"`
}

type Catalog_sale struct {
	Cs_bill_customer_sk int     `json:"cs_bill_customer_sk"`
	Cs_sales_price      float64 `json:"cs_sales_price"`
	Cs_sold_date_sk     int     `json:"cs_sold_date_sk"`
}

type Customer struct {
	C_customer_sk     int `json:"c_customer_sk"`
	C_current_addr_sk int `json:"c_current_addr_sk"`
}

type CustomerAddress struct {
	Ca_address_sk int    `json:"ca_address_sk"`
	Ca_zip        string `json:"ca_zip"`
	Ca_state      string `json:"ca_state"`
}

type Customer_addres struct {
	Ca_address_sk int    `json:"ca_address_sk"`
	Ca_zip        string `json:"ca_zip"`
	Ca_state      string `json:"ca_state"`
}

type DateDim struct {
	D_date_sk int `json:"d_date_sk"`
	D_qoy     int `json:"d_qoy"`
	D_year    int `json:"d_year"`
}

type Date_dim struct {
	D_date_sk int `json:"d_date_sk"`
	D_qoy     int `json:"d_qoy"`
	D_year    int `json:"d_year"`
}

type Filtered struct {
	Ca_zip    any     `json:"ca_zip"`
	Sum_sales float64 `json:"sum_sales"`
}

type GKey struct {
	Zip string `json:"zip"`
}

type v map[string]any

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

func test_TPCDS_Q15_zip() {
	expect(_equal(filtered, []v{v{
		Ca_zip:    "85669",
		Sum_sales: 600.0,
	}}))
}

var catalog_sales []Catalog_sale
var customer []Customer
var customer_address []Customer_addres
var date_dim []Date_dim
var filtered []Filtered

func main() {
	catalog_sales = []Catalog_sale{Catalog_sale{
		Cs_bill_customer_sk: 1,
		Cs_sales_price:      600.0,
		Cs_sold_date_sk:     1,
	}}
	customer = []Customer{Customer{
		C_customer_sk:     1,
		C_current_addr_sk: 1,
	}}
	customer_address = []Customer_addres{Customer_addres{
		Ca_address_sk: 1,
		Ca_zip:        "85669",
		Ca_state:      "CA",
	}}
	date_dim = []Date_dim{Date_dim{
		D_date_sk: 1,
		D_qoy:     1,
		D_year:    2000,
	}}
	filtered = func() []Filtered {
		groups := map[string]*data.Group{}
		order := []string{}
		for _, cs := range catalog_sales {
			for _, c := range customer {
				if !(cs.Cs_bill_customer_sk == c.C_customer_sk) {
					continue
				}
				for _, ca := range customer_address {
					if !(c.C_current_addr_sk == ca.Ca_address_sk) {
						continue
					}
					for _, d := range date_dim {
						if !(cs.Cs_sold_date_sk == d.D_date_sk) {
							continue
						}
						if (((slices.Contains([]string{
							"85669",
							"86197",
							"88274",
							"83405",
							"86475",
							"85392",
							"85460",
							"80348",
							"81792",
						}, _sliceString(ca.Ca_zip, 0, 5)) || slices.Contains([]string{"CA", "WA", "GA"}, ca.Ca_state)) || (cs.Cs_sales_price > float64(500))) && (d.D_qoy == 1)) && (d.D_year == 2000) {
							key := GKey{Zip: ca.Ca_zip}
							ks := fmt.Sprint(key)
							g, ok := groups[ks]
							if !ok {
								g = &data.Group{Key: key}
								groups[ks] = g
								order = append(order, ks)
							}
							g.Items = append(g.Items, cs)
						}
					}
				}
			}
		}
		items := []*data.Group{}
		for _, ks := range order {
			items = append(items, groups[ks])
		}
		type pair struct {
			item *data.Group
			key  any
		}
		pairs := make([]pair, len(items))
		for idx, it := range items {
			g := it
			pairs[idx] = pair{item: it, key: g.Key.(GKey).Zip}
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
		for idx, p := range pairs {
			items[idx] = p.item
		}
		results := []Filtered{}
		for _, g := range items {
			results = append(results, Filtered{
				Ca_zip: g.Key.(GKey).Zip,
				Sum_sales: _sumOrdered[float64](func() []float64 {
					results := []float64{}
					for _, xRaw := range g.Items {
						x := xRaw.(Catalog_sale)
						results = append(results, x.Cs_sales_price)
					}
					return results
				}()),
			})
		}
		return results
	}()
	func() { b, _ := json.Marshal(filtered); fmt.Println(string(b)) }()
	test_TPCDS_Q15_zip()
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

func _sliceString(s string, i, j int) string {
	start := i
	end := j
	n := len([]rune(s))
	if start < 0 {
		start += n
	}
	if end < 0 {
		end += n
	}
	if start < 0 {
		start = 0
	}
	if end > n {
		end = n
	}
	if end < start {
		end = start
	}
	return string([]rune(s)[start:end])
}

func _sumOrdered[T constraints.Integer | constraints.Float](s []T) float64 {
	var sum float64
	for _, v := range s {
		sum += float64(v)
	}
	return sum
}
