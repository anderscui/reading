# The Little Schemer, 4th Edition

	by Daniel P.Friedman and Matthias Felleisen
	
# The Ten Commandments (十诫) 

1. 对一个原子列表(lat)递归时，先问两个问题：(null? lat)，以及else。而对一个数字递归时，也要问两个问题：(zero? n)，以及else。最后，如果是对一个S-expr列表递归，问三个问题：(null? l)，(atom? (car l))，以及else。
2. 使用`cons`构造列表
3. 构造列表时，描述第一个典型的元素是如何的，然后使用`cons`与其余由递归得来的列表合并
4. 进行递归时，一次至少要更新一个参数。如果是原子列表lat，用(cdr lat)；如果是数字，用(sub1 n)；如果是S-expr列表，当(null? l)和(atom? (car l))都成立时用(car l)和(cdr l)
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

# 前言




