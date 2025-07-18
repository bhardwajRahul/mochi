# Generated by Mochi compiler v0.10.27 on 2025-07-17T06:41:40Z
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

$item = [OpenStruct.new(id: 1), OpenStruct.new(id: 2), OpenStruct.new(id: 3)]
$inventory = [OpenStruct.new(item: 1, qty: 20), OpenStruct.new(item: 1, qty: 22), OpenStruct.new(item: 1, qty: 5), OpenStruct.new(item: 2, qty: 30), OpenStruct.new(item: 2, qty: 5), OpenStruct.new(item: 3, qty: 10)]
$store_sales = [OpenStruct.new(item: 1), OpenStruct.new(item: 2)]
$result = 0
$inventory.each do |inv|
	$store_sales.each do |s|
		if (inv.item == s.item)
			$result = ($result + inv.qty)
		end
	end
end
_json($result)
raise "expect failed" unless ($result == 82)
