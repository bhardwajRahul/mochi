(define data '(((tag . "a") (val . 1))
              ((tag . "a") (val . 2))
              ((tag . "b") (val . 3))))

(define groups (let ((table (make-hash-table 'equal)))
                 (for-each (lambda (item)
                             (let* ((tag (cdr (assoc 'tag item)))
                                    (lst (hash-table-ref/default table tag '())))
                               (hash-table-set! table tag (cons item lst))))
                           data)
                 (hash-table->alist table)))

(define tmp '())
(for-each (lambda (g)
            (let* ((tag (car g))
                   (items (cdr g))
                   (total (apply + (map (lambda (x) (cdr (assoc 'val x))) items))))
              (set! tmp (append tmp (list (list (cons 'tag tag) (cons 'total total)))))))
          groups)

(define result (sort tmp (lambda (a b) (string<? (cdr (assoc 'tag a)) (cdr (assoc 'tag b))))))
(display result)
(newline)
