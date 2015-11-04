#lang racket
(define-syntax switch
  (syntax-rules ()
  [(switch num default) (cdr default)]
  [(switch num case1 default) (if (= num (car case1)) (cdr case1) (cdr default))]
  [(switch num case1 rest ... default)
     (if (= num (car case1)) (cdr case1) (switch num rest ...))]))
(define x 5)
(switch x
        '[3 (displayln "x is 3")]
        '[4 (displayln "x is 4")]
        '['default (displayln "none of the above")])
           ;list
           ;1st element: number
           ; 2nd element: action