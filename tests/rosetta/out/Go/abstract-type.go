//go:build ignore

package main

import (
	"encoding/json"
	"fmt"
)

type Beast interface{ isBeast() }
type Dog struct {
	Kind string `json:"kind"`
	Name string `json:"name"`
}

func (Dog) isBeast() {}

type Cat struct {
	Kind string `json:"kind"`
	Name string `json:"name"`
}

func (Cat) isBeast() {}

// line 8
func beastKind(b Beast) string {
	return _cast[string](func() any {
		_t := b
		if _tmp0, ok := _t.(Dog); ok {
			k := _tmp0.Kind
			return k
		}
		if _tmp1, ok := _t.(Cat); ok {
			k := _tmp1.Kind
			return k
		}
		return nil
	}())
}

// line 15
func beastName(b Beast) string {
	return _cast[string](func() any {
		_t := b
		if _tmp2, ok := _t.(Dog); ok {
			n := _tmp2.Name
			return n
		}
		if _tmp3, ok := _t.(Cat); ok {
			n := _tmp3.Name
			return n
		}
		return nil
	}())
}

// line 22
func beastCry(b Beast) string {
	return func() string {
		_t := b
		if _tmp4, ok := _t.(Dog); ok {
			return "Woof"
		}
		if _tmp5, ok := _t.(Cat); ok {
			return "Meow"
		}
		var _zero string
		return _zero
	}()
}

// line 29
func bprint(b Beast) {
	fmt.Println(beastName(b) + ", who's a " + beastKind(b) + ", cries: \"" + beastCry(b) + "\".")
}

// line 33
func main() {
	var d Beast = Dog{Kind: "labrador", Name: "Max"}
	var c Beast = Cat{Kind: "siamese", Name: "Sammy"}
	bprint(d)
	bprint(c)
}

func main() {
	main()
}

func _cast[T any](v any) T {
	if tv, ok := v.(T); ok {
		return tv
	}
	var out T
	switch any(out).(type) {
	case int:
		switch vv := v.(type) {
		case int:
			return any(vv).(T)
		case float64:
			return any(int(vv)).(T)
		case float32:
			return any(int(vv)).(T)
		}
	case float64:
		switch vv := v.(type) {
		case int:
			return any(float64(vv)).(T)
		case float64:
			return any(vv).(T)
		case float32:
			return any(float64(vv)).(T)
		}
	case float32:
		switch vv := v.(type) {
		case int:
			return any(float32(vv)).(T)
		case float64:
			return any(float32(vv)).(T)
		case float32:
			return any(vv).(T)
		}
	}
	if m, ok := v.(map[any]any); ok {
		v = _convertMapAny(m)
	}
	data, err := json.Marshal(v)
	if err != nil {
		panic(err)
	}
	if err := json.Unmarshal(data, &out); err != nil {
		panic(err)
	}
	return out
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
