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

$orders = [OpenStruct.new(o_orderkey: 1, o_orderdate: "1993-07-01", o_orderpriority: "1-URGENT"), OpenStruct.new(o_orderkey: 2, o_orderdate: "1993-07-15", o_orderpriority: "2-HIGH"), OpenStruct.new(o_orderkey: 3, o_orderdate: "1993-08-01", o_orderpriority: "3-NORMAL")]
$lineitem = [OpenStruct.new(l_orderkey: 1, l_commitdate: "1993-07-10", l_receiptdate: "1993-07-12"), OpenStruct.new(l_orderkey: 1, l_commitdate: "1993-07-12", l_receiptdate: "1993-07-10"), OpenStruct.new(l_orderkey: 2, l_commitdate: "1993-07-20", l_receiptdate: "1993-07-25"), OpenStruct.new(l_orderkey: 3, l_commitdate: "1993-08-02", l_receiptdate: "1993-08-01"), OpenStruct.new(l_orderkey: 3, l_commitdate: "1993-08-05", l_receiptdate: "1993-08-10")]
$start_date = "1993-07-01"
$end_date = "1993-08-01"
$date_filtered_orders = ((($orders)).select { |o| ((o.o_orderdate >= $start_date) && (o.o_orderdate < $end_date)) }).map { |o| o }
$late_orders = ((($date_filtered_orders)).select { |o| !(((($lineitem)).select { |l| ((l.l_orderkey == o.o_orderkey) && (l.l_commitdate < l.l_receiptdate)) }).map { |l| l }).empty? }).map { |o| o }
$result = (begin
	src = $late_orders
	_rows = _query(src, [
	], { 'select' => ->(o){ [o] } })
	_groups = _group_by(_rows, ->(o){ o.o_orderpriority })
	_items0 = _groups
	_items0 = _items0.sort_by { |g| g.key }
	_res = []
	for g in _items0
		_res << OpenStruct.new(o_orderpriority: g.key, order_count: (g).length)
	end
	_res
end)
_json($result)
raise "expect failed" unless ($result == [OpenStruct.new(o_orderpriority: "1-URGENT", order_count: 1), OpenStruct.new(o_orderpriority: "2-HIGH", order_count: 1)])
