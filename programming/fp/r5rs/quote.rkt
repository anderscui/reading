#! /usr/bin/env racket
#lang sicp

;; Quote and quasiquote
; Quote is used when literal constants need to be included in the code.
(quote a)
'a

(quote (quote foo))
(quote 'foo)

'(a 1 2)

;; quasiquote
`(1 2)
'(1 2)
; comma - unquote
`(1 ,(+ 2 3) 4)
`(1 (unquote (+ 2 3)) 4)

; @
`(,@(cdr '(1 2 3)))
