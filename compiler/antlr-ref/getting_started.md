# ANTLR v4 快速入门

## 安装

ANTLR包含两部分，一部分是将语法文件(grammar)翻译为parser/lexer文件的**工具**，后者可以是Java、C#、Python等target，另一部分则是parser/lexer所需要的**运行时（runtime）**。

在Mac上的安装可使用如下命令：

```shell
$ cd /usr/local/lib
$ sudo curl -O http://www.antlr.org/download/antlr-4.7-complete.jar
$ export CLASSPATH=".:/usr/local/lib/antlr-4.7-complete.jar:$CLASSPATH"
$ alias antlr4='java -jar /usr/local/lib/antlr-4.7-complete.jar'
$ alias grun='java org.antlr.v4.gui.TestRig'
```

另外，在IntelliJ IDEA上可安装ANTLR插件。

### 测试安装

```shell
$ java org.antlr.v4.Tool
ANTLR Parser Generator  Version 4.7
 -o ___              specify output directory where all output is generated
 -lib ___            specify location of grammars, tokens files
 ...
```

## Hello, ANTLR

任意选择一个目录，创建文件Hello.g4，它包含如下内容：

```antlr
// Define a grammar called Hello
grammar Hello;
r  : 'hello' ID;
ID : [a-z]+;
WS : [ \t\r\n]+ -> skip;
```

这个文件不妨视作ANTLR的HelloWorld，接下来用ANTLR生成parser/lexer并编译：

```shell
$ antlr4 Hello.g4
$ javac Hello*.java

# 可指定target语言
$ antlr4 -Dlanguage=Python2 Hello.g4
```

现在可以测试了：

```shell
grun Hello r -tree
hello antlr
^D
(r hello antlr)

# 类似地，可以用-gui选项显示GUI。
```

## 其它

在[https://github.com/antlr/grammars-v4](https://github.com/antlr/grammars-v4)中有多种常见语言的语法文件。

