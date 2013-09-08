Common Lisp for Actionscript 3.0
================================

Basing on Script API for java, this is interpreter of common lisp. Check it out: http://dimalev.github.io/as-clisp/

You can extend engine with your own API, which is COOL.

Current functionality
=====================

Pretty poor, but i will make it much better.

Logic: <, and, or, not (example: (not (< 1 2)))

Arithmetic: + - * / (example: (+ 1 2 3 5 6))

Structural: if, setq, set, progn, def

Example
=======

    (progn
      (def <= (a b)
        (or (< a b) (= a b)))
      (setq a 12)
      (setq b 10)
      (if (<= a b)
        a b))

Defines <= operator, sets 2 variables and returns minimal.