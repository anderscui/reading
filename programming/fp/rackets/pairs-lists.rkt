#! /usr/bin/env racket

#lang racket

;; Pairs, Lists and Racket Syntax
; The cons func accepts any two values

; cons a pair
(cons 1 2)

; car and cdr
(car (list 1 2 3))
(cdr (list 1 2 3))

; pair? = cons?
(pair? empty)
(pair? (cons 1 2))
(pair? (list 1 2 3))

;; 1. Quoting Pairs and Symbols
; nested list
(list (list 1) (list 2 3) (list 4))

; quote
(quote ((1) (2 3) (4)))

; a symbol, the intrinsic value of a symbol is nothing more than its char
; contents, symbols and strings are almost the same thing.
(quote jane-doe)

;
map
(quote map)
(symbol? (quote map))
(symbol? map)
(procedure? map)
(string->symbol "map")
(symbol->string (quote map))




