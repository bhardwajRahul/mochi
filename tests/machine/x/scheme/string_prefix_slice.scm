(define (_slice obj i j)
  (let* ((n (if (string? obj) (string-length obj) (length obj)))
         (start i)
         (end j))
    (when (< start 0) (set! start (+ n start)))
    (when (< end 0) (set! end (+ n end)))
    (when (< start 0) (set! start 0))
    (when (> end n) (set! end n))
    (when (< end start) (set! end start))
        (if (string? obj)
        (substring obj start end)
        (let loop ((idx 0) (xs obj) (out '()))
          (if (or (null? xs) (>= idx end))
              (reverse out)
              (loop (+ idx 1) (cdr xs)
                    (if (>= idx start)
                        (cons (car xs) out)
                        out)))))))

(define prefix "fore")
(define s1 "forest")
(begin (display (equal? (_slice s1 0 (string-length prefix)) prefix)) (newline))
(define s2 "desert")
(begin (display (equal? (_slice s2 0 (string-length prefix)) prefix)) (newline))
