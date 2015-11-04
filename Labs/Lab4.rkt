#lang racket

;; Expressions in the language
(struct b-val (val))
(struct b-if (c thn els))
(struct b-succ (exp))
(struct b-pred (exp))
;; Main evaluate method
(define (evaluate prog)
  (match prog
    [(struct b-val (v)) v]
    [(struct b-if (c thn els))
     (if (evaluate c)
         (evaluate thn)
         (evaluate els))]
    [(struct b-succ (exp))
     (let ([v (evaluate exp)])
       (if (number? v)
           (+ v 1)
           (error "needed an int, got sth else")))]
    [(struct b-pred (exp))
     (let ([v (evaluate exp)])
       (if (number? v)
           (- v 1)
           (error "needed an int, got sth else")))]
    [_ (error "Unrecognized expression")]))

(evaluate (b-val #t))
(evaluate (b-val #f))
(evaluate (b-if (b-val #t)
                (b-if (b-val #f) (b-val #t) (b-val #f))
                (b-val #f)))


;; Consider the following sample programs for extending the interpreter
; succ 1  =>  returns 2
; succ (succ 7) => returns 9
; pred 5 => returns 6
; succ (if true then 42 else 0) => 43
(evaluate (b-succ 4))