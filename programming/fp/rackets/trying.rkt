#lang slideshow

(define c (circle 10))
(define r (rectangle 10 20))

(define (square n)
  ; A semi-colon starts a line comment.
  (filled-rectangle n n))

; (square 10)

; local binding by define
(define (four p)
  (define two-p (hc-append p p))
  (vc-append two-p two-p))

; (four c)

; local binding by let which is typically preferred
(define (checker p1 p2)
  (let ([p12 (hc-append p1 p2)]
        [p21 (hc-append p2 p1)])
    (vc-append p12 p21)))

; (checker (colorize (square 10) "red")
;         (colorize (square 10) "green"))

; local binding with let*
(define (checkerboard p)
  (let* ([rp (colorize p "red")]
         [bp (colorize p "black")]
         [c (checker rp bp)]
         [c4 (four c)])
    (four c4)))

; (checkerboard (square 10))

; funcs are values
; circle

(define (series mk)
  ; mk is a func to make a pic which accepts a single parameter for size
  (hc-append 4 (mk 5) (mk 10) (mk 20)))

; (series circle)
; (series square)
; ; or evan a lambda
; (series (lambda (size) (checkerboard (square size))))

; a define form for a func is really a shorthand for a single define using lambda as the value

;; Lexical Scope
; Racket is a lexically scoped language
(define (rgb-series mk)
  (vc-append
   (series (lambda (sz) (colorize (mk sz) "red")))
   (series (lambda (sz) (colorize (mk sz) "green")))
   (series (lambda (sz) (colorize (mk sz) "blue")))))

; (rgb-series circle)
; (rgb-series square)

(define (rgb-maker mk)
  (lambda (sz)
    (vc-append (colorize (mk sz) "red")
               (colorize (mk sz) "green")
               (colorize (mk sz) "blue"))))

; (series (rgb-maker circle))
; (series (rgb-maker square))

;; Lists
; (list "red" "green" "blue")
; (list (circle 10) (square 10))

; map
(define (rainbow p)
  (map (lambda (color)
         (colorize p color))
       (list "red" "orange" "yellow" "green" "blue" "purple")))

; (rainbow (square 5))

; apply
; (apply vc-append (rainbow (square 5)))

;; Modules

; import
(require pict/flash)
; (filled-flash 40 30)

;; Macros
(require slideshow/code)
; (code (circle 10))

;; define a new syntax
(define-syntax pict+code
  (syntax-rules ()
    [(pict+code expr)
     (hc-append 10
                expr
                (code expr))]))

; (pict+code (circle 10))

;; Objects
(require racket/class
         racket/gui/base)

(define f (new frame% [label "My Art"]
               [width 300]
               [height 300]
               [alignment '(center center)]))

(send f show #t)

(define (add-drawing p)
  (let ([drawer (make-pict-drawer p)])
    (new canvas% [parent f]
         [style '(border)]
         [paint-callback (lambda (self dc)
                           (drawer dc 0 0))])))

(add-drawing (pict+code (circle 10)))
(add-drawing (colorize (filled-flash 50 30) "blue"))