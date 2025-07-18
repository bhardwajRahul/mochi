; Generated by Mochi compiler v0.10.28 on 2025-07-18T07:01:01Z
(ns main)

(defn _sum [v]
  (let [lst (cond
              (and (map? v) (contains? v :Items)) (:Items v)
              (sequential? v) v
              :else (throw (ex-info "sum() expects list or group" {})))]
    (reduce + 0 lst))
  )

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

(declare lineitem result)

(defn test_Q6_calculates_revenue_from_qualified_lineitems []
  (assert (= result (+ (* 1000.0 0.06) (* 500.0 0.07))) "expect failed")
)

(defn -main []
  (def lineitem [{:l_extendedprice 1000.0 :l_discount 0.06 :l_shipdate "1994-02-15" :l_quantity 10} {:l_extendedprice 500.0 :l_discount 0.07 :l_shipdate "1994-03-10" :l_quantity 23} {:l_extendedprice 400.0 :l_discount 0.04 :l_shipdate "1994-04-10" :l_quantity 15} {:l_extendedprice 200.0 :l_discount 0.06 :l_shipdate "1995-01-01" :l_quantity 5}]) ;; list of
  (def result (_sum (vec (->> (for [l lineitem :when (and (and (and (and (>= (compare (:l_shipdate l) "1994-01-01") 0) (< (compare (:l_shipdate l) "1995-01-01") 0)) (>= (:l_discount l) 0.05)) (<= (:l_discount l) 0.07)) (< (:l_quantity l) 24))] (* (:l_extendedprice l) (:l_discount l))))))) ;; list of float
  (_json result)
  (test_Q6_calculates_revenue_from_qualified_lineitems)
)

(-main)
