(define (classify n)
  (call/cc (lambda (return)
    (return (let ((_t n)) (cond ((equal? _t 0) "zero") ((equal? _t 1) "one") (else "many"))))
  ))
)

(define x 2)
(define label (let ((_t x)) (cond ((equal? _t 1) "one") ((equal? _t 2) "two") ((equal? _t 3) "three") (else "unknown"))))
(begin (display label) (newline))
(define day "sun")
(define mood (let ((_t day)) (cond ((equal? _t "mon") "tired") ((equal? _t "fri") "excited") ((equal? _t "sun") "relaxed") (else "normal"))))
(begin (display mood) (newline))
(define ok #t)
(define status (let ((_t ok)) (cond ((equal? _t #t) "confirmed") ((equal? _t #f) "denied") (else '()))))
(begin (display status) (newline))
(begin (display (classify 0)) (newline))
(begin (display (classify 5)) (newline))
