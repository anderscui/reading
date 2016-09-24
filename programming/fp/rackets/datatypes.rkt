#! /usr/bin/env racket

#lang racket

;; 1. Booleans
(= 2 (+ 1 1))
(boolean? #t)
(boolean? #f)
(boolean? "no")
(if "no" 1 0)

;; 2. Numbers
; exact: int, rational, complex number
; inexact: IEEE floating-point, IEEE infiities
0.5
#e0.5
; #b, #o, #x
#x03BB

(inexact->exact 0.1)

; rational
(sin 0)
; not rational
(sin 1/2)

(define (sigma f a b)
  (if (= a b)
      0
      (+ (f a) (sigma f (+ a 1) b))))
(sigma (lambda (n) (* n 2)) 1 5)

(time (round (sigma (lambda (x) (/ 1 x)) 1 2000)))
(time (round (sigma (lambda (x) (/ 1.0 x)) 1 2000)))

(exact? (/ 1 3))
(exact? 1.0)

; checking funcs
; number?, integer?, rational?, real?, complex?

(= 1 1.0)
(equal? 1 1.0)
(eqv? 1 1.0)

; beaware of comparisions involving inexact numbers
(= 1/2 0.5)
(= 1/10 0.1)

;; 3 Characters
(integer->char 65)
(char->integer #\A)
(char->integer #\a)

#\λ
#\u03BB

; valid :)
#\崔

#\space
#\newline

; display a char
(display #\a) (newline)

; classification
(char-alphabetic? #\A)
(char-numeric? #\0)
(char-whitespace? #\newline)
(char-downcase #\A)
(char-upcase #\ß)

; compare
(char=? #\a #\A)
(char-ci=? #\a #\A)
(eqv? #\a #\A)

;; 4. Strings (Unicode)
"Apple"
"\u03BB"

(display "a \"quoted\" thing \n")

; mutable strings
(string-ref "Apple" 0)
(define s (make-string 5 #\.))
s
(string-set! s 2 #\λ)
s

;; 5. Bytes and Byte Strings

;; 6. Symbols

; A symbol is an atomic value that prints like an identifier preceded with '
'a
(symbol? 'a)

(eq? 'a 'a)
(eq? 'a (string->symbol "a"))
#ci'A

;; 7. Keywords
(string->keyword "apple")

;; 8. Pairs and lists
(cons 1 2)
(cons (cons 1 2) 3)
; car, cdr
; pair?
(pair? (cons 1 2))

; list
null
empty
(eq? null empty) ; #t
(null? empty)
(list? empty)

(cons 0 (cons 1 (cons 2 null)))
(list? (cons 1 2))
(list? '(1 2 3))

(for-each (lambda (i) (display i)) '(1 2 3)) (newline)

; mutable pair and list
(define p (mcons 1 2))
p
(pair? p)
(mpair? p)

(set-mcar! p 0)
p
(write p) (newline)

;; 9. Vectors
#("a" "b" "c")
(vector? #("a" "b" "c"))

;; 10. Hash tables

;; 11. Boxes
; a box is a single-element vector.
(define b (box "apple"))
b
(unbox b)
(set-box! b '(banana boat))
b

(symbol? (car '(banana boat)))

;; 12. Void and undefined
(void)
(void 1 2 3)
(list (void) (void))








