#! /usr/bin/env racket

;; A program module is written as #lang <lang-name> <top-form>*
#lang racket

;; 1. Definitions
; binds <id> to the result of <expr>
(define pie 3)

pie

; binds the first <id> to a function (or procedure), here <id> = piece
; under the hood, a func def is really the same as a non-func def
(define (piece str)
  (substring str 0 pie))

(piece "key lime")

; only the value of the last expr is returned when a func is called
(define (bake flavor)
  (printf "pre-heating oven...\n")
  (string-append flavor " pie"))

(bake "apple")

;; 2. Indenting code

;; 3. Identifiers
(define (>? a b) (> a b))

(>? 3 2)

(define (a+b a b) (+ a b))

(a+b 3 2)

;; 4. Function calls
; form: (<id> <expr>*)

(string-append "Hello" " World")
(string-length "Hello")
(string? 1)

(sqrt -16)

(number? "test")

(equal? 1 "one")

;; 5. Conditionals
; if: (if <expr> <expr> <expr>)
(define (reply s)
  (if (equal? "hello" (substring s 0 5))
    "hi!"
    "huh?"))

(reply "hello racket")
(reply "what is lambda?")

; and
(define (reply2 s)
  (if (and (string? s)
           (>= (string-length s) 5)
           (equal? "hello" (substring s 0 5)))
      "hi!"
      "huh?"))

(reply2 "hello racket")
(reply2 17)

; or

; cond: a sequence of tests
; In racket, () and [] are interchangeable
(define (reply-more s)
  (cond
    [(equal? "hello" (substring s 0 5))
     "hi!"]
    [(equal? "goodbye" (substring s 0 7))
     "bye!"]
    [(equal? "?" (substring s (- (string-length s) 1)))
     "I don't know"]
    [else "huh?"]))

(newline)
(reply-more "hello racket")
(reply-more "goodbye cruel world")
(reply-more "what's your favorite book?")
(reply-more "something:)")

;; 6. Function calls, again
; use an expr (if) as a func
(define (double v)
  ((if (string? v) string-append +) v v))

(double "abc")
(double 5)

;; 7. Anonymous funcs
(define (twice f v)
  (f (f v)))

(twice sqrt 16)

(twice (lambda (s) (string-append s " -> "))
       "hello")

(define louder
  (lambda (s)
    (string-append s "!")))

louder

;; 8. Local binding with define, let and let*
(define (add-value n)
  (define val 1)
  (+ n 1))

(add-value 5)

; cannot ref back in let
(let ([x (random 4)]
      [o (random 4)])
  (cond
    [(> x o) "X wins"]
    [(> o x) "O wins"]
    [else "cat's game"]))

; back ref in let*
(let* ([x (random 4)]
       [o (random 4)]
       [diff (number->string (abs (- x o)))])
  (cond
   [(> x o) (string-append "X wins by " diff)]
   [(> o x) (string-append "O wins by " diff)]
   [else "cat's game"]))
