(let nil
  (defmacro eq (&rest args) `(= ,@args))

  (defmacro caar (x) `(car (car ,x)))
  (defmacro cdar (x) `(cdr (car ,x)))
  (defmacro cadr (x) `(car (cdr ,x)))
  (defmacro cddr (x) `(cdr (cdr ,x)))

  (defun abs (x) (if (< x 0) (- x)))
  (defun <= (first &rest args)
    (or (null args)
        (and (or (< first (car args)) (= first (car args)))
             (apply #'<= args))))
  (defun >= (first &rest rest)
    (or (null rest)
        (and (or (> first (car rest)) (= first (car rest)))
             (apply #'>= rest))))
  (defun > (first &rest rest)
    (or (null rest)
        (and (let ((second (car rest))) (not (<= first second)))
             (apply #'> rest))))

  (defun list (&rest result) result)

  (defun reduce (initial f args)
    (if (null args)
        initial
      (reduce (apply #'f initial (list (car args))) #'f (cdr args))))

  (defun max (&rest all)
    (labels ((-max (left right) (if (> left right) left right)))
      (reduce (car all) #'-max (cdr all))))

  (defun min (&rest all)
    (labels ((-max (left right) (if (< left right) left right)))
      (reduce (car all) #'-max (cdr all))))

  (defun consp (x) (typep x 'cons))
  (defun atom (x) (not (consp x)))
  (defun stringp (x) (typep x 'string))
  (defun numberp (x) (typep x 'number))
  (defmacro integerp (x) `(numberp ,x))

  (defun null (x) (eq x nil))
  (defun not (x) (eq x nil))

  (defmacro or (&optional first &rest rest)
    (if (null rest)
        first
      (let ((g (gensym)))
        `(let ((,g ,first))
           (if ,g
               ,g
             (or ,@rest))))))

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
