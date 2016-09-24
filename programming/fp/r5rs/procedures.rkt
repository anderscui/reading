#! /usr/bin/env racket
#lang sicp

;; Procedures.
; arguments are passed by value.
(define (fact n)
  (if (= n 0)
    1
    (* n (fact (- n 1)))))

(fact 5)

; flat recursion
(define (append ls1 ls2)
  (if (null? ls1)
    ls2
    (cons (car ls1) (append (cdr ls1) ls2))))

(append (list 1 2 3) (list 4 5 6))
(cdr (list 1 2 3))
(list 1 2 3)

; deep rec
(define (count-leaves ls)
  (cond [(null? ls) 0]
        [(not (pair? ls)) 1]
        [else (+ (count-leaves (car ls)) (count-leaves (cdr ls)))]))

(pair? (list))
(pair? (list 1))
(pair? 1)

(count-leaves (list 1 2 3 4))
(count-leaves (list 1 2 (list 3 4)))

; tail rec

; the iteration construct do
(do ((str (string #\f #\o #\o #\b #\a #\r))
     (i 0 (+ i 1)))
    ((= i (string-length str)) str)
  (string-set! str i #\b))



