; Generated by Mochi compiler v0.10.27 on 2025-07-17T18:03:03Z
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

(define customers '())
(define orders '())
(define result '())
(set! customers (list (list (cons 'id 1) (cons 'name "Alice")) (list (cons 'id 2) (cons 'name "Bob")) (list (cons 'id 3) (cons 'name "Charlie"))))
(set! orders (list (list (cons 'id 100) (cons 'customerId 1) (cons 'total 250)) (list (cons 'id 101) (cons 'customerId 2) (cons 'total 125)) (list (cons 'id 102) (cons 'customerId 1) (cons 'total 300))))
(set! result (let ((_res '()))
  (for-each (lambda (o)
    (for-each (lambda (c)
      (set! _res (append _res (list (list (cons 'orderId (map-get o 'id)) (cons 'orderCustomerId (map-get o 'customerId)) (cons 'pairedCustomerName (map-get c 'name)) (cons 'orderTotal (map-get o 'total))))))
    ) (if (string? customers) (string->list customers) customers))
  ) (if (string? orders) (string->list orders) orders))
  _res))
(begin (display "--- Cross Join: All order-customer pairs ---") (newline))
(let loop ((entry_idx 0))
  (if (< entry_idx (length result))
    (begin
      (let ((entry (list-ref result entry_idx)))
        (begin (display "Order") (display " ") (display (map-get entry 'orderId)) (display " ") (display "(customerId:") (display " ") (display (map-get entry 'orderCustomerId)) (display " ") (display ", total: $") (display " ") (display (map-get entry 'orderTotal)) (display " ") (display ") paired with") (display " ") (display (map-get entry 'pairedCustomerName)) (newline))
      )
      (loop (+ entry_idx 1))
    )
  '()
  )
)
