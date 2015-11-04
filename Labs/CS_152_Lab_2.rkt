#lang racket

;; Reverse the order of items in a list.
(define (reverse lst)
  (cond [(= 1 (length lst)) lst]
    [else (append (reverse (cdr lst)) (list (car lst)))]))

;; Should return '(4 3 2 1)
(reverse '(1 2 3 4))



;; Join two lists together by adding their elements.
;; If one list is longer than the other, add the
;; additional elements to the end of the list.
(define (add-two-lists lst1 lst2)
  (cond [(and (= 0 (length lst1)) (= 0 (length lst2))) '()]
        [(= 0 (length lst1)) (cons (car lst2) (add-two-lists lst1 (cdr lst2)))]
        [(= 0 (length lst2)) (cons (car lst1) (add-two-lists (cdr lst1) lst2))]
        [else (cons (+ (car lst1) (car lst2)) (add-two-lists (cdr lst1) (cdr lst2)))]))


;;Helper function for add-two-lists
;; Should return '(10 2 5 5 5)
(add-two-lists '(1 2 3 4 5) '(9 0 2 1 0))

;; Should return '(8 6 1)
(add-two-lists '(5 4) '(3 2 1))

;; Should return '(15 17 18 16)
(add-two-lists '(13 14 15 16) '(2 3 3))



;; Return the list with only positive number included.
(define (positive-nums-only lst)
  (cond [(= 0 (length lst)) lst]
    [(> (car lst) 0) (cons (car lst) (positive-nums-only (cdr lst)))]
    [else (positive-nums-only (cdr lst))]))
      

(positive-nums-only '(1 2 -4 90 -4))
