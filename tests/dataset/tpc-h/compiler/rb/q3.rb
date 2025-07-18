# Generated by Mochi compiler v0.10.27 on 2025-07-17T06:40:56Z
require 'ostruct'

class MGroup
  include Enumerable
  attr_accessor :key, :Items
  def initialize(k)
    @key = k
    @Items = []
  end
  def length
    @Items.length
  end
  def items
    @Items
  end
  def each(&block)
    @Items.each(&block)
  end
end
def _group_by(src, keyfn)
grouped = src.group_by do |it|
  if it.is_a?(Array)
    keyfn.call(*it)
  else
    keyfn.call(it)
  end
end
grouped.map do |k, items|
g = MGroup.new(k)
items.each do |it|
  if it.is_a?(Array) && it.length == 1
    g.Items << it[0]
  else
    g.Items << it
  end
end
g
end
end
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
def _query(src, joins, opts)
  where_fn = opts['where']
  items = []
  if joins.empty?
    src.each do |v|
      row = [v]
      next if where_fn && !where_fn.call(*row)
      items << row
    end
  else
    items = src.map { |v| [v] }
    joins.each_with_index do |j, idx|
      joined = []
      jitems = j['items']
      on = j['on']
      left = j['left']
      right = j['right']
      last = idx == joins.length - 1
      if right && left
        matched = Array.new(jitems.length, false)
        items.each do |l|
          m = false
          jitems.each_with_index do |r, ri|
            keep = true
            keep = on.call(*l, r) if on
            next unless keep
            m = true
            matched[ri] = true
            row = l + [r]
            if last && where_fn && !where_fn.call(*row)
              next
            end
            joined << row
          end
          row = l + [nil]
          if left && !m
            if last && where_fn && !where_fn.call(*row)
              # skip
            else
              joined << row
            end
          end
        end
        jitems.each_with_index do |r, ri|
          next if matched[ri]
          _undef = Array.new(items[0]&.length || 0, nil)
          row = _undef + [r]
          if last && where_fn && !where_fn.call(*row)
            next
          end
          joined << row
        end
      elsif right
        jitems.each do |r|
          m = false
          items.each do |l|
            keep = true
            keep = on.call(*l, r) if on
            next unless keep
            m = true
            row = l + [r]
            if last && where_fn && !where_fn.call(*row)
              next
            end
            joined << row
          end
          unless m
            _undef = Array.new(items[0]&.length || 0, nil)
            row = _undef + [r]
            if last && where_fn && !where_fn.call(*row)
              next
            end
            joined << row
          end
        end
      else
        items.each do |l|
          m = false
          jitems.each do |r|
            keep = true
            keep = on.call(*l, r) if on
            next unless keep
            m = true
            row = l + [r]
            if last && where_fn && !where_fn.call(*row)
              next
            end
            joined << row
          end
          if left && !m
            row = l + [nil]
            if last && where_fn && !where_fn.call(*row)
              next
            end
            joined << row
          end
        end
      end
      items = joined
    end
  end
  if opts['sortKey']
    items = items.map { |it| [it, opts['sortKey'].call(*it)] }
    items.sort_by! { |p| p[1] }
    items.map!(&:first)
  end
  if opts.key?('skip')
    n = opts['skip']
    items = n < items.length ? items[n..-1] : []
  end
  if opts.key?('take')
    n = opts['take']
    items = n < items.length ? items[0...n] : items
  end
  res = []
  items.each { |r| res << opts['select'].call(*r) }
  res
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

$customer = [OpenStruct.new(c_custkey: 1, c_mktsegment: "BUILDING"), OpenStruct.new(c_custkey: 2, c_mktsegment: "AUTOMOBILE")]
$orders = [OpenStruct.new(o_orderkey: 100, o_custkey: 1, o_orderdate: "1995-03-14", o_shippriority: 1), OpenStruct.new(o_orderkey: 200, o_custkey: 2, o_orderdate: "1995-03-10", o_shippriority: 2)]
$lineitem = [OpenStruct.new(l_orderkey: 100, l_extendedprice: 1000.0, l_discount: 0.05, l_shipdate: "1995-03-16"), OpenStruct.new(l_orderkey: 100, l_extendedprice: 500.0, l_discount: 0.0, l_shipdate: "1995-03-20"), OpenStruct.new(l_orderkey: 200, l_extendedprice: 1000.0, l_discount: 0.1, l_shipdate: "1995-03-14")]
$cutoff = "1995-03-15"
$segment = "BUILDING"
$building_customers = ((($customer)).select { |c| (c.c_mktsegment == $segment) }).map { |c| c }
$valid_orders = (begin
	_res = []
	for o in $orders
		for c in $building_customers
			if (o.o_custkey == c.c_custkey)
				if (o.o_orderdate < $cutoff)
					_res << o
				end
			end
		end
	end
	_res
end)
$valid_lineitems = ((($lineitem)).select { |l| (l.l_shipdate > $cutoff) }).map { |l| l }
$order_line_join = (begin
	src = $valid_orders
	_rows = _query(src, [
		{ 'items' => $valid_lineitems, 'on' => ->(o, l){ (l.l_orderkey == o.o_orderkey) } }
	], { 'select' => ->(o, l){ [o, l] } })
	_groups = _group_by(_rows, ->(o, l){ OpenStruct.new(o_orderkey: o.o_orderkey, o_orderdate: o.o_orderdate, o_shippriority: o.o_shippriority) })
	_items0 = _groups
	_items0 = _items0.sort_by { |g| [(-_sum(((g)).map { |r| (r[1].l_extendedprice * ((1 - r[1].l_discount))) })), g.key.o_orderdate] }
	_res = []
	for g in _items0
		_res << OpenStruct.new(l_orderkey: g.key.o_orderkey, revenue: _sum(((g)).map { |r| (r[1].l_extendedprice * ((1 - r[1].l_discount))) }), o_orderdate: g.key.o_orderdate, o_shippriority: g.key.o_shippriority)
	end
	_res
end)
_json($order_line_join)
raise "expect failed" unless ($order_line_join == [OpenStruct.new(l_orderkey: 100, revenue: ((1000.0 * 0.95) + 500.0), o_orderdate: "1995-03-14", o_shippriority: 1)])
