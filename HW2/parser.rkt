#lang racket
(require parser-tools/lex
         (prefix-in re- parser-tools/lex-sre)
         parser-tools/yacc
         "interp.rkt")

(provide parse-and-eval)

;; Lexer
(define-tokens a (NUM VAR))
(define-empty-tokens b (+ - * > >= < <= := ! EOF IF THEN ELSE TRUE FALSE WHILE DO END OPAREN CPAREN SEM))
(define-lex-abbrevs
  (num (re-+ (re-+ (char-range "0" "9"))))
  (ident (re-+ (char-range "A" "z"))))
(define sl-lexer
  (lexer
   ("+" (token-+))
   ("-" (token--))
   ("*" (token-*))
   (">" (token->))
   (">=" (token->=))
   ("<" (token-<))
   ("<=" (token-<=))
   (":=" (token-:=))
   ("!" (token-!))
   ("(" (token-OPAREN))
   (")" (token-CPAREN))
   (";" (token-SEM))
   ("true" (token-TRUE))
   ("false" (token-FALSE))
   ("if" (token-IF))
   ("then" (token-THEN))
   ("else" (token-ELSE))
   ("while" (token-WHILE))
   ("do" (token-DO))
   ("end" (token-END))
   (num (token-NUM (string->number lexeme)))
   (ident (token-VAR lexeme))
   (whitespace (sl-lexer input-port))
   ((eof) (token-EOF))))

;; Parser
(define sl-parser
  (parser
   (start exp)
   (end EOF)
   (error error)
   (tokens a b)
   (precs (left SEM) (right :=) (left < <= > >=) (left - +) (left *) (nonassoc !))
   ;(suppress) ; Getting rid of shift/reduce conflict errors that seem useless
   (grammar
    (exp ((NUM) (sp-val $1))
         ((TRUE) (sp-val #t))
         ((FALSE) (sp-val #f))
         ((OPAREN exp CPAREN) $2)
         ((! VAR) (sp-var $2))
         ((exp SEM exp) (sp-seq $1 $3))
         ((exp + exp) (sp-binop + $1 $3))
         ((exp - exp) (sp-binop - $1 $3))
         ((exp * exp) (sp-binop * $1 $3))
         ((exp > exp) (sp-binop > $1 $3))
         ((exp >= exp) (sp-binop >= $1 $3))
         ((exp < exp) (sp-binop < $1 $3))
         ((exp <= exp) (sp-binop <= $1 $3))
         ((VAR := exp) (sp-assign $1 $3))
         ((IF exp THEN exp ELSE exp END) (sp-if $2 $4 $6))
         ((WHILE exp DO exp END) (sp-while $2 $4))
         ))))

(define (lex-this lexer input) (lambda () (lexer input)))

(define (parse-and-eval s)
  (let ((input (open-input-string s)))
    (let ([result (evaluate
     (sl-parser (lex-this sl-lexer input))
     (hash))])
          (car result))))

;(parse-and-eval "3 + 2 * 4")
;(parse-and-eval "4 * 2 + 3")
;(parse-and-eval "4 * (2 + 3)")
;(parse-and-eval "5 - 3 - 1")
;(parse-and-eval "3 < 4 - 2")
;(parse-and-eval "false")
;(parse-and-eval "if true then 1 else 2 end")
;(parse-and-eval "if 0>=1 then 1 else 2 end")
;(parse-and-eval "5;6;7")
;(parse-and-eval "x := 4")
;(parse-and-eval "x := 4; !x + 1")
;(parse-and-eval "i:=5; x:=1; while !i > 0 do x := !x * 2; i := !i - 1 end; !x")