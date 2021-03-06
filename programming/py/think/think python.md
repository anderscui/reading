# Think Python

# 第一章 关于程序

程序员最重要的一项技能是**问题解决**，即搞清楚问题，找出解决方案（有时还需要一些创造性），清晰而准确地表达之。

## 1.1 Python编程语言

Python是一种**高级语言**（high-level language），常见的高级语言还有C、C++、Java等。

有高级语言，就意味着有**低级语言**（low-level language），有时又称为**机器语言**或**汇编语言**。你大概听说计算机只能理解0、1这样的数据，确实是这样的。必须告诉计算机：把这两个数相加，或者相乘，或者是更复杂的计算。计算机能够直接“读懂”的代码是很简单直接的。这就是“机器语言”这样的名字的由来，就是说这样的语言更接近于机器能够理解的层次。

由于机器能懂的语言需要时简单直接的，在人看来就变得繁琐了。而且人类需要的语言是，我告诉你我想要什么，你给我去算，我不太关心你在底下是如何做的。高级语言更接近于人类能够理解的层次。

所以，高级与低级是说一种语言更适合人类阅读还是计算机阅读。

另一方面，人类易读的语言，计算机就不容易理解了，所以需要一种专门的程序，将高级语言“翻译”为低级语言，这样人类和计算机就皆大欢喜了。这样的专门程序一般有两种形式：**解释器**（interpreter）和**编译器**（compiler）。结果是，绝大多数程序都是以高级语言编写的。

解析器一边“读”程序，一边解释执行；编译器则一次性编译完毕，得到“可执行程序”（executable），之后无须再次编译。在Windows上，就是常见的.exe文件。

Python是一种解释型语言，它有一个解释器，就是系统里安装的`python`程序，它可以执行Python源代码文件。通常编写代码时，有两种模式：交互模式（interactive mode）和脚本模式（script mode）。

在使用`python`或`IDLE`时，是交互模式，所谓交互，即你输入一行代码，它就立即执行并显示结果。也可以在系统的终端程序（terminal）里，直接以脚本模式执行文件，比如：

```shell
python script_name.py
```

这时，Python代码文件常常被称为**脚本**。

## 1.2 什么是程序

**程序**是一连串的**指令**（instruction），指示计算机进行某些运算。此处的运算，除了一般的数学运算，也可以是文字操作、视频操作或游戏等等。

尽管我们会遇到各种各样的程序，它们以各种各样的语言编写。但每一种语言都需要包含一些最基本的模块：

* 输入：从键盘、文件或网络等设备读入数据
* 输出：将数据显示到屏幕，或保存到文件里
* 数学运算
* 条件执行：检查某些条件，只在某些情况下执行一段代码（if ... else ...）
* 重复执行：多次执行一种操作（for；while等）

这些是程序的最基本组件。

## 1.3 什么是debug

可以确定的是，程序容易出错。由于一些历史原因，编程中出现的错误称为bug，消除bug的过程就称为**调试**（debugging）。

程序可能会出现三种错误：

### 1.3.1 语法错误

与人类的自然语言类似，代码编写必须符合特定的结构和规则，这些结构和规则称为语法，如果代码不合语法，执行时会报错，比如`SyntaxError`。

### 1.3.2 运行时错误

语法没问题，但执行时有异常情况发生。比如除以一个数，但它的值是0；或读取一个文件的内容，但文件不存在。

### 1.3.3 语义错误

程序成功执行，没有报错，但结果不是我们期望的。此时需要仔细查看代码的逻辑，找出原因。

## 1.4 形式语言（formal language）与自然语言（natural language）


## 1.5 第一个程序

强烈建议使用Python 3，会减少很多不必要的麻烦。

## 1.7 术语表

除了上面提到的，还有：

* portability：可移植性，表示一个程序多大程度上可以运行在不同的计算机上；
* source code：源代码
* object code：目标码
* algorithm：算法，解决问题的策略，计算机科学的核心概念之一
* exception：异常，程序运行过程中出现的错误
* token：后面再说：）
* parse：解析，检查一个程序，分析其语法结构



