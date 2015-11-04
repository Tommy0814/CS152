#lang racket

;; The big-num data structure is essentially a list of 3 digit numbers.

;; Exporting methods
(provide big-add big-subtract big-multiply big-power-of pretty-print number->bignum string->bignum)

(define MAX_BLOCK 1000)

;; Addition of two big-nums
(define (big-add x y)
  (big-add1 x y 0)
  )

(define (big-add1 x y co)
  (cond
    ;; If both lists are empty, the return value is either 0 or the caryover value.
    [(and (= 0 (length x)) (= 0 (length y)))
      (if (= co 0) '() (list co))]
    [(= 0 (length x))  (big-add1 (list co) y 0)]
    [(= 0 (length y))  (big-add1 x (list co) 0)]
    [else
     (let* ([result (+ (car x) (car y) co)] [carry (- result 1000)])
       (if (> carry 0) (append (list carry) (big-add1 (cdr x) (cdr y) 1)) (append (list result) (big-add1 (cdr x) (cdr y) 0)))
       )]
    ))

;; Subtraction of two big-nums
(define (big-subtract x y)
  (let ([lst (big-subtract1 x y 0)])
    (reverse (strip-leading-zeroes (reverse lst)))
  ))

(define (strip-leading-zeroes x)
  (cond
    [(= 0 (length x)) '(0)]
    [(= 0 (car x)) (strip-leading-zeroes (cdr x))]
    [else x]
    ))

;; NOTE: there are no negative numbers with this implementation,
;; so 3 - 4 should throw an error.
(define (big-subtract1 x y borrow)
  (let ([newx (if (> (length x) 0) (- (car x) borrow) x)])
(cond
      [(and (= 0 (length x)) (= 0 (length y)))
      (if (= borrow 0) '() (error "cant handle negative numbers"))]
      [(= 0 (length x))  (error "cant handle negative numbers")]
      [(= 0 (length y))  (cons newx (cdr x))]
      [(> (car y) newx) (append (list (- (+ 1000 newx) (car y))) (big-subtract1 (cdr x) (cdr y) 1))]
      [else (append (list (- newx (car y))) (big-subtract1 (cdr x) (cdr y) 0))]
       )))

;; Returns true if two big-nums are equal
(define (big-eq x y)
  (cond [(and (= 0 (length x)) (= 0 (length y))) #t]
  [(= (car x) (car y)) (big-eq (cdr x) (cdr y))]
  [else #f]))


;; Decrements a big-num
(define (big-dec x)
  (big-subtract x '(1))
  )

;; Multiplies two big-nums
(define (big-multiply x y)
  (big-mul x y '(0)))

(define (big-mul x y result)
  (let ([yint (car y)])
  (cond [(= 0 (car y)) result]
        [else (big-mul x (list (- yint 1)) (big-add x result))]
  )))
  

;; Raise x to the power of y
(define (big-power-of x y)
  (big-power x y x))

(define (big-power x y result)
  (let ([yint (car y)])
  (cond [(= 1 (car y)) result]
        [else (big-power x (list (- yint 1)) (big-multiply x result))]
  )))
  
  ;; Solve this function in terms of big-multiply. 

;; Dispaly a big-num in an easy to read format
(define (pretty-print x)
  (let ([lst (reverse x)])
    (string-append
     (number->string (car lst))
     (pretty-print1 (cdr lst))
     )))

(define (pretty-print1 x)
  (cond
    [(= 0 (length x))  ""]
    [else
     (string-append (pretty-print-block (car x)) (pretty-print1 (cdr x)))]
    ))

(define (pretty-print-block x)
  (string-append
   ","
   (cond
     [(< x 10) "00"]
     [(< x 100) "0"]
     [else ""])
   (number->string x)))

;; Convert a number to a bignum
(define (number->bignum n)
  (cond
    [(< n MAX_BLOCK) (list n)]
    [else
     (let ([block (modulo n MAX_BLOCK)]
           [rest (floor (/ n MAX_BLOCK))])
       (cons block (number->bignum rest)))]))

;; Convert a string to a bignum
(define (string->bignum s)
  (let ([n (string->number s)])
    (number->bignum n)))
