; Generated by Mochi compiler v0.10.27 on 2025-07-17T18:03:42Z
(import (chibi json))

(define (_json v)
  (cond
    ;; list of objects
    ((and (list? v) (pair? v) (pair? (car v)) (pair? (caar v)))
     (display "[")
     (let loop ((xs v) (first #t))
       (unless (null? xs)
         (unless first (display ","))
         (display (json->string (car xs)))
         (loop (cdr xs) #f)))
     (display "]"))
    ;; single object or other value
    (else
     (display (json->string v))))
  (newline))

(define m '())
(set! m (list (cons 'a 1) (cons 'b 2)))
(_json m)
