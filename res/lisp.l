(progn

  (defmacro caar (x) `(car (car ,x)))
  (defmacro cdar (x) `(cdr (car ,x)))
  (defmacro cadr (x) `(car (cdr ,x)))
  (defmacro cddr (x) `(cdr (cdr ,x)))

  (defun consp (x) (typep x 'cons))

  (defun atom (x) (not (consp x)))

  (defun null (x) (= x nil))

  (defun not (x) (eq x nil))

  (defmacro and (&rest args)
    (cond ((null args) t)
          ((cdr args)  `(if ,(car args) (and ,@(cdr args))))
          (t           (car args))))

  (defun complement (fn)
    #'(lambda (&rest args) (not (apply fn args))))

  (setf *gensym-counter* 0)

  (defun gensym (&optional prefix)
    (progn
      (if (null prefix) (setf prefix "G"))
      (setf *gensym-last* *gensym-counter*)
      (setf *gensym-counter* (+ *gensym-counter* 1))
      (intern (concat prefix *gensym-last*))))

  (defmacro ++ (num)
    `(let ((g (gensym)))
       (setf g ,num)
       (setf ,num (+ g 1))
       g))

  (defun funcall (fn &rest args) (apply fn args))

  (defmacro cond (&rest args)
    (if (null args)
        nil
      (let ((clause (car args)))
        (if (cdr clause)
            `(if ,(car clause)
                 (progn ,@(cdr clause))
               (cond ,@(cdr args)))
          `(or ,(car clause)
               (cond ,@(cdr args)))))))

  (defun copy-list (lst)
    (labels ((cl (x)
                 (if (atom x)
                     x
                   (cons (car x)
                         (cl (cdr x))))))
      (cons (car lst)
            (cl (cdr lst))))))
