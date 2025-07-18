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

$keyword = [OpenStruct.new(id: 1, keyword: "amazing sequel"), OpenStruct.new(id: 2, keyword: "prequel")]
$movie_info = [OpenStruct.new(movie_id: 10, info: "Germany"), OpenStruct.new(movie_id: 30, info: "Sweden"), OpenStruct.new(movie_id: 20, info: "France")]
$movie_keyword = [OpenStruct.new(movie_id: 10, keyword_id: 1), OpenStruct.new(movie_id: 30, keyword_id: 1), OpenStruct.new(movie_id: 20, keyword_id: 1), OpenStruct.new(movie_id: 10, keyword_id: 2)]
$title = [OpenStruct.new(id: 10, title: "Alpha", production_year: 2006), OpenStruct.new(id: 30, title: "Beta", production_year: 2008), OpenStruct.new(id: 20, title: "Gamma", production_year: 2009)]
$allowed_infos = ["Sweden", "Norway", "Germany", "Denmark", "Swedish", "Denish", "Norwegian", "German"]
$candidate_titles = (begin
	_res = []
	for k in $keyword
		for mk in $movie_keyword
			if (mk.keyword_id == k.id)
				for mi in $movie_info
					if (mi.movie_id == mk.movie_id)
						for t in $title
							if (t.id == mi.movie_id)
								if ((((k.keyword.include?("sequel")) && ($allowed_infos.include?(mi.info))) && (t.production_year > 2005)) && (mk.movie_id == mi.movie_id))
									_res << t.title
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
$result = [OpenStruct.new(movie_title: _min($candidate_titles))]
_json($result)
raise "expect failed" unless ($result == [OpenStruct.new(movie_title: "Alpha")])
