#! /usr/bin/env racket

#lang sicp

(define (square x)
  (* x x))
(square 5)

(define minsquare
  (lambda (a b)
    (if (< a b)
      (square a)
      (square b))))

(minsquare 3 5)

; using logical exprs is better sometimes
(define sawtooth?
  (lambda (x1 x2 x3)
    (or (and (< x1 x2) (> x2 x3))
        (and (> x1 x2) (< x2 x3)))))

(sawtooth? 2 5 3)

; sum of smallest
(define (sum-of-smallest x y z)
  (cond [(or (and (<= x y) (<= y z))
             (and (<= y x) (<= x z)))
         (+ x y)]
        [(or (and (<= x z) (<= z y))
             (and (<= z x) (<= x y)))
         (+ x z)]
        [else (+ y z)]))

(sum-of-smallest 1 2 3)
(sum-of-smallest 3 3 3)
(sum-of-smallest 10 5 7)

; case
(case (+ 3 4)
  ((7) 'seven)
  ((2) 'two)
  (else 'nothing))

(case 'a
  ((a b c d) 'first)
  ((e f g h) 'second)
  (else 'rest))
