(define x 2)
(define label
  (cond ((= x 1) "one")
        ((= x 2) "two")
        ((= x 3) "three")
        (else "unknown")))
(display label)
(newline)

(define day "sun")
(define mood
  (cond ((string=? day "mon") "tired")
        ((string=? day "fri") "excited")
        ((string=? day "sun") "relaxed")
        (else "normal")))
(display mood)
(newline)

(define ok #t)
(display (if ok "confirmed" "denied"))
(newline)

(define (classify n)
  (cond ((= n 0) "zero")
        ((= n 1) "one")
        (else "many")))
(display (classify 0))
(newline)
(display (classify 5))
(newline)
