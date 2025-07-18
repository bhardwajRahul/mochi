# Generated by Mochi compiler v0.10.25 on 2025-07-13T11:54:51Z
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
def _min(v)
  list = nil
  if v.respond_to?(:Items)
    list = v.Items
  elsif v.is_a?(Array)
    list = v
  elsif v.respond_to?(:to_a)
    list = v.to_a
  end
  return 0 if !list || list.empty?
  list.min
end

$company_name = [OpenStruct.new(id: 1, country_code: "[de]"), OpenStruct.new(id: 2, country_code: "[us]")]
$keyword = [OpenStruct.new(id: 1, keyword: "character-name-in-title"), OpenStruct.new(id: 2, keyword: "other")]
$movie_companies = [OpenStruct.new(movie_id: 100, company_id: 1), OpenStruct.new(movie_id: 200, company_id: 2)]
$movie_keyword = [OpenStruct.new(movie_id: 100, keyword_id: 1), OpenStruct.new(movie_id: 200, keyword_id: 2)]
$title = [OpenStruct.new(id: 100, title: "Der Film"), OpenStruct.new(id: 200, title: "Other Movie")]
$titles = (begin
	_res = []
	for cn in $company_name
		for mc in $movie_companies
			if (mc.company_id == cn.id)
				for t in $title
					if (mc.movie_id == t.id)
						for mk in $movie_keyword
							if (mk.movie_id == t.id)
								for k in $keyword
									if (mk.keyword_id == k.id)
										if (((cn.country_code == "[de]") && (k.keyword == "character-name-in-title")) && (mc.movie_id == mk.movie_id))
											_res << t.title
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	_res
end)
$result = _min($titles)
_json($result)
raise "expect failed" unless ($result == "Der Film")
