; Generated by Mochi compiler v0.10.28 on 2025-07-18T07:03:42Z
(ns main)

(defn _indexList [xs i]
  (let [idx (if (neg? i) (+ i (count xs)) i)]
    (if (or (< idx 0) (>= idx (count xs)))
      (throw (ex-info "index out of range" {}))
      (nth xs idx))))

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
(declare result)

;; Function twoSum takes [nums: list of int, target: int] and returns list of int
(defn twoSum [nums target]
  (try
    (def n (count nums)) ;; int
    (loop [i 0]
      (when (< i n)
        (let [r (try
          (loop [j (+ i 1)]
            (when (< j n)
              (let [r (try
                (when (= (+ (_indexList nums i) (_indexList nums j)) target)
                  (throw (ex-info "return" {:value [i j]}))
                )
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
              :else (recur (inc j))
            )
          )
        )
      )
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
    :else (recur (inc i))
  )
)
)
)
(throw (ex-info "return" {:value [(- 1) (- 1)]}))
(catch clojure.lang.ExceptionInfo e
(if (= (.getMessage e) "return")
(:value (ex-data e))
(throw e)))
)
)

(defn -main []
(def result (twoSum [2 7 11 15] 9)) ;; list of int
(_print (_indexList result 0))
(_print (_indexList result 1))
)

(-main)
