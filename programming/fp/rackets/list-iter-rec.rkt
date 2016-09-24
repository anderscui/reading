#! /usr/bin/env racket

#lang racket

;; Racket is dialect of the language Lisp "LISt Processor."

(list "red" "green" "blue")
(list 1 2 3)

; many predefined funcs for lists
(define l (list "hop" "skip" "jump"))
(length l)
; ref by pos
(list-ref l 0)
; combine lists
(append (list "hop" "skip") (list "jump"))
; reverse
(reverse l)
; contains
(member "skip" l)
(member "fall" l)

;; 1. List loops: map, andmap, ormap; filter; foldl
(map sqrt (list 1 4 9 16))
(map (lambda (s) (string-append s "!"))
     (list "peanuts" "popcorn" "crackerjack"))

(andmap string? (list "a" "b" "c"))
(andmap string? (list "a" "b" 6))

; map multiple lists
(map (lambda (s n) (substring s 0 n))
     (list "peanuts" "popcorn" "crackerjack")
     (list 6 3 7))

; filter
(filter string? (list "a" "b" 5))
(filter positive? (list 1 2 -3 5))

; foldl
(foldl (lambda (elem v)
          (+ v (* elem elem)))
       0
       '(1 2 3))

;; 2. List iteration
; a racket list is a linked list, the two core op are: first and rest
(first (list 1 2 3))
(rest (list 1 2 3))

; append
empty
(cons "head" empty)
(cons "bread" (cons "head" empty))

; empty checking
(empty? empty)
(cons? empty)

; define your own length and map
(define (len lst)
  (if (empty? lst)
    0
    (+ 1 (len (rest lst)))))
(len empty)
(len (list 1 2 3))

(define (newmap f lst)
  (cond
    [(empty? lst) empty]
    [else (cons (f (first lst)) (newmap f (rest lst)))]))

(newmap (lambda (v) (* v 2))
  (list 1 2 3))

;; 3. Tail recursion
(define (len2 lst)
  ; local func
  (define (iter lst len)
    (cond
      [(empty? lst) len]
      [else (iter (rest lst) (+ len 1))]))
  (iter lst 0))

(len2 empty)
(len2 (list 1 2 3))

(define (newmap2 f lst)
  (for/list ([i lst])
    (f i)))

(newmap2 (lambda (v) (* v 2))
  (list 1 2 3))

;; 4. Recursion vs. iteration
(define (remove-dups l)
  (cond
    [(empty? l) empty]
    [(empty? (rest l)) l]
    [else
      (let ([i (first l)])
        (if (equal? i (first (rest l)))
          (remove-dups (rest l))
          (cons i (remove-dups (rest l)))))]))

(remove-dups (list "a" "b" "b" "b" "c" "c"))


