# Effctive C# 2nd Edition

# Ch01 C# Language Idioms

## Item 2: Prefer readonly to const

## Item 8: Prefer Query Syntax to Loops

## Item 10: Use Optional Parameters to Minimize Method Overloads

## Item 11: Understand the Attraction of Small Functions

# Ch02 .NET Resource Management

## Item 12: Prefer Member Initializers to Assignment Statements

Classes often have more than one constructor. **Over time, it’s easy for the member variables and the constructors to get out of sync.** The best way to make sure this doesn’t happen is to **initialize variables where you declare them instead of in the body of every constructor**. You should utilize the ini- tializer syntax for both static and instance variables.

**The compiler generates code at the beginning of each constructor to execute all the initializers you have defined for your instance member variables.** 

Member initializers are the simplest way to ensure that the member variables in your type are initialized regardless of which constructor is called. **The initializers are executed before each constructor you make for your type.** Using this syntax means that you cannot forget to add the proper initialization when you add new constructors for a future release. **Use initializers when all constructors create the member variable the same way**; it’s simpler to read and easier to maintain.

## Item 13: Use Proper Initialization for Static Class Members

You know that you should initialize static member variables in a type before you create any instances of that type.

C# lets you use static initializers and a static constructor for this purpose. **A static constructor is a special function that executes before any other methods, variables, or properties defined in that class are accessed for the first time.** You use this function to **initialize static variables**, **enforce the singleton pattern**, or **perform any other necessary work before a class is usable**.

As with instance initializers, the static initializers are called before any static constructors are called. And **your static initializers execute before the base class’s static constructor**.

The CLR calls your static constructor automatically **before your type is first accessed in an application space** (an AppDomain). Because **static constructors are called by the CLR, you must be careful about exceptions generated in them**.

Exceptions are the most common reason to use the static constructor instead of static initializers. If you use static initializers, you cannot catch the exceptions yourself.


## Item 16: Avoid Creating Unnecessary Objects

All reference types, even local variables, are allocated on the heap. Every local variable of a reference type becomes garbage as soon as that function exits. One very common bad practice is to allocate GDI objects in a Windows paint handler. 

The Garbage Collector does an efficient job of managing the memory that your application uses. But remember that creating and destroying heap objects still takes time. Avoid creating excessive objects; don’t create what you don’t need. Also avoid creating multiple objects of reference types in local functions. Instead, consider promoting local variables to member variables, or create static objects of the most common instances of your types. Finally, consider creating mutable builder classes for immutable types.

## Item 17: Implement the Standard Dispose Pattern

It's time to cover how to write your own resource management code when you create types that contain **resources other than memory**. A standard pattern is used throughout the .NET Framework for disposing of unmanaged resources.

The root base class in the class hierarchy should **implement the IDisposable interface** to free resources. This type should also add a **finalizer as a defensive mechanism**. Both of these routines delegate the work of freeing resources to a virtual method that derived classes can override for their own resource-management needs.

To begin, your class must have a finalizer if it uses unmanaged resources. You should not rely on clients to always call the `Dispose()` (which is why we need a defensive mechanism).

When the Garbage Collector runs, it **immediately removes from memory any garbage objects that do not have finalizers**. All objects that have finalizers remain in memory. These objects are **added to a finalization queue**, and the Garbage Collector spawns a new thread to run the finalizers on those objects. After the finalizer thread has finished its work, the garbage objects can be removed from memory. **Objects that need finalization stay in memory for far longer than objects without a finalizer.** But you have no choice.

Implementing IDisposable is the standard way to inform users and the runtime system that your objects hold resources that must be released in a timely manner.

The implementation of your `IDisposable.Dispose()` method is responsible for 4 tasks:
* Freeing all unmanaged resources;
* Freeing all managed resources (including unhooking events);
* Setting a state flag to indicate that the object has been disposed;
* Suppressing finalization. Call `GC.SuppressFinalize(this)`;

