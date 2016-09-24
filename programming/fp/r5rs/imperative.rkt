#! /usr/bin/env racket
#lang sicp

(define a 10)
a

(set! a 5)
a

; update global var
a

(define (square x) (* x x))

(define (sq! x) (set! a (square x)))
(sq! 10)
a

