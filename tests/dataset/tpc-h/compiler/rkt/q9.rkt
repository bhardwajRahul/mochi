#lang racket
(require racket/list)
(require json)
(define nation (list (hash 'n_nationkey 1 'n_name "BRAZIL") (hash 'n_nationkey 2 'n_name "CANADA")))
(define supplier (list (hash 's_suppkey 100 's_nationkey 1) (hash 's_suppkey 200 's_nationkey 2)))
(define part (list (hash 'p_partkey 1000 'p_name "green metal box") (hash 'p_partkey 2000 'p_name "red plastic crate")))
(define partsupp (list (hash 'ps_partkey 1000 'ps_suppkey 100 'ps_supplycost 10) (hash 'ps_partkey 1000 'ps_suppkey 200 'ps_supplycost 8)))
(define orders (list (hash 'o_orderkey 1 'o_orderdate "1995-02-10") (hash 'o_orderkey 2 'o_orderdate "1997-01-01")))
(define lineitem (list (hash 'l_orderkey 1 'l_partkey 1000 'l_suppkey 100 'l_quantity 5 'l_extendedprice 1000 'l_discount 0.1) (hash 'l_orderkey 2 'l_partkey 1000 'l_suppkey 200 'l_quantity 10 'l_extendedprice 800 'l_discount 0.05)))
(define prefix "green")
(define start_date "1995-01-01")
(define end_date "1996-12-31")
(define result (let ([groups (make-hash)])
  (for* ([l lineitem] [p part] [s supplier] [ps partsupp] [o orders] [n nation] #:when (and (equal? (hash-ref p 'p_partkey) (hash-ref l 'l_partkey)) (equal? (hash-ref s 's_suppkey) (hash-ref l 'l_suppkey)) (and (equal? (hash-ref ps 'ps_partkey) (hash-ref l 'l_partkey)) (equal? (hash-ref ps 'ps_suppkey) (hash-ref l 'l_suppkey))) (equal? (hash-ref o 'o_orderkey) (hash-ref l 'l_orderkey)) (equal? (hash-ref n 'n_nationkey) (hash-ref s 's_nationkey)) (and (and (string=? (substring (hash-ref p 'p_name) 0 (string-length prefix)) prefix) (string>=? (hash-ref o 'o_orderdate) start_date)) (string<=? (hash-ref o 'o_orderdate) end_date)))) (let* ([key (hash 'nation (hash-ref n 'n_name) 'o_year (string->number (substring (hash-ref o 'o_orderdate) 0 4)))] [bucket (hash-ref groups key '())]) (hash-set! groups key (cons (hash 'l l 'p p 's s 'ps ps 'o o 'n n) bucket))))
  (define _groups (for/list ([k (hash-keys groups)]) (hash 'key k 'items (hash-ref groups k))))
  (set! _groups (sort _groups (lambda (a b) (cond [(string? (let ([g a]) (list (hash-ref (hash-ref g 'key) 'nation) (- (hash-ref (hash-ref g 'key) 'o_year))))) (string>? (let ([g a]) (list (hash-ref (hash-ref g 'key) 'nation) (- (hash-ref (hash-ref g 'key) 'o_year)))) (let ([g b]) (list (hash-ref (hash-ref g 'key) 'nation) (- (hash-ref (hash-ref g 'key) 'o_year)))))] [(string? (let ([g b]) (list (hash-ref (hash-ref g 'key) 'nation) (- (hash-ref (hash-ref g 'key) 'o_year))))) (string>? (let ([g a]) (list (hash-ref (hash-ref g 'key) 'nation) (- (hash-ref (hash-ref g 'key) 'o_year)))) (let ([g b]) (list (hash-ref (hash-ref g 'key) 'nation) (- (hash-ref (hash-ref g 'key) 'o_year)))))] [else (> (let ([g a]) (list (hash-ref (hash-ref g 'key) 'nation) (- (hash-ref (hash-ref g 'key) 'o_year)))) (let ([g b]) (list (hash-ref (hash-ref g 'key) 'nation) (- (hash-ref (hash-ref g 'key) 'o_year)))))]))))
  (for/list ([g _groups]) (hash 'nation (hash-ref (hash-ref g 'key) 'nation) 'o_year (number->string (hash-ref (hash-ref g 'key) 'o_year)) 'profit (apply + (for*/list ([v (for*/list ([x (hash-ref g 'items)]) (- (* (hash-ref (hash-ref x 'l) 'l_extendedprice) (- 1 (hash-ref (hash-ref x 'l) 'l_discount))) (* (hash-ref (hash-ref x 'ps) 'ps_supplycost) (hash-ref (hash-ref x 'l) 'l_quantity))))]) v))))))
(displayln (jsexpr->string result))
(define revenue (* 1000 0.9))
(define cost (* 5 10))
(when (equal? result (list (hash 'nation "BRAZIL" 'o_year "1995" 'profit (- revenue cost)))) (displayln "ok"))