You accomplish two things by implementing IDisposable: You **provide the mechanism for clients to release all managed resources** that you hold in a timely fashion, and you **give clients a standard way to release all unmanaged resources**.

But there are still holes in the mechanism you’ve created. **How does a derived class clean up its resources and still let a base class clean up as well?** If derived classes override finalize or add their own implementation of IDisposable, those methods must call the base class; otherwise, the base class doesn’t clean up properly.

```csharp
public class MyResourceHog : IDisposable
{
    // Flag for already disposed
    private bool alreadyDisposed = false;
    
    // Implementation of IDisposable.
    // Call the virtual Dispose method.
    // Suppress Finalization.
    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    // Virtual Dispose method
	protected virtual void Dispose(bool isDisposing)
	{
	    // Don't dispose more than once.
	    if (alreadyDisposed)
	        return;
	    if (isDisposing)
	    {
	        // elided: free managed resources here.
		 }
	    // elided: free unmanaged resources here.
	    // Set disposed flag:
	    alreadyDisposed = true;
	}

	public void ExampleMethod()
	{
	if (alreadyDisposed)
	    throw new ObjectDisposedException(
	        "MyResourceHog",
	        "Called Example Method on Disposed object");
	// remainder elided.
	}
}
```

In a managed environment, you do not need to write a finalizer for every type you create; you do it only for types that store unmanaged types or when your type contains members that implement IDisposable. Even if you need only the Disposable interface, not a finalizer, implement the entire pattern. Otherwise, you limit your derived classes by complicating their implementation of the standard Dispose idiom. Follow the standard Dispose idiom I’ve described. That will make life easier for you, for the users of your class, and for those who create derived classes from your types.

## Item 18: Distinguish Between Value Types and Reference Types

It's a simple matter of choosing the `struct` or `class` keyword when you create the type, but it's much more work to update all the clients using your type if you change it later.

**Value types are not polymorphic**. They are better suited to storing the data that your app manipulates.

**Reference types can be polymorphic and should be used to define the behavior** of your app.

Value types should be small, lightweight types. Reference types form your class hierarchy.

Consider this class:

```csharp
public class C
{
    private MyType a = new MyType();
    private MyType b = new MyType();
    // Remaining implementation removed.
}
C cThing = new C();
```

How many objects are created? How big are they? It depends. **If MyType is a value type, you’ve made one allocation.** The size of that allocation is **twice the size of MyType** (inline stored). **If MyType is a reference type, you’ve made three allocations**: one for the C object, which is 8 bytes (assuming 32-bit pointers), and two more for each of the MyType objects that are contained in a C object. **The difference results because value types are stored inline in an object, whereas reference types are not.** Each variable of a reference type holds a reference, and the storage requires extra allocation.

The decision to make a value type or a reference type is an important one. It is a far-reaching change to return a value type into a class type.

The documentation for .NET recommends that you consider the size of a type as a determining factor between value types and reference types. **In reality, a much better factor is the use of the type.** Types that are simple structures or data carriers are excellent candidates for value types. It’s true that value types are more efficient in terms of memory management: There is less heap fragmentation, less garbage, and less indirection.

More important, value types are copied when they are returned from methods or properties (or passed by arguments?). There is no danger of exposing references to internal structures. 

Value types have very limited support for common object-oriented techniques. You can create value types that implement interfaces but require boxing, which Item 17 shows causes performance degradation. **Think of value types as storage containers, not objects in the OO sense**.

If you answer yes to all these questions, you should create a value type.

1. Is this type’s principal responsibility data storage?
2. Is its public interface defined entirely by properties that access its data
members?
3. Am I confident that this type will never have subclasses?
4. Am I confident that this type will never be treated polymorphically?

Build low-level data storage types as value types. Build the behavior of your application using reference types. You get the safety of copying data that gets exported from your class objects. You get the memory usage benefits that come with stack-based and inline value storage, and you can utilize standard object-oriented techniques to create the logic of your application. **When in doubt about the expected use, use a reference type**.

