(ns main)

(defn _indexString [s i]
  (let [r (vec (seq s))
        i (if (neg? i) (+ i (count r)) i)]
    (if (or (< i 0) (>= i (count r)))
      (throw (ex-info "index out of range" {}))
      (str (nth r i)))))

(declare s)

(defn -main []
  (def s "mochi") ;; string
  (println (_indexString s 1))
)

(-main)
