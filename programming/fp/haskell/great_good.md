# Learn You a Haskell for Great Good

## Tools

* GHC
* GHCi (:t; )
* Stack
* Hoogle

## Glossary

* type
* type class
* type constructor
* value constructor

# Ch02 Believe the Type

`:t "hello"` -> `"hello" :: [Char]`

`::`表示“has type of”，显式的类型总是以大写字母开始。

## 常用类型

* Int：bounded
* Integer：not bounded，但没有Int高效
* Float
* Double
* Bool
* Char: unicode char
* Tuple: including `()`
 
## 类型变量

类似于其它语言中的**泛型**。

```bash
:t head
head :: [a] -> a

:t fst
fst :: (a, b) -> a
```

`a`表示它可以是任一类型，因此head可用于任何类型的列表。使用类型变量的函数成为多态函数（polymorphic functions）。上面的`fst`表明可使用多个类型变量。

## 类型类（Type Class）

`type class`类似于其它语言中的`interface`，它的实例是类型。比如可用于`==`的类型须实现`Eq`：

```bash
:t (==)
(==) :: Eq a => a -> a -> Bool
```

由此签名可知，`==`的两个参数同类型，且该类型须实现`Eq`，`=>`前面的部分称为类约束（class constraint）。

### 常用的type class

* Eq：`==`, `/=`
* Ord：`>`, `<`, `>=`, `<=`，compare函数使用之
* Show：表示类型可表示为字符串，show函数使用之
* Read：将字符串转换为某个类型，如read函数：`read :: Read a => String -> a`，如果没有任何指示，单纯调用read会报错，因为类型未定，此时需要使用**类型标注**（type annotation），如`read "5" :: Float`。
* Enum：可按某种顺序枚举的类型，如Int、Float、Ordering
* Bounded：实现此类的类型是有界的，可用于`minBound`和`maxBound`函数。
* Num：数值类型，Int、Integer、Float、Double
* Floating
* Integral：如fromIntegral函数，`romIntegral (length [1, 2]) + 1.1`

# Ch03 Syntax in Functions

模式识别，一方面用于指定数据的结构（如if else），另一方面则是对数据**解构**（deconstruct）。在Haskell中，函数的定义可以拆分为几个部分，每一部分处理一种模式。

```haskell
factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n-1)
```

## Tuples

```haskell
addVectors :: (Double, Double) -> (Double, Double)  -> (Double, Double)
addVectors a b = (fst a + fst b, snd a + snd b) 

-- 更简单的是：
addVectors :: (Double, Double) -> (Double, Double)  -> (Double, Double)
addVectors (x1, y1) (x2, y2) = (x1+x2, y1+y2)
```

可以看到，模式匹配的**解构**功能使得代码简洁很多。

## List and List Comprehension

```haskell
-- list comp
pairs = [(1, 3), (4, 3), (2, 4), (5, 3), (5, 6), (3,1 )]
sums = [a+b | (a, b) <- pairs]

-- list
head' :: [a] -> a
head' [] = error "empty list!"
head' (x: _) = x
```

如果模式匹配需要绑定多个值，如上面的`head'`那样，那么需要用括号括起来。

## As-patterns

as模式可以在使用模式匹配时，仍然能够访问到被匹配的原始值，使用`@`，例：

```haskell
firstLetter :: String -> String
firstLetter "" = "Empty string..."
firstLetter all@(c:cs) = "The first letter of " ++ all ++ " is " ++ [c]
```

## Guards

```haskell
bmiTell :: Double -> String
bmiTell bmi
    | bmi <= 18.5 = "You're underweight"
    | bmi <= 25.0 = "normal"
    | bmi <= 30.0 = "fat"
    | otherwise = "You're a whale"
```

## where ?

```haskell
bmiTell :: Double -> Double -> String
bmiTell weight height
    | bmi <= skinny = "You're underweight"
    | bmi <= normal = "normal"
    | bmi <= fat = "fat"
    | otherwise = "You're a whale"
    where bmi = weight / height ^ 2
          skinny = 18.5
          normal = 25.0
          fat = 30.0
```

