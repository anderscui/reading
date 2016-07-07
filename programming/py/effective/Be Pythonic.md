# Pythonic Thinking

The idioms of a programming language are defined by its users. Over the years, the Python community has come to use the adjective *Pythonic* to describe code that follows a particular style. The style isn't regimented or enforced by the compiler, it has emerged over time through experience using the language and working with others.

Python programmers prefer to be explicit, to choose simple over complex, and to maximize readability (type `import this`).

It's important for everyone to know the best -- the *Pythonic* -- way to do the most common things in Python.

## Item 1: Know Which Version of Python You're Using

```shell
$ python --version
Python 3.5.1 :: Anaconda 4.0.0 (x86_64)
```

Python 3 is usually available under the name `python3`.

We can also figure out the version of Python at runtime by inspecting values in the `sys` module.

```python
In [1]: import sys
In [2]: print(sys.version_info)
sys.version_info(major=3, minor=5, micro=1, releaselevel='final', serial=0)

In [3]: print(sys.version)
3.5.1 |Anaconda 4.0.0 (x86_64)| (default, Dec  7 2015, 11:24:55)
[GCC 4.2.1 (Apple Inc. build 5577)]
```

Python 3 is constantly getting new features and improvements that will never be added to Python 2, so **use Python 3 for your next Python project**.

## Item 2: Follow the PEP 8 Style Guide

Python Enhancement Proposal #8, otherwise known as PEP 8, is the style guide for how to format Python code.

