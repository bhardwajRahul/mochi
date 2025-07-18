; Generated by Mochi compiler v0.10.28 on 2025-07-18T07:03:19Z
(ns main)

(defn _print [& args]
  (letfn [(pv [v]
            (cond
              (true? v) (print 1)
              (false? v) (print 0)
              (sequential? v) (doseq [[i x] (map-indexed vector v)]
                                (when (> i 0) (print " "))
                                (pv x))
              :else (print v)))]
    (doseq [[i a] (map-indexed vector args)]
      (when (> i 0) (print " "))
      (pv a))
    (println)))
(declare c)

(defn Counter [n]
  {:__name "Counter" :n n}
)


;; Function inc takes [c: Counter] and returns any
(defn inc [c]
  (try
    (def c (+ (:n c) 1)) ;; int
  (catch clojure.lang.ExceptionInfo e
    (if (= (.getMessage e) "return")
      (:value (ex-data e))
    (throw e)))
  )
)

(defn -main []
  (def c {:__name "Counter" :n 0}) ;; Counter
  (inc c)
  (_print (:n c))
)

(-main)
