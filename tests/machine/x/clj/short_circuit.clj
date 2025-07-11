(ns main)

;; Function boom takes [a: int, b: int] and returns bool
(defn boom [a b]
  (try
    (println "boom")
    (throw (ex-info "return" {:value true}))
  (catch clojure.lang.ExceptionInfo e
    (if (= (.getMessage e) "return")
      (:value (ex-data e))
    (throw e)))
  )
)

(defn -main []
  (println (and false (boom 1 2)))
  (println (or true (boom 1 2)))
)

(-main)
