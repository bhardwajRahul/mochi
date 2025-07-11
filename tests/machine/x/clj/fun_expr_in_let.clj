(ns main)

(declare square)

(defn -main []
  (def square (fn [x]
  (try
    (throw (ex-info "return" {:value (* x x)}))
  (catch clojure.lang.ExceptionInfo e
    (if (= (.getMessage e) "return")
      (:value (ex-data e))
    (throw e)))
  )
)) ;; function
  (println (square 6))
)

(-main)
