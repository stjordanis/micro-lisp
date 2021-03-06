(let ((Y (lambda (fn)
            ((lambda (h) (h h))
               (lambda (g)
                 (fn (lambda (x . y)
                    (apply (g g) (cons x y)))))))))

   (let ((append (Y (lambda(f)
                       (lambda (l1 l2)
                         (cond ((null? l1) l2)
                               ((quote t) (cons (car l1) (f (cdr l1) l2)))))))))
      (append (quote (1 2 3)) (quote (4 5 6)))))
