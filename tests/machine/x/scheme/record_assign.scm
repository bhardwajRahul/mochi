; Generated by Mochi compiler v0.10.27 on 2025-07-17T18:04:25Z
(define (map-get m k)
    (let ((p (assoc k m)))
        (if p (cdr p) '()))
)
(define (map-set m k v)
    (let ((p (assoc k m)))
        (if p
            (begin (set-cdr! p v) m)
            (cons (cons k v) m)))
)

(define (new-Counter n)
  (list (cons 'n n))
)

(define (inc c)
  (call/cc (lambda (return)
    (set! c (map-set c 'n (+ (map-get c 'n) 1)))
  ))
)

(define c '())
(set! c (list (cons 'n 0)))
(inc c)
(begin (display (map-get c 'n)) (newline))
