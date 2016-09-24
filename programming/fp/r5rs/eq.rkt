#! /usr/bin/env racket
#lang sicp

;; Equivalence predicates

; = for testing the equality of two exact numbers
(= 2 (* 1 2))

; for inexact numbers
(define pi (acos -1))
pi
(= 3.14159265358979 pi)

(define acc 1e-5)
acc
(define (good-enough? x y)
  (< (abs (- x y)) acc))
; test
(good-enough? 3.1415926535 pi)

; = is only for numbers
; (= 'foo 'foo)

; eq?
(eq? (cons 'a 'b) (cons 'a 'b))

; eqv? very similar to eq?

; equal?
(equal? 3 (/ 6 2))
(equal? 3 (/ 6 2.0))
