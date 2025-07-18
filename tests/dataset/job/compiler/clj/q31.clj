; Generated by Mochi compiler v0.10.25 on 2025-07-13T12:23:17Z
(ns main)

(defn _min [v]
  (let [lst (cond
              (and (map? v) (contains? v :Items)) (:Items v)
              (sequential? v) v
              :else (throw (ex-info "min() expects list or group" {})))]
    (if (empty? lst)
      0
      (reduce (fn [a b] (if (neg? (compare a b)) a b)) lst))))

(defn _equal [a b]
  (cond
    (and (sequential? a) (sequential? b))
      (and (= (count a) (count b)) (every? true? (map _equal a b)))
    (and (map? a) (map? b))
      (and (= (count a) (count b))
           (every? (fn [k] (_equal (get a k) (get b k))) (keys a)))
    (and (number? a) (number? b))
      (= (double a) (double b))
    :else
      (= a b)))

(defn _escape_json [s]
  (-> s
      (clojure.string/replace "\\" "\\\\")
      (clojure.string/replace "\"" "\\\"")))

(defn _to_json [v]
  (cond
    (nil? v) "null"
    (string? v) (str "\"" (_escape_json v) "\"")
    (number? v) (str v)
    (boolean? v) (str v)
    (sequential? v) (str "[" (clojure.string/join "," (map _to_json v)) "]")
    (map? v) (str "{" (clojure.string/join "," (map (fn [[k val]]
                                        (str "\"" (_escape_json (name k)) "\":" (_to_json val))) v)) "}")
    :else (str "\"" (_escape_json (str v)) "\"")))

(defn _json [v]
  (println (_to_json v)))

(declare cast_info company_name info_type keyword movie_companies movie_info movie_info_idx movie_keyword name title matches result)

(defn test_Q31_finds_minimal_budget__votes__writer_and_title []
  (assert (_equal result [{:movie_budget "Horror" :movie_votes 800 :writer "Arthur" :violent_liongate_movie "Alpha Horror"}]) "expect failed")
)

(defn -main []
  (def cast_info [{:movie_id 1 :person_id 1 :note "(writer)"} {:movie_id 2 :person_id 2 :note "(story)"} {:movie_id 3 :person_id 3 :note "(writer)"}]) ;; list of
  (def company_name [{:id 1 :name "Lionsgate Pictures"} {:id 2 :name "Other Studio"}]) ;; list of
  (def info_type [{:id 10 :info "genres"} {:id 20 :info "votes"}]) ;; list of
  (def keyword [{:id 100 :keyword "murder"} {:id 200 :keyword "comedy"}]) ;; list of
  (def movie_companies [{:movie_id 1 :company_id 1} {:movie_id 2 :company_id 1} {:movie_id 3 :company_id 2}]) ;; list of
  (def movie_info [{:movie_id 1 :info_type_id 10 :info "Horror"} {:movie_id 2 :info_type_id 10 :info "Thriller"} {:movie_id 3 :info_type_id 10 :info "Comedy"}]) ;; list of
  (def movie_info_idx [{:movie_id 1 :info_type_id 20 :info 1000} {:movie_id 2 :info_type_id 20 :info 800} {:movie_id 3 :info_type_id 20 :info 500}]) ;; list of
  (def movie_keyword [{:movie_id 1 :keyword_id 100} {:movie_id 2 :keyword_id 100} {:movie_id 3 :keyword_id 200}]) ;; list of
  (def name [{:id 1 :name "Arthur" :gender "m"} {:id 2 :name "Bob" :gender "m"} {:id 3 :name "Carla" :gender "f"}]) ;; list of
  (def title [{:id 1 :title "Alpha Horror"} {:id 2 :title "Beta Blood"} {:id 3 :title "Gamma Comedy"}]) ;; list of
  (def matches (vec (->> (for [ci cast_info n name :when (_equal (:id n) (:person_id ci)) t title :when (_equal (:id t) (:movie_id ci)) mi movie_info :when (_equal (:movie_id mi) (:id t)) mi_idx movie_info_idx :when (_equal (:movie_id mi_idx) (:id t)) mk movie_keyword :when (_equal (:movie_id mk) (:id t)) k keyword :when (_equal (:id k) (:keyword_id mk)) mc movie_companies :when (_equal (:movie_id mc) (:id t)) cn company_name :when (_equal (:id cn) (:company_id mc)) it1 info_type :when (_equal (:id it1) (:info_type_id mi)) it2 info_type :when (_equal (:id it2) (:info_type_id mi_idx)) :when (and (and (and (and (and (and (some #(= (:note ci) %) ["(writer)" "(head writer)" "(written by)" "(story)" "(story editor)"]) (clojure.string/starts-with? (:name cn) "Lionsgate")) (_equal (:info it1) "genres")) (_equal (:info it2) "votes")) (some #(= (:keyword k) %) ["murder" "violence" "blood" "gore" "death" "female-nudity" "hospital"])) (some #(= (:info mi) %) ["Horror" "Thriller"])) (_equal (:gender n) "m"))] {:movie_budget (:info mi) :movie_votes (:info mi_idx) :writer (:name n) :violent_liongate_movie (:title t)})))) ;; list of
  (def result [{:movie_budget (_min (vec (->> (for [r matches] (:movie_budget r))))) :movie_votes (apply min (vec (->> (for [r matches] (:movie_votes r))))) :writer (_min (vec (->> (for [r matches] (:writer r))))) :violent_liongate_movie (_min (vec (->> (for [r matches] (:violent_liongate_movie r)))))}]) ;; list of
  (_json result)
  (test_Q31_finds_minimal_budget__votes__writer_and_title)
)

(-main)
