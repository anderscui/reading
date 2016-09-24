# Using Chez Scheme

(text extracted from Chez Scheme User's Guide 9.4)

Chez Scheme is often used interactively to support program development and debugging, yet it may also be used to create stand-alone applications with no interactive component.

## Interacting with Chez Scheme

(On Mac OSX, use homebrew to install Chez Scheme first)

One of the simplest and most effective ways to write and test Scheme programs is to **compose them using a text editor**, like VIM or whatever, and **test them interactively** with Chez Scheme running in a shell window. Entering `chez` or `petite` command in a shell window starts an interactive Scheme session:

```shell
Chez Scheme Version 9.4.1
Copyright 1984-2016 Cisco Systems, Inc.

>
```

Conventionally the angle-bracket is a prompt issued by the system's **"REPL"**, which stands for "Read Eval Print Loop". You can then type any Scheme expr:

```scheme
> 3
3
> (+ 3 4)
7
> (cons 'a '(b c d))
(a b c d)
```

The reader used by the REPL is more sophisticated than an ordinary editor, it's a full-blown "expr editor", e.g. the automatic indentation:

```scheme
> (define fact
    (lambda (n)
      (if (= n 0)
          1
          (* n (fact (- n 1))))))
> (fact 5)
120
```

We can use history mechanism to edit multi-line expr. Two useful shortcuts are Ctrl+L (show the complete expr) and Ctrl+J (hit enter). We can use Ctrl+D or `(exit)` to exit from the REPL.

## Load source from file

Developing a large program entirely in the REPL is unmanageable, and we usually even want to store smaller programs in a file for future use. A Scheme programmer typically creates a file containing Scheme source code using a text editor and loads the file into Chez Scheme to test them. The conventional filename extension for Chez Scheme source files is “**.ss**,” but the file can have any extension or even no extension at all. A source file can be loaded during an interactive session by typing (**load "path"**). Files to be loaded can also be named on the command line when the system is started. **Any form that can be typed interactively can be placed in a file to be loaded.**

### Pre-compile source files

**(compile-file "path")** compiles the forms in the file **path.ss** and places the resulting object code in the file **path.so**. Loading a pre-compiled file is essentially no different from loading the source file, except that **loading is faster since compilation has already been done**.

When compiling a file or set of files, it is often more convenient to use a shell command than to enter Chez Scheme interactively to perform the compilation. This is easily accomplished by “piping” in the command to compile the file as shown below.
```scheme
echo ’(compile-file "filename")’ | scheme -q
```

## The Interaction Environment

In the language of the Revised6 Report, code is structured into libraries and “top-level programs.” The Revised6 Report does not require an implementation to support interactive use, and it does not specify how an interactive top level should operate, leaving such details up to the implementation.


