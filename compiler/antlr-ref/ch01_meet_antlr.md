# Meet ANTLR

对语法文件Hello.g4运行antlr工具，会得到可执行的parser/lexer识别器，即*Lexer.java和 *Parser.java。但一般情况下还没有主程序来触发语言识别。

在开发语言应用时，往往需要测试不同的语法，如果需要开发一个主程序来测试这些语法，无疑会节省很多工作量。ANTLR的TestRig就是这样一个灵活的测试工具。

```shell
$ grun Hello r -tokens
hello antlr
[@0,0:4='hello',<'hello'>,1:0]
[@1,6:10='antlr',<ID>,1:6]
[@2,12:11='<EOF>',<EOF>,2:0]
```

上面命令的作用是：对**语法Hello**执行TestRig工具，查看该语法的**r规则**，显示其token序列。

每一行显示了一个token的详细信息。如，第二行的[@1,6:10='antlr',<ID>,1:6]表示，该token内容是'antlr'，在序列中是第二个（@1)，类型为ID，在第1行上，范围是6:10。

除了-tokens，常用的其它选项还有：

* -tree
* -gui
* -ps file.ps
* -encoding
* ...







