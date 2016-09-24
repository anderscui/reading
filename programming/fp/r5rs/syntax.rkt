#! /usr/bin/env racket

#lang sicp

;; 1. Syntax: parentheses and prefix notation
(+ 1 2 3)

;; 2. Expr
; two types of expr: primitive: var ref, lit expr, assignments, cond, proc, proc calls
; and derived: cond, let

; var ref
(define a 10)
a
; literal expr
(quote a)
'a
; assignment
(set! a 5)
a
; conditional
(if (< a 10)
    1
    a)
; procedure
(define f
  (lambda (x) (* x x)))
f
; call
(f 2)

; derived
(define n 10)
(if (< n 10)
  n
  (if (> n 20)
      (* n n)
      0))

(cond [(< n 10) n]
      [(> n 20) (* n n)]
      [else 0])

(let ([a 10]
      [b 20])
  (* a b))

;; 3. Define

;; 4. Lambda
(define fn (lambda () "hello"))
(fn)

((lambda (x) (* x 2)) 5)

(define (fib n)
  (cond [(= n 0) 0]
        [(= n 1) 1]
        [else (+ (fib (- n 1)) (fib (- n 2)))]))
(fib 5)

; arbitrary number of args
(define my-sum
  (lambda (x . y)
    (apply + x y)))

(my-sum 1)
(my-sum 1 2)
(my-sum 1 2 3 4 5)

(define my-list
  (lambda args args))
(my-list 1 2 3)

;; 5. Let
; define for global; let for local
(let ([x 2]
      [y 3])
  (+ x y))

; scopes
(define x 10)
(+ (let ([x 5])
    (* x (+ x 2)))
   x)

(define x1 10)
(let* ([x 5]
       [y (* x 2)])
  (+ x y))

; named let
(define fact
  (lambda (n)
    (let iter ([product 1]
               [counter 1])
      (if (> counter n)
        product
        (iter (* counter product) (+ counter 1))))))

(fact 5)

; Letrec




