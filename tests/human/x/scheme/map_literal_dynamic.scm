(define x 3)
(define y 4)
(define m (list (cons "a" x) (cons "b" y)))
(display (cdr (assoc "a" m)))
(display " ")
(display (cdr (assoc "b" m)))
(newline)
