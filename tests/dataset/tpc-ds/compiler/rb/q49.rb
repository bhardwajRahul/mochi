# Generated by Mochi compiler v0.10.27 on 2025-07-17T06:41:29Z
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

$web = [OpenStruct.new(item: "A", return_ratio: 0.2, currency_ratio: 0.3, return_rank: 1, currency_rank: 1), OpenStruct.new(item: "B", return_ratio: 0.5, currency_ratio: 0.6, return_rank: 2, currency_rank: 2)]
$catalog = [OpenStruct.new(item: "A", return_ratio: 0.3, currency_ratio: 0.4, return_rank: 1, currency_rank: 1)]
$store = [OpenStruct.new(item: "A", return_ratio: 0.25, currency_ratio: 0.35, return_rank: 1, currency_rank: 1)]
$tmp = (((((($web)).select { |w| ((w.return_rank <= 10) || (w.currency_rank <= 10)) }).map { |w| OpenStruct.new(channel: "web", item: w.item, return_ratio: w.return_ratio, return_rank: w.return_rank, currency_rank: w.currency_rank) } + ((($catalog)).select { |c| ((c.return_rank <= 10) || (c.currency_rank <= 10)) }).map { |c| OpenStruct.new(channel: "catalog", item: c.item, return_ratio: c.return_ratio, return_rank: c.return_rank, currency_rank: c.currency_rank) }) + ((($store)).select { |s| ((s.return_rank <= 10) || (s.currency_rank <= 10)) }).map { |s| OpenStruct.new(channel: "store", item: s.item, return_ratio: s.return_ratio, return_rank: s.return_rank, currency_rank: s.currency_rank) }))
$result = ((($tmp)).sort_by { |r| [r.channel, r.return_rank, r.currency_rank, r.item] }).map { |r| r }
_json($result)
raise "expect failed" unless ($result == [OpenStruct.new(channel: "catalog", item: "A", return_ratio: 0.3, return_rank: 1, currency_rank: 1), OpenStruct.new(channel: "store", item: "A", return_ratio: 0.25, return_rank: 1, currency_rank: 1), OpenStruct.new(channel: "web", item: "A", return_ratio: 0.2, return_rank: 1, currency_rank: 1), OpenStruct.new(channel: "web", item: "B", return_ratio: 0.5, return_rank: 2, currency_rank: 2)])