where的作用域，仅在函数的`当前函数体`内。where语句块中，还可以定义函数：

```haskell
calcBmis :: [(Double, Double)] -> [Double]
calcBmis xs = [bmi w h | (w, h) <- xs]
    where bmi weight height = weight / height ^ 2
```

## let

where在函数尾部定义值，而let则在开头，但其作用域不能跨域guard，形式为`let <bindings> in <expression>`：

```haskell
cylinder :: Double -> Double -> Double
cylinder r h = 
    let sideArea = 2 * pi * r * h
        topArea = pi * r ^ 2
    in sideArea + 2 * topArea
```

除了与where位置的不同，另一个不同之处是let本身是一个表达式，因此可以用作一个**值**，而where不可以。let也可用于列表推导中：

```haskell
fats :: [(Double, Double)] -> [Double]
fats xs = [bmi | (w, h) <- xs, let bmi = w / h ^ 2, bmi > 25.0]
```

let表达式的作用域是它的定义之后的部分，以及output（即|之前的部分）。`(w, h) <- xs`部分不能引用let，因为它定义于let之前。

## case Expression

上述函数定义中的模式匹配实际上是`case`表达式的语法糖，`head'`等价于：

```haskell
head'2 :: [a] -> a
head'2 xs = case xs of [] -> error "empty list!"
                       (x: _) -> x
```

函数定义可以出现在where中，因此可以这样定义函数：

```haskell
describeList :: [a] -> String
describeList ls = "The list is " ++ what ls
    where what [] = "empty"
          what [x] = "a singleton list"
          what xs = "a longer list"
```

可以理解为`describeList`的模式匹配被放在了`where`中。

# Ch04 Hello Recursion

递归，基本思路是将一个问题转化为一个更小（或更容易）的问题，迭代此过程，最终问题转化为一个可直接求解的问题（base case）。

递归刚开始使用会觉得有点不习惯，但是如果你**相信**它是可以work的，那么它会更容易work。

```haskell
maximum' :: (Ord a) => [a] -> a
maximum' [] = error "empty list"
maximum' [x] = x
maximum' (x: xs) = max x (maximum' xs)
```

## 更多练习

```haskell
-- replicate
replicate' :: Int -> a -> [a]
replicate' n x
    | n <= 0 = []
    | otherwise = x : replicate' (n-1) x

take' :: Int -> [a] -> [a]
take' n _
    | n <= 0 = []
take' _ [] = []
take' n (x: xs) = x : take' (n-1) xs

-- reverse

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x: xs) = reverse' xs ++ [x]

-- repeat - infinite seq
repeat' :: a -> [a]
repeat' x = x : repeat' x

-- zip
zip' :: [a] -> [b] -> [(a, b)]
zip' [] _ = []
zip' _ [] = []
zip' (x: xs) (y: ys) = (x, y) : zip' xs ys

-- elem: type class
elem' :: (Eq a) => a -> [a] -> Bool
elem' x [] = False
elem' x (y: ys) = x == y || elem' x ys
```

## quicksort

```haskell
-- quicksort, the second pattern could be omitted.
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort [x] = [x]
quicksort (x: xs) = 
    let smaller = [a | a <- xs, a < x]
        largerOrEqual = [a | a <- xs, a >= x]
    in (quicksort smaller) ++ [x] ++ (quicksort largerOrEqual)
```

# Ch05 Higher-Order Functions

高阶函数在FP中属于基本元素，在Python这样的语言中也是。

## Curried Functions

Haskell中的函数实际上都只能接受一个参数，之前看到的“多个”参数，通过柯里化函数实现。

以`max`为例，它的签名是`max :: Ord a => a -> a -> a`，也可以写作`max :: Ord a => a -> (a -> a)`，即第一个参数输入时返回值是一个函数。事实上也确实如此：

```haskell
:t max 1
max 1 :: (Ord a, Num a) => a -> a
```

`max 1`的值就是一个函数。当一个函数的参数个数“太少”时，称为部分调用（partially applied）。

## Sections

中缀（infix）函数可使用称为`section`的方式来部分调用，即只传给函数某一个参数，可左可右，然后”虚位以待“另一个参数。