PEP 8 continues to be updated as the Python language evolves. [pep-008](http://www.python.org/dev/peps/pep-0008/)

### Whitespaces matter

* Use spaces instead of tabs
* Use four spaces for each level of indenting
* Lines should be 79 chars or less
* In a file, functions and classes should be separated by two blank lines (**module**)
* In a class, methods should be separated by one blank line

### Naming

* Functions, variables, and attributes should be in **lowercase_underscore** format (read_csv())
* Protected instance attributes should be in **_leading_underscore** format (_name)
* Private instance attributes should be in **__double_leading_underscore** format
* Classes and exceptions should be in `CapitalizedWord` format (or `PascalStyle`)
* Module-level constants should be in `ALL_CAPS` format
* Instance methods in classes should use `self`
* Class methods should use `cls`

### Expressions and Statements

* Use inline negation (`if a is not b`) instead of negation of positive exp (`if not a is b`)
* Use `if not somelist` instead of `if len(somelist) == 0`
* Similarly use `if somelist`
* **Avoid single-line** `if` statements, `for` and `while` loops, and `except` compound statements
* Put `import` statements at the top of a file
* Always use absolute names for modules when importing them, not names relative to the current module's own path. Use `from bar import foo` instead of just `import foo`
* If you must do relative imports, use the explicit syntax `from . import foo`
* Orders of imports: standard lib, third-party modules, your own modules (similar to C# usings)

You can try [Pylint](http://www.pylint.org/) tool.

## Item 3: Know the Difference Between bytes, str, and unicode

seq of chars:
* Python 3: **bytes** and **str**
* Python 2: **str** and **unicode**

To convert Unicode chars to binary data, you must use the `encode` method, to convert binary data to Unicode chars, use the `decode` method.

* Use helper functions to ensure that the inputs you operate on are the type of character sequences you expect (8-bit values, UTF-8 encoded chars, Unicode chars, etc.)
* If you want to read or write binary data to/from a file, always open the file using a binary mode (like 'rb' or 'wb')

## Item 4: Write Helper Functions Instead of Complex Expressions



## Item 5: Know How to Slice Sequences

Python includes syntax for slicing sequences into pieces. The simplest uses for slicing are built-in types `list`, `str`, and `bytes`. Slicing can be extended to any Python class that implements the `__getitem__` and `__setitem__` special methods.

* Use `a[:5]` instead of `a[0:5]`
* Use `a[5:]` instead of `a[5:len(a)]`

Using negative numbers for slicing is helpful for doing offsets relative to the end of a list, e.g. you want to read elements to the last two, if you don't use `-2`, you would have to find the exact positive index of it.

**The result of slicing a list is a whole new list, modifying the result of slicing won't affect the original list.**

## Item 6: Avoid Using start, end and stride in a Single Slice

The point is that the `stride` part of slicing syntax can be extremely confusing. If you really want to use it, consider:

* prefer using positive `stride` values
* sclie and then stride
* `islice` of `itertools`

## Item 7: Use List Comprehensions Instead of map and filter

List comprehensions are clearer than the `map` and `filter` built-in functions because they don't require extra `lambda` expressions.

Lists, dicts and sets all support comprehension expressions.

## Item 8: Avoid More Than Two Expressions in List Comprehensions

List comprehensions also support multiple levels of looping, e.g. for iterating a matrix. These exp run in the order provided from left to right.

```python
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flat = [x for row in matrix for x in row]
print(flat)
-> [1, 2, 3, 4, 5, 6, 7, 8, 9]
```

But if a list comprehension uses more than 2 levels, it should not be shorter than the alternative, i.e. the normal loops.

The rule of thumb is to avoid using more than 2 expressions in a list comprehension. This could be two conditions, two loops, or one condition and one loop. As soon as it gets more complicated than that, you should use normal `if` and `for` statements and write a helper function.

## Item 9: Consider Generator Expressions for Large Comprehensions

The problem with list comprehensions is that they may create a whole new list containing one item for each value in the input sequence. This is fine for small inputs, but for large inputs this could consume significant amounts of memory and cause your program to crash.

For example, say you want to read a file and return the number of characters on each line. Doing this with a list comprehension would require holding the length of every line of the file in memory. **If the file is absolutely enormous or perhaps a never-ending network socket, list comprehensions are problematic.** Here, I use a list comprehension in a way that can only handle small input values.

```python
value = [len(x) for x in open('/tmp/my_file.txt')]
print(value)
```

To solve this, Python provides *generator expressions*, a generalization of list comprehension and generators. Generator expressions evaluate to an iterator that yields one item at a time from the exp.

A generator expression is created by putting list-comprehension-like syntax between () characters.

```python
it = (len(x) for x in open('/tmp/my_file.txt'))
print(it)
-> <generator object ...>

print(next(it))
print(next(it))
```

Generators can also be composed together:

```python
roots = ((x, x**0.5) for x in it)
```

Chaining generators like this executes very quickly in Python. **When you’re looking for a way to compose functionality that’s operating on a large stream of input, generator expressions are the best tool for the job.** The only gotcha is that the iterators returned by generator expressions are stateful, so you must be careful not to use them more than once.

## Item 10: Prefer enumerate Over range

The `range` func is useful for loops that iterate over a set of integers.

When you have a data structure to iterate over, like a list of strings, often, you will want to know the index of the current item in the list, we can use `range` func naturally.

But `enumerate` func is better. `enumerate` wraps any iterator with a **lazy generator**. The generator yields pairs of the loop index and the next value from the iterator.

```python
flavor_list = ['vanilla', 'chocolate', 'pecan', 'strawberry']

for i, flavor in enumerate(flavor_list):
     print('{0}: {1}'.format(i+1, flavor))

1: vanilla
2: chocolate
3: pecan
4: strawberry
```

## Item 11: Use zip to Process Iterators in Parallel

To iterate over two or more lists parallelly, use `zip` function.

```python
names = ['Celilia', 'Lise', 'Marie']
letters = [len(n) for n in names]

max_letters = 0
longest_name = ''

for name, count in zip(names, letters):
    if count > max_letters:
        longest_name = name
        max_letters = count
        
In [90]: longest_name
Out[90]: 'Celilia'

In [91]: max_letters
Out[91]: 7
```

There are two problems with the `zip` built-in.

The first issue is that in Python 2, `zip` is not a generator, this could potentially use a lot of memory and cause your program to crash. **If you want to `zip` very large iterators in Python 2, use `izip` instead**.

The second issue is that **`zip` behaves strangely if the input iterators are of different lengths**. If the lengths are different, consider the `zip_longest` function.

## Item 12: Avoid else Blocks After for and while loops

That's it:)

The `else` block after a loop only runs if the loop body did not encounter a `break` statement.

**Avoid using `else` blocks after loops because their behavior isn't intuitive and can be confusing.**

## Item 13: Take Advantage of Each Block in try/except/else/finally

There are four distinct times that you may want to take action during exception handling in Python.

### Finally Blocks

Use `try/finally` when you want exceptions to propagate up, but you also want to **run cleanup code even when exceptions occur**.

### Else Blocks

Use `try/except/else` to make it clear which exceptions will be handled by your code and which exceptions will propagate up.

The `else` clause ensures that what follows the `try/except` is visually distinguished from the except block. This makes the exception propagation behavior clear.

### Everything Together

**TODO**

