(define customers
  (list (list (cons 'id 1) (cons 'name "Alice"))
        (list (cons 'id 2) (cons 'name "Bob"))
        (list (cons 'id 3) (cons 'name "Charlie"))
        (list (cons 'id 4) (cons 'name "Diana"))))

(define orders
  (list (list (cons 'id 100) (cons 'customerId 1) (cons 'total 250))
        (list (cons 'id 101) (cons 'customerId 2) (cons 'total 125))
        (list (cons 'id 102) (cons 'customerId 1) (cons 'total 300))))

(define result '())
(for-each (lambda (c)
            (let ((ords (filter (lambda (o) (= (cdr (assoc 'customerId o)) (cdr (assoc 'id c)))) orders)))
              (if (null? ords)
                  (set! result (cons (list (cons 'customerName (cdr (assoc 'name c))) (cons 'order #f)) result))
                  (for-each (lambda (o)
                              (set! result (cons (list (cons 'customerName (cdr (assoc 'name c))) (cons 'order o)) result)))
                            ords))))
          customers)

(display "--- Right Join using syntax ---")
(newline)
(for-each (lambda (entry)
            (let ((order (cdr (assoc 'order entry)))
                  (name (cdr (assoc 'customerName entry))))
              (if order
                  (begin (display "Customer ")
                         (display name)
                         (display " has order ")
                         (display (cdr (assoc 'id order)))
                         (display " - $")
                         (display (cdr (assoc 'total order)))
                         (newline))
                  (begin (display "Customer ")
                         (display name)
                         (display " has no orders")
                         (newline)))))
          result)