```haskell
(/10) 20
--> 2.0
(10/) 5
--> 2.0

isUpper = (`elem` ['A'..'Z'])
:t isUpper
--> isUpper :: Char -> Bool
```

## Some Higher-Orderism Is in Order

```haskell
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

i1 = applyTwice (+ 3) 10
s1 = applyTwice (++ " fun") "haskell is"

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x: xs) (y: ys) = f x y : zipWith' f xs ys

l1 = zipWith' (+) [1, 2, 3] [4, 5, 6]
```

## The Functional Programmer's Toolbox

### map and others

```haskell
-- map
l2 = map (*2) [1..5]
l2_2 = [x*2 | x <- [1..5]]

-- filter
l3 = filter (>3) [1, 5, 2, 3, 6]
l3_2 = [x | x <- [1, 5, 2, 3, 6], x > 3]

l4 = filter (<15) (filter even [1..20])
l4_2 = [x | x <- [1..20], x < 15, even x]

--
largest :: Integer
largest = head (filter p [100000,99999..])
    where p x = x `mod` 3829 == 0

--
sumOfOddSquares = sum (takeWhile (<10000) (filter odd (map (^2) [1..])))

-- Collatz seq
collatz :: Int -> [Int]
collatz x
    | x < 1 = error "invalid input"
    | x == 1 = [1]
    | even x = x : collatz (x `div` 2)
    | otherwise = x : collatz (x*3 + 1)

-- partial map
listOfFuns = map (*) [0..]
i2 = (listOfFuns !! 4) 5
```

## Lambdas

```haskell
flip2 :: (a -> b -> c) -> b -> a -> c
flip2 f = \x y -> f y x
```

## I Fold You So

```haskell
-- foldl

sum' :: (Num a) => [a] -> a
-- sum' xs = foldl (+) 0 xs
sum' = foldl (+) 0

map' :: (a -> b) -> [a] -> [b]
map' f xs = foldr (\x acc -> f x : acc) [] xs
l5 = map' (*3) [1..5]

-- foldr with infinite list
and' :: [Bool] -> Bool
and' xs = foldr (&&) True xs
```

## Function Application with $

`$`称为函数调用操作符（function application operator）。由于其优先级极低，因此可以看作是函数之间的“括号”，提高可读性。

```haskell
sum (filter (> 10) (map (*2) [2..10]))
sum $ filter (> 10) $ map (*2) [2..10]
```

```haskell
map ($ 3) [(4+), (10*), (^2), sqrt]
```

## Function Composition

```haskell
map (negate . sum . tail) [[1..5], [3..6], [1..7]]

-- for multiple params
sum . replicate 5 $ max 6.7 8.9
```

### Point-Free Style

```haskell
fn = ceiling . negate . tan . cos . max 10
```

定义函数，省略其参数，只关注函数的行为，而非“数据”如何流转。

# Ch06 Modules

module本质上是一个包含函数、类型、类型类定义的文件，而Haskell中的程序一组module构成的集合。

模块可以仅export部分成员。Haskell标准库定义了若干函数与类型，目前用到的各种函数、类型和类型类都定义在`Prelude`模块中，该模块默认是会被import的。

## import

import语句有各种形式，比如：

```haskell
-- import Data.List
-- import Data.List (nub, sort)
-- import Data.List hiding (sort)
import qualified Data.Map as M
```

## Solving Problems

### Counting Words

```haskell
wordNums :: String -> [(String, Int)]
wordNums = map (\ws -> (head ws, length ws)) . group . sort . words
nums = wordNums "a friend in need is a friend indeed"

-- [("a",2),("friend",2),("in",1),("indeed",1),("is",1),("need",1)]
```

### Needle in the Haystack

```haskell
isIn :: (Eq a) => [a] -> [a] -> Bool
needle `isIn` haystack = any (needle `isPrefixOf`) (tails haystack)

b1 = "art" `isIn` "party"
b2 = [1, 2] `isIn` [1, 3, 5]
```

## Making Our Own Modules

