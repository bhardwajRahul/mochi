" Generated by Mochi compiler v0.10.25 on 2025-07-13T14:24:44Z
"
| aka_name cast_info info_type link_type movie_link name person_info title rows result |
aka_name := {Dictionary from:{'person_id'->1. 'name'->'Anna Mae'}. Dictionary from:{'person_id'->2. 'name'->'Chris'}}.
cast_info := {Dictionary from:{'person_id'->1. 'movie_id'->10}. Dictionary from:{'person_id'->2. 'movie_id'->20}}.
info_type := {Dictionary from:{'id'->1. 'info'->'mini biography'}. Dictionary from:{'id'->2. 'info'->'trivia'}}.
link_type := {Dictionary from:{'id'->1. 'link'->'features'}. Dictionary from:{'id'->2. 'link'->'references'}}.
movie_link := {Dictionary from:{'linked_movie_id'->10. 'link_type_id'->1}. Dictionary from:{'linked_movie_id'->20. 'link_type_id'->2}}.
name := {Dictionary from:{'id'->1. name->'Alan Brown'. 'name_pcode_cf'->'B'. 'gender'->'m'}. Dictionary from:{'id'->2. name->'Zoe'. 'name_pcode_cf'->'Z'. 'gender'->'f'}}.
person_info := {Dictionary from:{'person_id'->1. 'info_type_id'->1. 'note'->'Volker Boehm'}. Dictionary from:{'person_id'->2. 'info_type_id'->1. 'note'->'Other'}}.
title := {Dictionary from:{'id'->10. title->'Feature Film'. 'production_year'->1990}. Dictionary from:{'id'->20. title->'Late Film'. 'production_year'->2000}}.
rows := [ | tmp |
  tmp := OrderedCollection new.
  aka_name do: [:an |
    name do: [:n |
      person_info do: [:pi |
        info_type do: [:it |
          cast_info do: [:ci |
            title do: [:t |
              movie_link do: [:ml |
                link_type do: [:lt |
                  (((((((((((((((((((((((((((((((((an at: 'name' at: 'contains') value: 'a') and: [(((it at: 'info') = ('mini biography')))])) and: [(((lt at: 'link') = 'features'))])) and: [(((n at: 'name_pcode_cf') >= 'A'))])) and: [(((n at: 'name_pcode_cf') <= 'F'))])) and: [(((((n at: 'gender') = 'm')) or: [(((((n at: 'gender') = 'f')) and: [((n at: 'name' at: 'starts_with') value: 'B')]))]))])) and: [(((pi at: 'note') = ('Volker Boehm')))])) and: [(((t at: 'production_year') >= 1980))])) and: [(((t at: 'production_year') <= 1995))])) and: [(((pi at: 'person_id') = (an at: 'person_id')))])) and: [(((pi at: 'person_id') = (ci at: 'person_id')))])) and: [(((an at: 'person_id') = (ci at: 'person_id')))])) and: [(((ci at: 'movie_id') = (ml at: 'linked_movie_id')))]) and: [(n.id = an.person_id)]) and: [(pi.person_id = an.person_id)]) and: [(it.id = pi.info_type_id)]) and: [(ci.person_id = n.id)]) and: [(t.id = ci.movie_id)]) and: [(ml.linked_movie_id = t.id)]) and: [(lt.id = ml.link_type_id)])) ifTrue: [
                    tmp add: Dictionary from:{'person_name'->n at: 'name'. 'movie_title'->t at: 'title'}.
                  ].
                ].
              ].
            ].
          ].
        ].
      ].
    ].
  ].
  tmp
] value.
result := {Dictionary from:{'of_person'->([ | tmp |
  tmp := OrderedCollection new.
  rows do: [:r |
    tmp add: r at: 'person_name'.
  ].
  tmp
] value min). 'biography_movie'->([ | tmp |
  tmp := OrderedCollection new.
  rows do: [:r |
    tmp add: r at: 'movie_title'.
  ].
  tmp
] value min)}}.
json value: result.
((result = ({Dictionary from:{'of_person'->'Alan Brown'. 'biography_movie'->'Feature Film'}}))) ifTrue: [Transcript show:'ok'; cr] ifFalse: [Transcript show:'fail'; cr].
