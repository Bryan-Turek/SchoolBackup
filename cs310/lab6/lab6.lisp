; 1b1
(define doubler
  (lambda (x) (* x 2)))

(say (doubler 5)) ; expect 10

; 1b2
(define two
  (lambda (x) (equal? 2 x)))

(say (two 2)) ; expect True
(say (two 3)) ; expect False

; 1b3
(define nil (list))
(say (cons (' beginning) nil)) ; expect ['beginning']

; 1b4
(define last
  (lambda (x) (last? (car x) (cdr x))))

(define last?
  (lambda (x y)
    (if y
      (last y)
      x)))

(say (last (' (a b c d e)))) ; expect e
(say (last (' (a))))         ; expect a

; 1b5
(define key
  (lambda (lst)
    (car (car lst))))

(define update ; adds pos if not already there
    (lambda (pos value lst)
      (begin
       (if lst
	       (if (equal? pos (key lst))
	       (cons (list (key lst) value) (cdr lst))
	       (cons (car lst)     (update pos value (cdr lst))))
	   (list (list pos value))))))

(define data (' ((name tim)
                 (age  53)
                 (gender  m))))
(say data)
(set! data (update (' name) (' george) data))
(say data)
(set! data (update (' mood) (' happy) data))
(say data)

; 2a dumb tracing
