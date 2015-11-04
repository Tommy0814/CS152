#lang racket

(define (strings-to-nums lst)
  (map string->number lst))
(define (reverse-list lst)
  (foldl cons '() lst))



