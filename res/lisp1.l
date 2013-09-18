  (defmacro and (&rest args)
    (cond ((null args) t)
          ((cdr args)  `(if ,(car args) (and ,@(cdr args))))
          (t           (car args))))
