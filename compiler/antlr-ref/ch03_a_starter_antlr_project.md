# A Starter ANTLR Project

现在来做我们的第一个“项目”，识别C家族语言中由花括号包围的整数，其中可能含有嵌套。如：

```java
{1, 2, 3}
{1, {2, 3}, 4}
```

这样的结构可用作int数组或结构体的初始化。现在要实现的功能是如下转化：

```java
short[] data = {1, ,2 3};
String[] data = "\u0001\u0002\u0003"
```

之所以从short到String，是因为Java的`.class`文件对初始化方法的size有限制，转化为String则可以突破这种限制。

通过这个小例子，我们可以了解ANTLR的一点语法，ANTLR从语法生成的代码，如何将这些代码集成到我们的语言应用，最后是如何通过listener完成上述数组到字符串的转换。

## 3.1 ANTLR Tool、Runtime及其生成的代码

当我们说"run ANTLR on a grammar"，我们说的是运行ANTLR tool，即类`org.antlr.v4.Tool`。这里的语法文件是：

```antlr
/** Grammars always start with a grammar header.
* the name must match the filename: ArrayInit.g4
*/
grammar ArrayInit;

init : '{' value (',' value)* '}';

value : init
      | INT
      ;

INT : [0-9]+;
WS  : [ \t\r\n]+ -> skip;
```

通过antlr4生成parser类，会得到若干文件：

* ArrayInitParser.java: parser class def
* ArrayInitLexer.java:
* ArrayInit.tokens: ANTLR为每一种token类型指定一个id。
* ArrayInitListener.java

### ANTLR语法强于正则表达式

## 3.2 编译并测试Parser

以`javac *.java`编译代码，以`grun`测试之：

```shell
$ grun ArrayInit init -tokens
{1, 23, 456}
[@0,0:0='{',<'{'>,1:0]
[@1,1:1='1',<INT>,1:1]
[@2,2:2=',',<','>,1:2]
[@3,4:5='23',<INT>,1:4]
[@4,6:6=',',<','>,1:6]
[@5,8:10='456',<INT>,1:8]
[@6,11:11='}',<'}'>,1:11]
[@7,13:12='<EOF>',<EOF>,2:0]
```

亦可以以`-tree`或`-gui`选项查看之。

## 3.3 集成Parser到Java程序

下面这个Java程序是使用ANTLR的最简单示例：

```java
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

public class TestArrayInit {
  public static void main(String[] args) throws Exception {
    ANTLRInputStream input = new ANTLRInputStream(System.in);
    
    ArrayInitLexer lexer = new ArrayInitLexer(input);
    CommonTokenStream tokens = new CommonTokenStream(lexer);
    
    ArrayInitParser parser = new ArrayInitParser(tokens);
    ParseTree tree = parser.init(); // begin parsing at 'init rule'
    
    System.out.println(tree.toStringTree(parser));
  }
}
```

编译并测试之：

```shell
$ javac ArrayInit*.java TestArrayInit.java
$ java TestArrayInit
{1,{2,3},4}
(init { (value 1) , (value (init { (value 2) , (value 3) })) , (value 4) })

$ java TestArrayInit
{1,2
line 2:0 extraneous input '<EOF>' expecting {',', '}'}
(init { (value 1) , (value 2) <missing '}'>)
```

第二个测试用例显示了ANTLR如何显示错误信息。这个“应用”无疑是相当trivial的，下面看看如何实现本章开始的需求：转换short数组到String。

## 3.4 创建语言应用

上面的小例子说明如何识别语法结构，但如果要完成“翻译”工作，就需要从解析树中提取数据。最简单的方法是由ANTLR的遍历者触发一系列的callback。

我们需要做的是实现一系列的Listener。

```java
public class ShortToUnicodeString extends ArrayInitBaseListener {
  @Override
  public void enterInit(ArrayInitParser.InitContext ctx) {
    System.out.print('"');
  }

  @Override
  public void exitInit(ArrayInitParser.InitContext ctx) {
    System.out.print('"');
  }

  @Override
  public void enterValue(ArrayInitParser.ValueContext ctx) {
    int value = Integer.valueOf(ctx.INT().getText());
    System.out.printf("\\u%04x", value);
  }
}
```

这是一个相当简单的实现，而且可以看到，不需要所有的enter/exit方法，只需要覆盖我们关心的那些。接下来再编写一个主程序进行翻译：

```java
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

public class Translate {
  public static void main(String[] args) throws Exception {
    ANTLRInputStream input = new ANTLRInputStream(System.in);
    ArrayInitLexer lexer = new ArrayInitLexer(input);
    CommonTokenStream tokens = new CommonTokenStream(lexer);
    ArrayInitParser parser = new ArrayInitParser(tokens);
    ParseTree tree = parser.init(); // begin parsing at 'init rule'

    // create a generic parse tree walker that can trigger callbacks.
    ParseTreeWalker walker = new ParseTreeWalker();
    walker.walk(new ShortToUnicodeString(), tree);
    System.out.println();
  }
}
```

编译并测试之：

```shell
$ javac ArrayInit*.java Translate.java
$ java Translate
{99, 3, 345}
"\u0063\u0003\u0159"
```