## Item 20: Perfer Immutable Atomic Value Types

# Ch 03 Expressing Designs in C#

## Item 23: Understand How Interface Methods Differ from Virtual Methods

At first glance, implementing an interface seems to be the same as overriding a virtual function. Interface methods are not virtual. When you implement an interface, you are declaring a concrete implementation of a particular contract in that type.

We can implement interfaces in such a manner that derived classes can modify your implementation. You just have to create hooks for derived classes.

We can implement an interface without actually implementing the methods in that interface. By declaring abstract versions of the methods in the interface, you declare that all types derived from your type must implement that interface.

Interface methods are not virtual methods but a separate contract.

# Ch 05 Dynamic Programming in C#

## Item 42: Understand How to Make Use of the Expression API

.NET has had APIs that enable you to reflect on types or to create code at runtime. The ability to examine code or create code at runtime is very powerful. The problem with these APIs is that they are very low level and quite difficult to work with.

Now that C# has added LINQ and dynamic support, you have a better way than the classic Reflection APIs: expressions and expression trees. Expressions look like code. And, in many uses, expressions do compile down to delegates.

With expression, you have an object that represents the code you want to execute. You can examine that expression, much like you can examine a class using the reflection APIs. In the other direction, **you can build an expression to create code at runtime**. Once you create the exp tree, **you can compile and execute the exp**.



# Ch 06 Miscellaneous

## Item 45: Minimize Boxing and Unboxing

Value types are containers for data. **They are not polymorphic types**. On the other hand, the .NET Framework was designed with a single reference type, System.Object, at the root of the entire object hierarchy. The .NET Framework uses boxing and unboxing to bridge the gap between these two goals.

Boxing places a value type in an untyped reference object to **allow the value type to be used where a reference type is expected**. **Unboxing extracts a copy of that value type from the box**.

Boxing and unboxing are necessary for you to use value types where the System.Object type is expected. But **boxing and unboxing are always performance-robbing operations**. Sometimes, when **boxing and unboxing also create temporary copies of objects**, it can lead to subtle bugs in your programs.

**Avoid boxing and unboxing when possible.**

### Understanding Boxing and Unboxing

Boxing converts a value type to a reference type. A new reference object, the box, is allocated on the heap, and a copy of the value type is stored inside that reference object.

When you need to retrieve anything from the box, a copy of the value type gets created and returned. That’s the key concept of boxing and unboxing: **A copy of the value goes in the box, and another gets created whenever you access what’s in the box.**

Boxing and unboxing happens automatically. The compiler generates the boxing and unboxing instructions whenever you use a value type where a reference type, such as System.Object, is expected. In addition, the boxing and unboxing operations occur when you use a value type through an interface pointer.

### Use Generics in .NET 2.0

You can avoid boxing and unboxing simply by using generic classes and generic methods. That is certainly the most powerful way to create code that uses value types without unnecessary boxing operations.

### Rules to avoid boxing

* Watch for implicit conversions to `System.Object`
* Use the generic collections added in the .NET 2.0

### A sutble bug

```c#
public struct Person
{
   public string Name { get; set; }
   public override string ToString()
   {
       return Name;
   }
}

// Using the Person in a collection:
var attendees = new List<Person>();
Person p = new Person { Name = "Old Name" };
attendees.Add(p);

// Try to change the name:
// Would work if Person was a reference type.
Person p2 = attendees[0];
p2.Name = "New Name";

// Writes "Old Name":
Console.WriteLine(attendees[0].ToString( ));
```

Person is a value type. **The JIT compiler creates a specific closed generic type for List<Person> so that Person objects are not boxed**, because they are stored in the attendees collection. **Another copy gets made when you retrieve the Person object** to access the Name property to change. All you did was change the copy. In fact, **a third copy was made to call the ToString() function through the attendees[0] object**. For this and many other reasons, you should create immutable value types (see Item 20).

