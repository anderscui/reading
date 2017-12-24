# The Little Schemer, 4th Edition

	by Daniel P.Friedman and Matthias Felleisen
	
# The Ten Commandments (十诫) 

1. 对一个原子列表(lat，list of atom)递归时，先问两个问题：(null? lat)，以及else。而对一个数字递归时，也要问两个问题：(zero? n)，以及else。最后，如果是对一个S-expr列表递归，问三个问题：(null? l)，(atom? (car l))，以及else。
2. 使用`cons`构造列表
3. 构造列表时，描述第一个典型的元素是如何的，然后使用`cons`与其余由递归得来的列表合并
4. 进行递归时，一次至少要更新一个参数。如果是原子列表lat，用(cdr lat)；如果是数字，用(sub1 n)；如果是S-expr列表，当(null? l)和(atom? (car l))都不成立时用(car l)和(cdr l)
5. 使用`+`构造值时，使用0作为结束点；对于`*`，则使用1；类似地，对`cons`使用()
6. 在函数已经正确实现后才开始考虑简化和优化
7. 对具有相同特征的其它子部（subpart）递归，如列表中的子列表；算术表达式的子表达式
8. 通过辅助函数（help function）对表现（representation）进行抽象
9. 将相同的模式抽象为新的函数
10. 使用函数一次收集多于一个的值

上述十诫，在学完Coursera上的Scala公开课后变得容易理解了。

* 1确定思考起点，4保证递归可正常结束；
* 2、3确定如何构造一个列表
* 5说明类似于fold的过程
* 6-10说明代码的设计过程

# 五规则

* Car：仅定义于非空列表
* Cdr：仅定义于非空列表，返回值亦为列表
* Cons：连接两值，第二值为列表
* Null?：判断列表是否为空
* Eq?：判断两个非数值原子是否相等

# 基本概念

* atom: (and (not pair) (not null))，简单来说，就是非列表的数据（值）
* pair: 由任意两个值（包括pair类型的值）结合而成的数据对，有`cons`函数实现；
* list: 基于pair构成的链表结构；同时也是函数，生产list类型的数据；
* S-expr: symbolic expression，表示嵌套list，它可以是atom或由两个S-expr构成的表达式；
* quote: 一种form，生成常量值，该值即相应代码片段的字面值（即不是其词法信息，不解释）。`(quote (+ 1 2)`的值是`'(+ 1 2)`，而`(+ 1 2)`的值是`3`。
* constant：常量，可以自明的值，如number、string或boolean等。

## atom 示例

* `'atom`，`'123`，`'u`

## list 示例

* `'(atom)`，`'(atom turkey or)`
* `'((atom turkey) or)`

## S-expression 示例

* all atoms
* all lists (including () - null list)

# 前言

For the student of List programming, The Little LISPer can perform the same service that Hanon's finger exercises or Czerny's piano studies perform for the student of piano.

# 序

Designing a program requires a thorough understanding of data; a good program reflects the shape of the data it deals with. Most collections of data, and hence most programs, are recursive.

*The goal of this book is to teach the reader to think recursively.*

It is our belief that *writing programs recursively in Scheme is essentially simple pattern recognition.*

A few Scheme features: car, cdr, cons, eq?, null? zero?, add1, sub1, number?, and, or, quote, lambda, define, and cond.

# Toys

## The Law of Car

The primitive `car` is defined only for non-empty lists.

## The Law of Cdr

The primitive `cdr` is defined only for non-empty lists. The `cdr` of any non-empty list **is always another list**.

`cdr` is pronounced "could-er".

## The Law of Cons

The primitive `cons` takes two arguments. The second argument to `cons` must be a list. The result is a list.

## The Law of Null?

The primitive `null?` is defined only for lists, and only returns true for null list.

## The Law of Eq?

The primitive `eq?` takes two arguments. Each must be a **non-numeric atom**.

# Do it, again and again...

...

# Cons the Magnificent

`rember`: remove a (first one) member from a lat.



