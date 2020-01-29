require "spec_helper"

RSpec.describe "Minibel Parser" do
  let(:parser) { Babybel::Minibel.new }

  let(:bel_source) { <<BEL }
(def no (x)
  (id x nil))

(def atom (x)
  (no (id (type x) 'pair)))

(def all (f xs)
  (if (no xs)      t
      (f (car xs)) (all f (cdr xs))
                   nil))

(def some (f xs)
  (if (no xs)      nil
      (f (car xs)) xs
                   (some f (cdr xs))))

(def reduce (f xs)
  (if (no (cdr xs))
      (car xs)
      (f (car xs) (reduce f (cdr xs)))))

(def cons args
  (reduce join args))

(def append args
  (if (no (cdr args)) (car args)
      (no (car args)) (apply append (cdr args))
                      (cons (car (car args))
                            (apply append (cdr (car args))
                                          (cdr args)))))

(def snoc args
  (append (car args) (cdr args)))

(def list args
  (append args nil))

(def map (f . ls)
  (if (no ls)       nil
      (some no ls)  nil
      (no (cdr ls)) (cons (f (car (car ls)))
                          (map f (cdr (car ls))))
                    (cons (apply f (map car ls))
                          (apply map f (map cdr ls)))))

(mac fn (parms . body)
  (if (no (cdr body))
      `(list 'lit 'clo scope ',parms ',(car body))
      `(list 'lit 'clo scope ',parms '(do ,@body))))

(set vmark (join))

(def uvar ()
  (list vmark))

(mac do args
  (reduce (fn (x y)
            (list (list 'fn (uvar) y) x))
          args))

(mac let (parms val . body)
  `((fn (,parms) ,@body) ,val))

(mac macro args
  `(list 'lit 'mac (fn ,@args)))

(mac def (n . rest)
  `(set ,n (fn ,@rest)))

(mac mac (n . rest)
  `(set ,n (macro ,@rest)))

(mac or args
  (if (no args)
      nil
      (let v (uvar)
        `(let ,v ,(car args)
           (if ,v ,v (or ,@(cdr args)))))))

(mac and args
  (reduce (fn es (cons 'if es))
          (or args '(t))))
BEL

# 
# (def symbol (x) (= (type x) 'symbol))
# 
# (def pair   (x) (= (type x) 'pair))
# 
# (def char   (x) (= (type x) 'char))
# 
# (def stream (x) (= (type x) 'stream))
# 
# (def proper (x)
#   (or (no x)
#       (and (pair x) (proper (cdr x)))))
# 
# (def string (x)
#   (and (proper x) (all char x)))
# 
# (def mem (x ys (o f =))
#   (some [f _ x] ys))
# 
# (def in (x . ys)
#   (mem x ys))
# 
# (def cadr  (x) (car (cdr x)))
# 
# (def cddr  (x) (cdr (cdr x)))
# 
# (def caddr (x) (car (cddr x)))
# 
# (mac case (expr . args)
#   (if (no (cdr args))
#       (car args)
#       (let v (uvar)
#         `(let ,v ,expr
#            (if (= ,v ',(car args))
#                ,(cadr args)
#                (case ,v ,@(cddr args)))))))
# 
# (mac iflet (var . args)
#   (if (no (cdr args))
#       (car args)
#       (let v (uvar)
#         `(let ,v ,(car args)
#            (if ,v
#                (let ,var ,v ,(cadr args))
#                (iflet ,var ,@(cddr args)))))))
# 
# (mac aif args
#   `(iflet it ,@args))
# 
# (def find (f xs)
#   (aif (some f xs) (car it)))
# 
# (def begins (xs pat (o f =))
#   (if (no pat)               t
#       (atom xs)              nil
#       (f (car xs) (car pat)) (begins (cdr xs) (cdr pat) f)
#                              nil))
# 
# (def caris (x y (o f =))
#   (begins x (list y) f))
# 
# (def hug (xs (o f list))
#   (if (no xs)       nil
#       (no (cdr xs)) (list (f (car xs)))
#                     (cons (f (car xs) (cadr xs))
#                           (hug (cddr xs) f))))
# 
# (mac with (parms . body)
#   (let ps (hug parms)
#     `((fn ,(map car ps) ,@body)
#       ,@(map cadr ps))))
# 
# (def keep (f xs)
#   (if (no xs)      nil
#       (f (car xs)) (cons (car xs) (keep f (cdr xs)))
#                    (keep f (cdr xs))))
# 
# (def rem (x ys (o f =))
#   (keep [no (f _ x)] ys))
# 
# (def get (k kvs (o f =))
#   (find [f (car _) k] kvs))
# 
# (def put (k v kvs (o f =))
#   (cons (cons k v)
#         (rem k kvs (fn (x y) (f (car x) y)))))
# 
# (def rev (xs)
#   (if (no xs)
#       nil
#       (snoc (rev (cdr xs)) (car xs))))
# 
# (def snap (xs ys (o acc))
#   (if (no xs)
#       (list acc ys)
#       (snap (cdr xs) (cdr ys) (snoc acc (car ys)))))
# 
# (def udrop (xs ys)
#   (cadr (snap xs ys)))
# 
# (def idfn (x)
#   x)
# 
# (def is (x)
#   [= _ x])
# 
# (mac eif (var (o expr) (o fail) (o ok))
#   (with (v (uvar)
#          w (uvar)
#          c (uvar))
#     `(let ,v (join)
#        (let ,w (ccc (fn (,c)
#                       (dyn err [,c (cons ,v _)] ,expr)))
#          (if (caris ,w ,v id)
#              (let ,var (cdr ,w) ,fail)
#              (let ,var ,w ,ok))))))
# 
# (mac onerr (e1 e2)
#   (let v (uvar)
#     `(eif ,v ,e2 ,e1 ,v)))
# 
# (mac safe (expr)
#   `(onerr nil ,expr))
# 
# (def literal (e)
#   (or (in e t nil o apply)
#       (in (type e) 'char 'stream)
#       (caris e 'lit)
#       (string e)))
# 
# (def variable (e)
#   (if (atom e)
#       (no (literal e))
#       (id (car e) vmark)))
# 
# (def isa (name)
#   [begins _ `(lit ,name) id])
# 
# (def bel (e (o g globe))
#   (ev (list (list e nil))
#       nil
#       (list nil g)))
# BEL

  it "parses enough bel to write an interpreter in bel" do
    parsed = false
    result = nil

    begin
      result = parser.parse(bel_source)
      parsed = true
    rescue Parslet::ParseFailed => error
      puts error.parse_failure_cause.ascii_tree
      binding.pry
    end

    expect(parsed).to be(true)
  end
end