```haskell
-- Geometry.hs

module Geometry
( sphereVolume
, sphereArea
, cubeVolume
, cubeArea
, cuboidVolume
, cuboidArea
) where

sphereVolume :: Float -> Float
sphereVolume radius = (4.0 / 3.0) * pi * (radius ^ 3)

sphereArea :: Float -> Float
sphereArea radius = 4 * pi * (radius ^ 2)

cubeVolume :: Float -> Float
cubeVolume side = cuboidVolume side side side

cubeArea :: Float -> Float
cubeArea side = cuboidArea side side side

cuboidVolume :: Float -> Float -> Float -> Float
cuboidVolume a b c = (rectArea a b) * c

cuboidArea :: Float -> Float -> Float -> Float
cuboidArea a b c = (rectArea a b) * 2 + (rectArea a c) * 2 + (rectArea b c) * 2

rectArea :: Float -> Float -> Float
rectArea a b = a * b
```

# Ch07 Making Our Own Types and Type Classes

## Shaping Up

```haskell
-- Circle and Rectangle are funcs
data Shape = Circle Float Float Float | Rectangle Float Float Float Float
    deriving (Show)

area :: Shape -> Float
area (Circle _ _ r) = pi * r ^ 2
area (Rectangle x1 y1 x2 y2) = (abs $ x2 - x1) * (abs $ y2 - y1)

concentricCircles = map (Circle 100 100) [1..3]
```

可以看到，Circle和Rectangle也是函数，类似于“构造函数”，还可用于模式匹配。这个有点像Scala中的case class。上例中多处用到坐标，故引入`Point`表示之：

```haskell
-- v2
data Point = Point Float Float deriving (Show)
data Shape = Circle Point Float | Rectangle Point Point deriving (Show)

area :: Shape -> Float
area (Circle _ r) = pi * r ^ 2
area (Rectangle (Point x1 y1) (Point x2 y2)) = (abs $ x2 - x1) * (abs $ y2 - y1)

concentricCircles = map (Circle (Point 100 100)) [1..3]

nudge :: Shape -> Float -> Float -> Shape
nudge (Circle (Point x y) r) a b = Circle (Point (x+a) (y+b)) r
nudge (Rectangle (Point x1 y1) (Point x2 y2)) a b = 
    Rectangle (Point (x1+a) (y1+b)) (Point (x2+a) (y2+b))

c1 = Circle (Point 3 4) 5
c2 = nudge c1 2 3

baseCircle :: Float -> Shape
baseCircle r = Circle (Point 0 0) r

baseRect :: Float -> Float -> Shape
baseRect width height = Rectangle (Point 0 0) (Point width height)

s1 = nudge (baseRect 40 100) 60 23
```

## Record

```haskell
data Car = Car { company :: String
               , model :: String
               , year :: Int
               } deriving (Show)

c1 = Car "Ford" "Mustang" 1967
c2 = Car { model="Mustang", company="Ford", year=1967 }
```

Car还是构造函数，但初始化时，可按field指定值，并且record语法同时也生成了若干方法，如`company`、`model`。

## Type Parameters

```haskell
-- type parameters

data Option a = None | Some a
o1 = None
o2 = Some 'a'
```

这里的`a`是类型参数，`Option`是类型构造函数，模拟了Scala中Option。

```haskell
-- vector

data Vector a = Vector a a a deriving (Show)

vplus :: (Num a) => Vector a -> Vector a -> Vector a
(Vector i j k) `vplus` (Vector l m n) = Vector (i+l) (j+m) (k+n)

dot ::  (Num a) => Vector a -> Vector a -> a
(Vector i j k) `dot` (Vector l m n) = i*l + j*m + k*n

v1 = Vector 3 5 8 `vplus` Vector 9 2 8
v2 = Vector 3 5 8 `dot` Vector 9 2 8
```

## Derived Instances

这里的实例是指“类型”是“类型类”的实例，如`Int`之于`Eq`。

很多时候，Haskell可自动为类型提供某些“接口”的实现，如`Eq`、`Ord`等。

### Equating

