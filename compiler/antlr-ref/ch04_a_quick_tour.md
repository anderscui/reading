# A Quick Tour

这一章将通过几个例子来对ANTLR的特性做一个快速了解，主要分以下几个主题：

1. 创建一个算术表达式语言，以了解表达式语法的解析树。并演示如何将规模较大的语言分解为较小的模块。
2. 在算术表达式的基础上，使用Visitor模式创建一个计算器app。
3. 一个Java类定义文件翻译器，从中提取出相应的Java接口定义。
4. 学习如何在语法中直接嵌入**行为（action）代码**。这样的代码比Listener和Visitor更为灵活强大。
5. 更仔细地了解ANTLR在词法级别上的几个特性。

## 4.1 算术表达式语言

在我们的算术表达式语言中，语句由换行符分隔，每一条语句或者是表达式，或者是赋值语句，或者是空行。其语法文件是：

```antlr
grammar Expr;

/** the start rule; begin parisng here */
prog: stat+;

stat: expr NEWLINE
    | ID '=' expr NEWLINE
    | NEWLINE
    ;

expr: expr ('*'|'/') expr
    | expr ('+'|'-') expr
    | INT
    | ID
    | '(' expr ')'
    ;

ID: [a-zA-Z]+;
INT: [0-9]+;
NEWLINE: 'r'? '\n';
WS : [ \t]+ -> skip;
```

让我们透过这一语法文件一窥ANTLR语法文件的核心元素：

* “语法”包含了一组描述语言的**规则**。有的规则用于描述语法结构，如stat和expr，有的则是描述词汇symbol（token），如ID和INT。
* 以小写字母开始的规则是**解析器规则**。
* 以大些字母开始的规则是**词法规则**。
* 可以用`|`表示规则的“or”关系。
* -> skip表示匹配并丢弃相应的文本。

ANTLR v4最重要的新特性之一是，可以出来左递归规则，如上面的`expr`规则。支持此特性的语法编写起来会大大简化。

现在可以把玩一下这个小语法了，在文件`t.expr`中保存几个表达式：

```shell
193
a = 5
b = 6
a + b * 2
(1+2)*3
```

以命令`grun Expr prog -gui t.expr`查看之：

![parse-tree](http://images2015.cnblogs.com/blog/12089/201705/12089-20170501220233367-1840463947.png)

### 导入语法

当语法规模变得过大时，可考虑将其分解为几个较小的部分。比如，将lexer和parser部分分开。

上面语法的lexer部分：

```antlr
lexer grammar CommonLexerRules;

ID: [a-zA-Z]+;
INT: [0-9]+;
NEWLINE: 'r'? '\n';
WS : [ \t]+ -> skip;
```

parser部分：

```antlr
grammar Expr;
// includes all rules from CommonLexerRules.g4
import CommonLexerRules;

/** the start rule; begin parisng here */
prog: stat+;

stat: expr NEWLINE
    | ID '=' expr NEWLINE
    | NEWLINE
    ;

expr: expr ('*'|'/') expr
    | expr ('+'|'-') expr
    | INT
    | ID
    | '(' expr ')'
    ;
```

使用LibExpr时与单独的Expr文件完全一样。

### 处理错误输入

## 4.2 使用Visitor创建一个计算器

ANTLR可生成Visitor接口以及一个空的实现。

为使用Visitor，我们需要对语法做几处修改。一是对可选规则添加**标签（label）**，若无标签，ANTLR只会为一个规则生成一个visitor方法；二是对操作符常量定义名称。

```antlr
grammar LabeledExpr;

/** the start rule; begin parisng here */
prog: stat+;

stat: expr NEWLINE            # printExpr
    | ID '=' expr NEWLINE     # assign
    | NEWLINE                 # blank
    ;

expr: expr op=('*'|'/') expr     # MulDiv
    | expr op=('+'|'-') expr     # AddSub
    | INT                     # int
    | ID                      # id
    | '(' expr ')'            # parens
    ;

MUL: '*';
DIV: '/';
ADD: '+';
SUB: '-';

ID: [a-zA-Z]+;
INT: [0-9]+;
NEWLINE: 'r'? '\n';
WS : [ \t]+ -> skip;
```

```java
import java.util.HashMap;
import java.util.Map;

public class EvalVisitor extends LabeledExprBaseVisitor<Integer> {
  Map<String, Integer> memory = new HashMap<String, Integer>();

  // Assignment stat
  @Override
  public Integer visitAssign(LabeledExprParser.AssignContext ctx) {
    String id = ctx.ID().getText();
    int value = visit(ctx.expr());
    memory.put(id, value);
    return value;
  }

  // expr
  @Override
  public Integer visitPrintExpr(LabeledExprParser.PrintExprContext ctx) {
    int value = visit(ctx.expr());
    System.out.println(value);
    return 0;
  }

  // INT
  @Override
  public Integer visitInt(LabeledExprParser.IntContext ctx) {
    return Integer.valueOf(ctx.INT().getText());
  }

  // ID
  @Override
  public Integer visitId(LabeledExprParser.IdContext ctx) {
    String id = ctx.ID().getText();
    if (memory.containsKey(id))
      return memory.get(id);
    return 0;
  }

  // expr (*|/) expr
  @Override
  public Integer visitMulDiv(LabeledExprParser.MulDivContext ctx) {
    int left = visit(ctx.expr(0));
    int right = visit(ctx.expr(1));
    if (ctx.op.getType() == LabeledExprParser.MUL)
      return left * right;
    return left / right;
  }

  // expr (+/-) expr
  @Override
  public Integer visitAddSub(LabeledExprParser.AddSubContext ctx) {
    int left = visit(ctx.expr(0));
    int right = visit(ctx.expr(1));
    if (ctx.op.getType() == LabeledExprParser.ADD)
      return left + right;
    return left - right;
  }

  @Override
  public Integer visitParens(LabeledExprParser.ParensContext ctx) {
    return visit(ctx.expr());
  }
}
```

```java
import java.io.FileInputStream;
import java.io.InputStream;

import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

public class Calc {
  public static void main(String[] args) throws Exception {
    String inputFile = null;
    if (args.length > 0) {
      inputFile = args[0];
    }
    InputStream is = System.in;
    if (inputFile != null)
      is = new FileInputStream(inputFile);

    ANTLRInputStream input = new ANTLRInputStream(is);
    LabeledExprLexer lexer = new LabeledExprLexer(input);
    CommonTokenStream tokens = new CommonTokenStream(lexer);
    LabeledExprParser parser = new LabeledExprParser(tokens);

    ParseTree tree = parser.prog(); // begin parsing at 'prog rule'

    EvalVisitor eval = new EvalVisitor();
    eval.visit(tree);
  }
}
```

看过[Let's Build A Simple Interpreter](https://ruslanspivak.com/lsbasi-part1/)系列后，这个visitor的实现很熟悉：）









