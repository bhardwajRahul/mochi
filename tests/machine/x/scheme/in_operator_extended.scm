(import (chibi string))

(define xs (list 1 2 3))
(define ys (let ((_res '()))
  (for-each (lambda (x)
    (when (equal? (modulo x 2) 1)
      (set! _res (append _res (list x)))
    )
  ) (if (string? xs) (string->list xs) xs))
  _res))
(begin (display (if (member 1 ys) #t #f)) (newline))
(begin (display (if (member 2 ys) #t #f)) (newline))
(define m (list (cons 'a 1)))
(begin (display (if (assoc "a" m) #t #f)) (newline))
(begin (display (if (assoc "b" m) #t #f)) (newline))
(define s "hello")
(begin (display (if (string-contains s "ell") #t #f)) (newline))
(begin (display (if (string-contains s "foo") #t #f)) (newline))
