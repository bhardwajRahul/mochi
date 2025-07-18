# Generated by Mochi compiler v0.10.25 on 2025-07-13T12:52:36Z
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

$company_name = [OpenStruct.new(id: 1, country_code: "[de]"), OpenStruct.new(id: 2, country_code: "[us]")]
$company_type = [OpenStruct.new(id: 1, kind: "production companies"), OpenStruct.new(id: 2, kind: "distributors")]
$info_type = [OpenStruct.new(id: 1, info: "rating"), OpenStruct.new(id: 2, info: "release dates")]
$kind_type = [OpenStruct.new(id: 1, kind: "movie"), OpenStruct.new(id: 2, kind: "video")]
$title = [OpenStruct.new(id: 10, kind_id: 1, title: "Alpha"), OpenStruct.new(id: 20, kind_id: 1, title: "Beta"), OpenStruct.new(id: 30, kind_id: 2, title: "Gamma")]
$movie_companies = [OpenStruct.new(movie_id: 10, company_id: 1, company_type_id: 1), OpenStruct.new(movie_id: 20, company_id: 1, company_type_id: 1), OpenStruct.new(movie_id: 30, company_id: 2, company_type_id: 1)]
$movie_info = [OpenStruct.new(movie_id: 10, info_type_id: 2, info: "1997-05-10"), OpenStruct.new(movie_id: 20, info_type_id: 2, info: "1998-03-20"), OpenStruct.new(movie_id: 30, info_type_id: 2, info: "1999-07-30")]
$movie_info_idx = [OpenStruct.new(movie_id: 10, info_type_id: 1, info: "6.0"), OpenStruct.new(movie_id: 20, info_type_id: 1, info: "7.5"), OpenStruct.new(movie_id: 30, info_type_id: 1, info: "5.5")]
$candidates = (begin
	_res = []
	for cn in $company_name
		for mc in $movie_companies
			if (mc.company_id == cn.id)
				for ct in $company_type
					if (ct.id == mc.company_type_id)
						for t in $title
							if (t.id == mc.movie_id)
								for kt in $kind_type
									if (kt.id == t.kind_id)
										for mi in $movie_info
											if (mi.movie_id == t.id)
												for it2 in $info_type
													if (it2.id == mi.info_type_id)
														for miidx in $movie_info_idx
															if (miidx.movie_id == t.id)
																for it in $info_type
																	if (it.id == miidx.info_type_id)
																		if (((((cn.country_code == "[de]") && (ct.kind == "production companies")) && (it.info == "rating")) && (it2.info == "release dates")) && (kt.kind == "movie"))
																			_res << OpenStruct.new(release_date: mi.info, rating: miidx.info, german_movie: t.title)
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
$result = OpenStruct.new(release_date: (((($candidates)).sort_by { |x| x.release_date }).map { |x| x.release_date })[0], rating: (((($candidates)).sort_by { |x| x.rating }).map { |x| x.rating })[0], german_movie: (((($candidates)).sort_by { |x| x.german_movie }).map { |x| x.german_movie })[0])
_json($result)
raise "expect failed" unless ($result == OpenStruct.new(release_date: "1997-05-10", rating: "6.0", german_movie: "Alpha"))
