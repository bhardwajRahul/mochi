(define xs '(1 2 3))
(define ys (filter (lambda (x) (= (modulo x 2) 1)) xs))
(display (if (member 1 ys) #t #f))
(newline)
(display (if (member 2 ys) #t #f))
(newline)
(define m '(("a" . 1)))
(display (if (assoc "a" m) #t #f))
(newline)
(display (if (assoc "b" m) #t #f))
(newline)
(define s "hello")
(display (if (string-contains? s "ell") #t #f))
(newline)
(display (if (string-contains? s "foo") #t #f))
(newline)
