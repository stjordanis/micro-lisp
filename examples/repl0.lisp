((lambda (eval environment)
   (write (eval eval (read) environment)))

 (lambda (eval^ exp env)
   (if (symbol? exp)
     ((lambda (e1 env1)
        ((lambda (asq)
           (asq asq e1 env1))
         (lambda (asq^ e1 env1)
           (if (null? env1)
             null
             (if (eq? e1 (car (car env1)))
               (car (cdr (car env1)))
               (asq^ asq^ e1 (cdr env1)))))))
      exp env)
     (if (symbol? (car exp))
       (if (eq? (car exp) (quote quote))
         (car (cdr exp))
         (if (eq? (car exp) (quote if))
           (if (eval^ eval^ (car (cdr exp)) env)
             (eval^ eval^ (car (cdr (cdr exp))) env)
             (eval^ eval^ (car (cdr (cdr (cdr exp)))) env))
           (if (eq? (car exp) (quote lambda))
               exp
             ((lambda (evlist)
                (if (eq? (car exp) (quote apply))
                    ((lambda (fn args)
                       (apply fn args))
                     (eval^ eval^ (car (cdr exp)) env)
                     (eval^ eval^ (car (cdr (cdr exp))) env))
                  ((lambda (fn)
                     (if (pair? fn)
                         (eval^ eval^ (cons fn (cdr exp)) env)
                       (apply fn (evlist evlist (cdr exp) env))))
                   (eval^ eval^ (car exp) env))))
              (lambda (evlist^ e1 evargs)
                (if (null? e1)
                    null
                  (cons (eval^ eval^ (car e1) env)
                        (evlist^ evlist^ (cdr e1) evargs))))))))
       (if (eq? (car (car exp)) (quote lambda))
         ((lambda (env1)
            (eval^ eval^ (car (cdr (cdr (car exp)))) env1))
          ((lambda (bind names values extenv)
             (bind bind names values extenv))
           (lambda (bind^ names values extenv)
             (if (null? names)
               extenv
               (cons (cons (car names) (cons (eval^ eval^ (car values) env) null))
                     (bind^ bind^ (cdr names) (cdr values) extenv))))
           (car (cdr (car exp)))
           (cdr exp)
           env))
         null))))
 (cons (cons (quote hello) (cons (quote carl) null))
 (cons (cons (quote car) (cons car null))
 (cons (cons (quote cdr) (cons cdr null))
 (cons (cons (quote cons) (cons cons null))
 (cons (cons (quote eq?) (cons eq? null))
 (cons (cons (quote pair?) (cons pair? null))
 (cons (cons (quote symbol?) (cons symbol? null))
 (cons (cons (quote null) (cons null null))
 (cons (cons (quote null?) (cons null? null))
 (cons (cons (quote read) (cons read null))
 (cons (cons (quote write) (cons write null)) null)))))))))))
 )