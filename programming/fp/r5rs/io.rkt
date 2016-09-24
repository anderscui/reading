#! /usr/bin/env racket
#lang sicp

; print to screen: display, write, newline
(define (pl data)
  (display data)
  (newline))

(pl 1)

; write is almost like display
(define (square x) (* x x))

(define test
  (lambda ()
    (begin
      (write "Scheme is good: ")
      (write (square 2))
      (newline))))
(test)

; The procedure write is usually used together with the procedure read.
(define (show type v)
  (begin
    (display type)
    (display ": ")
    (display v)
    (newline)))

(define (blopp)
  (let ([a (read)])
    (cond [(number? a) (show "number" a)]
          [(char? a) (show "char" a)]
          [(string? a) (show "string" a)]
          [(symbol? a) (show "symbol" a)]
          [(list? a) (show "list" a)]
          [else (show "unknown type" a)])))

; (blopp)

;; IO for files
(define p (open-input-file "test.txt"))
(read p)
(read p)
(read p)
(read p)
(close-input-port p)
; (read p)

(define (iter p)
  (let ([next (read p)])
    (if (eof-object? next)
      (display "eof...")
      (begin
        (pl next)
        (iter p)))))

(define (cat file)
  (let ([f (open-input-file file)])
    (begin
      (iter f)
      (close-input-port f))))

(cat "test.txt")

; write file
(define (display-list ls)
  (if (null? ls)
    (newline)
    (begin
      (display (car ls))
      (newline)
      (display-list (cdr ls)))))

(define (write-list-to-file file ls)
  (with-output-to-file file
    (display-list ls)))

(write-list-to-file "out.txt" (list 1 2 3))
