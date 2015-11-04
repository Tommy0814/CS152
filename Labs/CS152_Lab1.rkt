#lang racket

(define (max-num lst)
  (define length_lst (length lst))
  (cond [ (= 1 (length lst)) (car lst)]
        [else (max-num
               [cond ((> (car lst) (car (cdr lst))) (cons (car lst) (cdr (cdr lst))))
                    [else (cdr lst)]])]))

(max-num '(1 2 3))
;; The function counts from 1 to the specified number, returning a string with the result.
;; The rules are:
;;    If a number is divisible by 3 and by 5, instead say "fizzbuzz"
;;    Else if a number is divisible by 3, instead say "fizz"
;;    Else if a number is divisible by 5, instead say "buzz"
;;    Otherwise say the number
(define (fizzbuzz n)
  (print (fizzbuzz1 1 n)))

;; Helper function for fizzbuzz
(define (fizzbuzz1 i n)
 (define result (cond
    [ (and (divisby? i 3) (divisby? i 5)) "fizzbuzz"]
    [ (divisby? i 3) "fizz"]
    [ (divisby? i 5) "buzz"]
    [ else (number->string i)]))
  (cond
    [(= i n) result]
    [else (string-append result (string-append " " (fizzbuzz1 (+ 1 i) n)))]))
  

;; Helper function for fizzbuzz
(define (divisby? x y)
  (zero? (remainder x y)))

(max-num '(1 2 3 4 5))
(max-num '(-5 -3 -2 -13))
(fizzbuzz 21)