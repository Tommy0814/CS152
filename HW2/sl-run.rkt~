#lang racket
(require "parser.rkt")

(command-line
 #:args (file)
 (let ([f (file->string file)])
   (parse-and-eval f)))