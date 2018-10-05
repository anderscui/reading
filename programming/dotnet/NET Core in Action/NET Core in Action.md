# Ch01 - Intro


# Ch02 - Building your first dotnet app

## Installing SDK

### on macOS

下载安装包：https://www.microsoft.com/net/learn/get-started-with-dotnet-tutorial

### Docker

`docker run -it microsoft/dotnet:latest`

## Create a console app

```bash
dotnet new console -o myapp
cd myapp
dotnet run
```

## Create a web app

```bash
# in a dir
mkdir webapp
cd webapp
dotnet new web
dotnet run
```

# Ch03 - Build with .NET Core

## Key concepts in .NET Core

project files: *.csproj; *.fsproj; *.vbproj.

### Terminology

* framework
* platform
* runtime

a dependency could be:

* package: normal nuget package
* metapackage: e.g. .NET Standard Library
* another project

**framework**, or **target framework**, is a NuGet concept. e.g. net45 or netcoreapp1.0.

when working with the project file or the .NET CLI, you use TFMs (target framework moniker).

使用**netstandard** moniker指定需兼容的最低版本。

**runtime** spec指定了OS和CPU架构，如osx.10.11。

## CSV parser

### create new

`dotnet new console -o CsvParser`

## Introducing MSBuild

* PropertyGroups: kv pairs，定义property值。
* Target
* ItemGroup：加载或移除文件

```xml
  <Target Name="TestMessage" AfterTargets="Build">
    <Message Text="$(Property1)" Importance="high" />
    <Message Text="$(Property2)" Importance="high" />
  </Target>
```

如果去掉AfterTargets，可以通过`dotnet build -t:TestMessage`调用。

---

```xml
  <ItemGroup>
    <Compile Remove="Program.cs" />
  </ItemGroup>
```

ItemGroup默认会加载当前目录下的各个cs文件到build过程。可有更多选项如：

```xml
  <ItemGroup>
    <None Include="Marvel.csv">
      <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
    </None>
  </ItemGroup>
```

除了copy到output目录，也可以embed文件到assembly。这些操作，跟在VS中开发.NET Framework app类似。

## Dependencies

.NET Core支持三种依赖：

* target framework
* package
* project

## Targeting multiple frameworks

conditional build.

# Ch04 - Unit testing with xUnit

## Business-day calc example

# Ch11 - Multiple frameworks and runtimes

本章介绍.NET Core的两个特性：.NET Core app 可以运行于多个不同的OS；可以编写特定于某个.NET 平台的代码。

## Why to support multiple frameworks and runtimes？

framework是指一个API集；runtime则表示OS。如果app需要特定于OS的代码，那么它需要支持不同的runtime。一个例子是`System.IO.Compression` library，该类库依赖于原生库zlib，zlib使用native code实现，因此在不同OS上表现会有所不同。

.NET SL (Standard Library) 可以支持广泛的平台，但不能穷尽所有情况。.NET Core可以帮助在同一个项目中集成不同runtime的代码，并简化打包和发布过程。

## .NET Portability Analyzer

该Analyzer可帮助在不同framework之间的迁移，比如在.NET Framework、.NET Core和Xamarin之间。这个工具的report会显示对于目标framework，哪些代码是不兼容的，有些还会给出修改的建议。

运气好的话，不兼容部分可以直接使用新API替换；否则的话，可使用Preprocessor Directive，对不同runtime指定不同的代码。

如果项目配置中指定TargetFrameworks为多个，那么使用`dotnet pack`打包时，package会同时包含所有版本的程序集。在项目配置文件中，还可以指定在某个特定版本时，添加或移除某些文件，这样可以仅编译该版本所需的文件。

## Rumtime-specific code

进一步地，可通过`RumtimeIdentifiers`指定app所支持的OS。

# 结论

使用Rider、.NET Core和C#，编写console、web应用，和Python、Java等有什么区别吗？性能应比py略高，语法比java更简洁，但就我个人体验，差别不大，开发效率上py更高，语法的简洁则可以采用scala作为better java。然后就日常所写的代码，ML、NLP方面的库py和java的优势不可以道里计。

事实上，想不到有哪一部分是必须要用dotnet的，或者至少dotnet有明显的优势。之前想到的点是EF这个库好用，但相比的也是js，而不是py和java。所以，最后，能用的地方只有jieba.NET的维护和改进了。一方面是维护它的issue，另一方面，尝试引入更多功能，作为练习之用。兼容.NET Core，可以有更多的受众，仅此而已了。

Windows可以说已经完全不用，游戏开发也不接触，就安心做分词和搜索相关吧。jieba似乎已经停止了维护，但还有不少功能可以添加，ML.NET也在慢慢做起来，因此这里作为一个playground还不错吧。

然后，F#的学习也是类似，找不到太合适的应用场景。

