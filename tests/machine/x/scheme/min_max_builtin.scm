; Generated by Mochi compiler v0.10.27 on 2025-07-17T18:04:11Z
(define nums '())
(set! nums (list 3 1 4))
(begin (display (let ((lst nums)) (if (null? lst) 0 (apply min lst)))) (newline))
(begin (display (let ((lst nums)) (if (null? lst) 0 (apply max lst)))) (newline))
