# Generated by Mochi compiler v0.10.27 on 2025-07-17T06:40:59Z
require 'ostruct'

def _json(v)
  require 'json'
  obj = v
  if v.is_a?(Array)
    obj = v.map { |it| it.respond_to?(:to_h) ? it.to_h : it }
  elsif v.respond_to?(:to_h)
    obj = v.to_h
  end
  puts(JSON.generate(obj))
end
def _sum(v)
  list = nil
  if defined?(MGroup) && v.is_a?(MGroup)
    list = v.Items
  elsif v.is_a?(Array)
    list = v
  elsif v.respond_to?(:to_a)
    list = v.to_a
  end
  return 0 if !list || list.empty?
  list.sum(0.0)
end

$part = [OpenStruct.new(p_partkey: 1, p_brand: "Brand#12", p_container: "SM BOX", p_size: 3), OpenStruct.new(p_partkey: 2, p_brand: "Brand#23", p_container: "MED BOX", p_size: 5), OpenStruct.new(p_partkey: 3, p_brand: "Brand#34", p_container: "LG BOX", p_size: 15)]
$lineitem = [OpenStruct.new(l_partkey: 1, l_quantity: 5, l_extendedprice: 1000.0, l_discount: 0.1, l_shipmode: "AIR", l_shipinstruct: "DELIVER IN PERSON"), OpenStruct.new(l_partkey: 2, l_quantity: 15, l_extendedprice: 2000.0, l_discount: 0.05, l_shipmode: "AIR REG", l_shipinstruct: "DELIVER IN PERSON"), OpenStruct.new(l_partkey: 3, l_quantity: 35, l_extendedprice: 1500.0, l_discount: 0.0, l_shipmode: "AIR", l_shipinstruct: "DELIVER IN PERSON")]
$revenues = (begin
	_res = []
	for l in $lineitem
		for p in $part
			if (p.p_partkey == l.l_partkey)
				if (((((((((((p.p_brand == "Brand#12")) && ((["SM CASE", "SM BOX", "SM PACK", "SM PKG"].include?(p.p_container)))) && (((l.l_quantity >= 1) && (l.l_quantity <= 11)))) && (((p.p_size >= 1) && (p.p_size <= 5))))) || ((((((p.p_brand == "Brand#23")) && ((["MED BAG", "MED BOX", "MED PKG", "MED PACK"].include?(p.p_container)))) && (((l.l_quantity >= 10) && (l.l_quantity <= 20)))) && (((p.p_size >= 1) && (p.p_size <= 10)))))) || ((((((p.p_brand == "Brand#34")) && ((["LG CASE", "LG BOX", "LG PACK", "LG PKG"].include?(p.p_container)))) && (((l.l_quantity >= 20) && (l.l_quantity <= 30)))) && (((p.p_size >= 1) && (p.p_size <= 15))))))) && (["AIR", "AIR REG"].include?(l.l_shipmode))) && (l.l_shipinstruct == "DELIVER IN PERSON"))
					_res << (l.l_extendedprice * ((1 - l.l_discount)))
				end
			end
		end
	end
	_res
end)
$result = _sum($revenues)
_json($result)
raise "expect failed" unless ($result == 2800.0)