```haskell
data Car = Car { company :: String
               , model :: String
               , year :: Int
               } deriving (Show, Read, Eq)
        
c1 = Car "Ford" "Mustang" 1967
c2 = Car { model="Mustang", company="Ford", year=1967 }
       
c2 == (Car "Ford" "Mustang" 1967)
-- True

carStr = "Car {company = \"Ford\", model = \"Mustang\", year = 1967}"
c3 = read carStr :: Car
c2 == c3
-- True
```

一旦“继承”了`Eq`，Haskell在比较时，会比较各字段是否相等，这有赖于各字段的类型也实现了`Eq`，而`Int`、`String`确实如此。

类似的是`Show`和`Read`类型类。

### Ordering

如果类型包含了不同的构造函数，那么先到者值较小。

```haskell
data Bool = FalseVal | TrueVal deriving (Eq, Ord)

b1 = TrueVal `compare` FalseVal
b2 = TrueVal > FalseVal
```

### Enums

```haskell
-- enums

data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday 
    deriving (Eq, Ord, Show, Read, Bounded, Enum)

d1 = Wednesday
d2 = read "Wednesday" :: Day
b3 = d1 == d2
minDay = minBound :: Day
maxDay = maxBound :: Day

d4 = succ Monday
d5 = pred Wednesday
b4 = d4 == d5
```

## Type Synonyms

`[Char]`与`String`是可互换的，这一点可通过类型别名实现（类型同义词，type synonym）：`type String = [Char]`。

### Either, Left, Right

```haskell
import qualified Data.Map as Map

data LockerState = Taken | Free deriving (Show, Eq)

type Code = String

type LockerMap = Map.Map Int (LockerState, Code)

data Either' a b = Left' a | Right' b deriving (Eq, Ord, Read, Show)

lockerLookup :: Int -> LockerMap -> Either' String Code
lockerLookup number map = 
    case Map.lookup number map of
        Nothing -> Left' $ "Locker " ++ show number ++ " doesn't exist"
        Just (state, code) -> if state /= Taken
                              then Right' code
                              else Left' $ "Locker " ++ show number ++ " is taken"

lockers :: LockerMap
lockers = Map.fromList
    [(100, (Taken, "ZD39I")),
     (101, (Free, "JAH3I"))]

r1 = lockerLookup 101 lockers
r2 = lockerLookup 100 lockers
```

## Recursive Data Structures

List和Tree是常见的递归数据结构，在此方式下，类型的定义也引用了自身。

### List

```haskell
-- Empty is like '[]', Cons is just like ':'
data List a = Empty | Cons a (List a) deriving (Show, Read, Eq, Ord)

l1 = 1 `Cons` (2 `Cons` (3 `Cons` Empty))
```

内置的cons函数是`:`，我们也可以定义自己的操作符。使用特殊字符命名函数，可使得它自动成为“中缀函数”。

```haskell
-- associative and precedence 
infixr 5 :-:

data List a = Empty | a :-: (List a) deriving (Show, Read, Eq, Ord)

infixr 5 ^++
(^++) :: List a -> List a -> List a
Empty ^++ ys = ys
(x :-: xs) ^++ ys = x :-: (xs ^++ ys)

l2 = 1 :-: 2 :-: 3 :-: Empty
l3 = 4 :-: 5 :-: 6 :-: Empty
l4 = 7 :-: 8 :-: 9 :-: Empty
l5 = l2 ^++ l3 ^++ l4
```

这里可以看到`infixr`的用法，以及“运算符”只是中缀函数。有趣的是，在`^++`的定义中，其模式匹配同样是以中缀形式表达；尤其重要的一点是，`Empty`和`(x :-: xs)`本质上都对应到了某个构造函数，**模式匹配本质上是匹配构造函数的**。Haskell中类型与模式匹配的方式，让我想起来Scala中的`case class`，颇为相似。

### (Binary Search) Tree

```haskell
data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving (Show)

singleton :: a -> Tree a
singleton x = Node x EmptyTree EmptyTree

treeInsert :: (Ord a) => a -> Tree a -> Tree a
treeInsert x EmptyTree = singleton x
treeInsert x (Node val left right)
    | x < val = Node val (treeInsert x left) right
    | x > val = Node val left (treeInsert x right)
    | x == val = Node val left right

treeElem :: (Ord a) => a -> Tree a -> Bool
treeElem x EmptyTree = False
treeElem x (Node val left right)
    | x == val = True
    | x < val = treeElem x left
    | x > val = treeElem x right

nums = [8, 6, 4, 1, 7, 3, 5]
numsTree = foldr treeInsert EmptyTree nums

b1 = 8 `treeElem` numsTree
b2 = 10 `treeElem` numsTree
```

