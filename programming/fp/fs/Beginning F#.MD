# Beginning F# 4.0

# Ch01 Getting Started

## FPs

* IPL：1955 （FORTRAN：1956）
* Lisp：1958 （COBOL：1959）
* Others：SML, OCaml, APL, Clean, Erlang, Haskell

**Pure functions programming views all programs as collections of functions that accept arguments and return values**. It **allows no side effects** and **uses recursion instead of loops for iteration**.

The function in a functional program are **very much like mathematical func** because they do not change the state of the program.

The mathematical basis for pure functional programming is **elegant**, and FP therefore **provides beautiful, succinct solutions** for many computing problems. That said, **the stateless and recursive nature** of FP can make it seem harder to apply for many common programming tasks. However, one of F#’s great strengths is that you can **use multiple paradigms and mix them** to solve problems in the way you find most convenient.

*"The functional programmer sounds rather like a medieval monk, denying himself the pleasures of life in the hope that it will make him virtuous."*

	- by John Hughes, Chalmers University of Technology

Eliminating the distinction between data and functions means that many problems **can be more naturally solved**.

## What is F#?

Pure FP isn't suitable for general-purpose programming, so FP lans have gradually **embraced aspects of the imperative and OO paradigms**. F# is a natural successor on this path.

Some of the most popular FPs, including Haskell, Lisp, have traditionally been implemented using **custom runtimes**, which leads to problems such as **lack of interoperability**. (just like Clojure on JVM.) F# seamlessly integrates with the .NET BCL, using BCL in F# is as simple as using it in C#.

**F# was modelled on OCaml**, a successful OO FP language, and then tweaked and extended to mesh well technically and philosophically with .NET.

The F# compiler not only produces exe for any CLI but can also run on any env that has a CLI, which means F# is **not limited to Windows**(Mono, .NET Core).

## Who is using F#?

F# was initially marketed by MS as a lan for use in mathematics and the more math-oriented aspects of finance. Now developers are using F# in a remarkable variety of arenas, from quantum computing to sci instrument control to music.

# Ch03 Functional Programming

Although F# is not a pure functional lan, it does encourage you to program in the functional style; that is, it encourages you to use expressions and computations that return a result, rather than statements that result in some side effect.

## Identifiers and let Bindings

```fsharp
let x = 42
```

This seems like a "variable", but it's not changeable, it's not variable literally:)

An identifier can refer to either a value or a function, and since F# functions are really values in their right, this is hardly surprising.

### Identifier Names

As F# supports the use of a single quotation mark as part of an id name, you can use this to represent "prime" to create identifier names.

```f#
let x = 42

let add = fun x y -> x + y

// or
let multiply x y = x * y

printfs "x + 10 = %i" (add x 10)
printfs "2 * 3 = %i" (multiply 2 3)

// single quotation mark
let x' = 43

// unicode
let 标识符 = 42
printfs "标识符 = %i" 标识符
```

If the rules are too restrictive, you can use double tick marks to quote the id names.

### Scope

Identifiers within functions can be redefined using the `let` keyword.

### The `use` Binding

```f#
open System.IO

let readFirstLine filename = 
    use f = File.OpenText filename
    f.ReadLine()

printf "First line was: %s" (readFirstLine "test.txt")
```

### Recursion

Recursion is often used in FP where you would use a loop in imperative programming.

```f#
let rec fib x = 
    match x with
    | 1 -> 1
    | 2 -> 1
    | x -> fib(x-1) + fib(x-2)
```

### Operators

As in C#, F# operators are overloaded, meaning you can use more than one type with an operator. F# also allows users to define and redefine operators.

Operators can behave exactly like a function.

```f#
let result = (+) 1 1

// as a func
let add = (+)

// define a op
let (=?) a b = a = b
```

### Function Application

```f#
// a normal way
let add x y = x + y

let result = add (add 4 5) (add 6 7)

// pipe-forward op, and partial apply
let result = add 4 5 |> add 6 |> add 7
```

### Partial Apply

```f#
let add x y = x + y
let inc = add 1

printfn "inc 2 is %i" (inc 2)

let sub (a, b) = a - b
// not allowed
let dec = sub 1
```

### Pattern Matching

*Pattern matching* allows you to look at the value of an identifier and then make diff computations depending on its value. It seems like `switch` in C#, but it's much more powerful and flexible.

```f#
let rec luc x = 
    match x with
    | x when x <= 0 -> failwith "value must be greater than 0"
    | 1 -> 1
    | 2 -> 3
    | x -> luc (x-1) + luc (x-2)

let str2Bool x =
    match x with
    | "True" | "true" -> true
    | "False" | "false" -> false
    | _ -> failwith "unexpected input"
```

```f#
// if it matches head :: tail -> ... else -> ...
let rec concat =
    function head :: tail -> head + concat tail
           | [] -> ""

let jabber = ["Wish "; "you "; "good "; "wishes."]
printfn "%s" (concat jabber)
```

### Lists

F# lists are *immutable*.

### Pattern Matching Against Lists

The regular way to work with F# lists is to use **pattern matching** and recursion. 

### List Comprehensions

**List comprehensions** make creating and converting collections easy. You can create F# lists, seqs, and arrays directly using comprehension systax. (seq == IEnumerable)





