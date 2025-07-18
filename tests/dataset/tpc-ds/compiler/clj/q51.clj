; Generated by Mochi compiler v0.10.25 on 2025-07-15T04:46:26Z
(ns main)

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

(defn _sort_key [k]
  (cond
    (map? k) (pr-str (into (sorted-map) k))
    (sequential? k) (vec k)
    :else k))
(declare web_sales store_sales dms web_cum store_cum joined result)

;; Function cumulative takes [xs: list of any] and returns list of any
(defn cumulative [xs]
  (try
    (def out []) ;; list of any
    (def acc 0.0) ;; float
    (loop [_tmp0 (seq xs)]
      (when _tmp0
        (let [x (clojure.core/first _tmp0)]
          (let [r (try
            (def acc (+ acc (:price x))) ;; any
            (def out (conj out {:date (:date x) :cum acc})) ;; list of any
            :next
          (catch clojure.lang.ExceptionInfo e
            (cond
              (= (.getMessage e) "continue") :next
              (= (.getMessage e) "break") :break
              :else (throw e))
            )
          )]
        (cond
          (= r :break) nil
          :else (recur (next _tmp0))
        )
      )
    )
  )
)
(throw (ex-info "return" {:value out}))
(catch clojure.lang.ExceptionInfo e
(if (= (.getMessage e) "return")
  (:value (ex-data e))
(throw e)))
)
)

(defn test_TPCDS_Q51_simplified []
(assert (_equal result [{:item_sk 1 :d_date 1} {:item_sk 1 :d_date 2}]) "expect failed")
)

(defn -main []
(def web_sales [{:item 1 :date 1 :price 30.0} {:item 1 :date 2 :price 20.0}]) ;; list of
(def store_sales [{:item 1 :date 1 :price 5.0} {:item 1 :date 2 :price 19.0}]) ;; list of
(def dms 1) ;; int
(def web_cum (cumulative (vec (->> (for [w web_sales] {:date (:date w) :price (:price w)}) (sort-by (fn [w] (_sort_key (:date w)))))))) ;; list of
(def store_cum (cumulative (vec (->> (for [s store_sales] {:date (:date s) :price (:price s)}) (sort-by (fn [s] (_sort_key (:date s)))))))) ;; list of
(def joined (vec (->> (for [w web_cum s store_cum :when (_equal (:date w) (:date s)) :when (> (:cum w) (:cum s))] {:item_sk 1 :d_date (:date w)})))) ;; list of
(def result joined) ;; list of
(_json result)
(test_TPCDS_Q51_simplified)
)

(-main)