## Algebraic Data Type

[代数数据类型](https://en.wikipedia.org/wiki/Algebraic_data_type)，在FP和类型论中，ADT是指一种组合类型（composite type），其两种常见子类是product type（乘积类型，tuple、record等）和sum type（和类型，tagged union、discriminated union等）。

product和sum之区分，考虑两种情况下，如果各组合子类型的取值都是有限的，那么所有可能取值的数目恰是来自“乘法原理”和“加法原理“。

## Type Classes

手动实现一个type class：

```haskell
-- implement a type class by hand

data TrafficLight = Red | Yellow | Green

instance Eq TrafficLight where
    Red == Red = True
    Green == Green = True
    Yellow == Yellow = True
    _ == _ = False

instance Show TrafficLight where
    show Red = "Red light"
    show Green = "Green light"
    show Yellow = "Yellow light"
```

自定义type class：

```haskell
-- define a type class
class YesNo a where
    yesno :: a -> Bool

instance YesNo Int where
    yesno 0 = False
    yesno _ = True

instance YesNo [a] where
    yesno [] = False
    yesno _ = True

instance YesNo TrafficLight where
    yesno Red = False
    yesno _ = True
```

## The Functor Type Class

`Functor`（函子）是一个看起来很”深奥“的术语，但实际上比较简单。它的签名是：

```haskell
class Functor f where
    fmap :: (a -> b) -> f a -> f b
```

注意这里的`f`，在`YesNo`的例子中，类型变量（`a`）表示具体类型，而`f`则是类型构造函数，接受一个类型参数，返回一个具体类型。因此`f a`和`f b`都表示具体类型。fmap的例子是`List`的`map`：

```haskell
map :: (a -> b) -> [a] -> [b]
```

map是fmap的一个特例，只能用于列表类型。上面所说的`f`对应列表的`[]`，`[]`是**类型构造函数**，当它接受一个具体类型，如Int，就得到具体类型：`[Int]`。

类型构造函数`[]`是一个函子，Maybe、Tree、Either也都是。它们的共同点是：作为一个容器，以一个函数作用于容器内的元素，得到一个同样结构的容器，其中的每个值是由原来元素映射而来。

## Kinds and Some Type-Foo

类型也有种类（kind）。

# Ch08 IO

关于IO的基础。IO不是FP中pure的那一部分，但编程的目标不是purity：）

## Separating the Pure from the Impure

Haskell的函数是纯粹的，一是相等的输入会有相等的结果；二是函数不允许有副作用。但完全的纯粹达不到，因为至少我们需要”看到“程序的结果是什么。Haskell将程序分隔为两部分，纯与不纯，前者仍可获得FP的种种好处，后者则负责脏活累活。

```haskell
-- hello.hs

main :: IO ()
main = putStrLn "Hello, world"
```

```bash
ghc --make hello.hs
./hello
```

`putStrLn`的类型是`String -> IO ()`，可以认为是，返回一个IO action，且其类型为`()`，即`unit`，该类型同于空的tuple。

IO action执行的时间是，当给它一个`main`的名称时。使用`do`，可以组合多个IO actions。

```haskell
main = do
    putStrLn "Hello, what's your name?"
    name <- getLine
    putStrLn ("Hey " ++ name ++ ", you rock!")
```

`<-` 结构从一个IO action中”提取“值。

## Some Useful IO Functions

* putStr
* putChar
* print
* when
* sequence
* mapM, mapM_
* forever
* forM

# Ch09 More IOs

TODO

# Ch10 Functionally Solving Problems

## Reverse Polish Notation Calculator

## Heathrow to London

# Ch11 Applicative Functors

函子可视为其元素可逐一map的容器，也可看作拥有上下文的值。




