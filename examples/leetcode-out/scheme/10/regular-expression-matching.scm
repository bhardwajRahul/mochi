(define (list-set lst idx val)
    (let loop ((i idx) (l lst))
        (if (null? l)
            '()
            (if (= i 0)
                (cons val (cdr l))
                (cons (car l) (loop (- i 1) (cdr l))))))
)
(define (isMatch s p)
	(call/cc (lambda (return)
		(define dp '())
		(define first '())
		(define i '())
		(define i2 '())
		(define j '())
		(define j2 '())
		(define m '())
		(define n '())
		(define row '())
		(set! m (string-length s))
		(set! n (string-length p))
		(set! dp (list ))
		(set! i 0)
		(let loop ()
			(if (<= i m)
				(begin
					(set! row (list ))
					(set! j 0)
					(let loop ()
						(if (<= j n)
							(begin
								(set! row (append row (list #f)))
								(set! j (+ j 1))
								(loop)
							)
						'())
					)
					(set! dp (append dp (list row)))
					(set! i (+ i 1))
					(loop)
				)
			'())
		)
		(set! dp (list-set dp m (list-set (list-ref dp m) n #t)))
		(set! i2 m)
		(let loop ()
			(if (>= i2 0)
				(begin
					(set! j2 (- n 1))
					(let loop ()
						(if (>= j2 0)
							(begin
								(set! first #f)
								(if (< i2 m)
									(begin
										(if (or (= (string-ref p j2) (string-ref s i2)) (= (string-ref p j2) "."))
											(begin
												(set! first #t)
											)
											'()
										)
									)
									'()
								)
								(if (= (and (< (+ j2 1) n) (string-ref p (+ j2 1))) "*")
									(begin
										(if (or (list-ref (list-ref dp i2) (+ j2 2)) (and first (list-ref (list-ref dp (+ i2 1)) j2)))
											(begin
												(set! dp (list-set dp i2 (list-set (list-ref dp i2) j2 #t)))
											)
											(begin
												(set! dp (list-set dp i2 (list-set (list-ref dp i2) j2 #f)))
											)
										)
									)
									(begin
										(if (and first (list-ref (list-ref dp (+ i2 1)) (+ j2 1)))
											(begin
												(set! dp (list-set dp i2 (list-set (list-ref dp i2) j2 #t)))
											)
											(begin
												(set! dp (list-set dp i2 (list-set (list-ref dp i2) j2 #f)))
											)
										)
									)
								)
								(set! j2 (- j2 1))
								(loop)
							)
						'())
					)
					(set! i2 (- i2 1))
					(loop)
				)
			'())
		)
		(return (list-ref (list-ref dp 0) 0))
	))
)

