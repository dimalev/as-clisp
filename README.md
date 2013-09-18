Common Lisp for Actionscript 3.0
================================

Basing on Script API for java, this is interpreter of common lisp. Check it out: http://dimalev.github.io/as-clisp/

You can extend engine with your own API, which is COOL. And it is gonna be even better.

Current functionality
=====================

To have enough functionality there are some built-in functions, and library function, which are built on top of these
internal functions.

settable here means that function can be used as first argument to setf. Macros are expanded, and if there is a
settable function on top - it can be used in setf as well.

Built-in functions
------------------

Language (Defined in com.clisp.ScriptEngine) :
 * progn - evaluates it's cdr and returns last value.
 * defun - function definition
 * defmacro - macros definition
 * setf - set symbol value in closest scope if defined, or in global scope if not defined
 * let - define local variables
 * labels - define local functions
 * apply - call function with given parameters
 * quote - prevents symbol from evaluating
 * backquote - quote for functions
 * cons - build cons
 * symbol-name - returns string representation of given symbol
 * intern - returns symbol by given name
 * car - returns car of cons. settable
 * cdr - returns car of cons. settable
 * typep - checks type of given symbol
 * if - evaluates second argument if first is nil, or third otherwise

Logic (Defined in com.clisp.api.Logic) :
 * = - evaluates it's arguments and checks if they are the same
 * < - evaluates it's arguments as numbers and checks if they are in ascending order

Strings (Defined in com.clisp.api.Strings) :
 * substr - returns part of first argument starting from character number taken from
second argument, and count equal third argument
 * concat - concatenates all it's arguments in order
 * strlen - returns length of given string

Arithmetic (Defined in com.clisp.api.Arithmetic) :
 * + - adds all given numbers
 * - - subtract all the numbers after first from first one
 * / - divide in given order
 * * - multiply all given numbers

Later I plan to make base class which will take care of plaguing all it's member
functions as API automatically. This will be useful when creating own libraries.

Library Functions
-----------------

Some functions are implemented as code. These can be found in res/lisp.l

This code base will extend. Most of function definitions are taken from Common Lisp book
of 1996 by Graham.

Example
=======

    (progn
      (defun fibnum (a)
        (if (< a 3) 1
          (+ (fibnum (- a 1)) (fibnum (- a 2)))))
      (fibnum 10))

Defines Fibonacci number function and returns 10th.