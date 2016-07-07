# The Managed Heap and GC

This chapter discusses how managed applications **construct new objects**, how the managed heap controls the **lifetime of these objects**, and how the memory for these objects gets **reclaimed**. In short:

* How the garbage collector in the CLR works
* Various issues related to it
* How to design apps to use memory efficiently

## 1. Managed Heap Basics

**Every program uses resources of one sort or another**, be they files, memory buffers, screen space, network connections, database resources, and so on. In an OO env, **every type identifies some resource** available for a program's use. To use any of these resources requires memory to be allocated to represent the type. The following steps are required to access a resource:

1. **Allocate memory** for the type the represents the resource (C#'s ```new``` operator)
2. **Initialize the memory** to set the initial state of the resource and to make the resource usable. The type's instance **constructor** is responsible for this inital state.
3. Use the resource by accessing the type's members.
4. **Tear down** the state of a resource to clean up.
5. **Free the memory**. The **GC** is solely responsible for this step.

This seemingly simple paradigm has been one of the major sources of problems for programmmers that must manually manage their memory, e.g. native C++ developers. Programmers may forget to free memory, which causes a **memory leak**; or may they use memory after having released it, which causes **memory corruption**.

As long as you are writing verifiably type-safe code (avoiding C#’s unsafe keyword), then it is impossible for your application to experience memory corruption. It is still possible for your application to leak memory but it is not the default behavior. **Memory leaks typically occur because your application is storing objects in a collection and never removes objects when they are no longer needed**.

To simplify things even more, most types that developers use quite regularly do not require Step 4 (tear down the state of the resource to clean up). For most types, there is no need to clean up the resource and the garbage collector will free the memory (Step 5).

However, sometimes, you want to clean up a resource as soon as possible, rather than waiting for a GC to kick in. Typically, types that require special cleanup are those that wrap native resources like files (IO), sockets (Network), or database connections (DB). (These 3 are the most common ones, also note the **IDisposable** interface)

### 1.1 Allocating Resources from the Managed Heap

The CLR requires that **all objects be allocated from the managed heap** (the ValueTypes?). When a process is initialized, the CLR allocates a region of address space for the managed heap. The CLR also maintains a pointer, which I’ll call NextObjPtr. **This pointer indicates where the next object is to be allocated within the heap**. Initially, NextObjPtr is set to the base address of the address space region.

As region fills with non-garbage objects, the CLR allocates more regions and continues to do this until the whole process’s address space is full. So, your application’s memory is **limited by the process’s virtual address space** (TODO: need to understand the process model of OS). 

C#'s ```new``` operator causes the CLR to perform the following steps:

1. Calculate the number of bytes required for the type's fields (and all the fields it inheirts from its base types).
2. Add the bytes required for an object's overhead. Each object has two overhead fields: a type object pointer and a sync block index. For a 32-bit app, each of these requires 32 bits, adding 8 bytes to each object; for a 64-bit app, adding 16 bytes.
3. The CLR then checks that the bytes required to allocate the object are available in the region.  If there is enough free space in the managed heap, the object will fit, starting at the address pointed to by **NextObjPtr**, and these bytes are zeroed out. The type’s constructor is called (*passing NextObjPtr for the this parameter*), and the new operator returns a reference to the object. Just before the reference is returned, NextObjPtr is advanced past the object and now points to the address where the next object will be placed in the heap.

So for the managed heap, allocating an object simply means adding a value to a pointer——this is blazing fast. In many applications, objects allocated around the same time tend to have strong relationships to each other and are frequently accessed around the same time. For example, it’s very common to allocate a `FileStream` object immediately before a `BinaryWriter` object is created. Then the application would use the `BinaryWriter` object, which internally uses the `FileStream` object. Because the managed heap allocates these objects next to each other in memory, you get excellent performance when accessing these ob ects due to locality of reference.

So far, it sounds like the managed heap provides excellent performance characteristics. However, what I have just described is assuming that memory is infinite and that the CLR can always allocate new objects at the end. However, memory is not infinite and so the CLR employs a technique known as garbage collection(GC) to "delete" objects in the heap that your application no longer requires access to.

### 1.2 The GC Algorithm

When an application calls the `new` operator to create an object, there might not be enough address space left in the region to allocate the object.  If insufficient space exists, then **the CLR performs a GC**.

For managing the lifetime of objects, some systems use a **reference counting algorithm**. In fact, Microsoft’s own Component Object Model (COM) uses reference counting. This kind of algorithms are known for their **circular references problem** which causes memory leak.

Due to this problem with reference counting garbage collector algorithms, the CLR uses a **referencing tracking algorithm** instead. The reference tracking algorithm **cares only about reference type variables**, because only these variables can refer to an object on the heap; value type variables contain the value type instance directly.

As a programmer, notice how the two bugs described at the beginning of this chapter no longer exist. First, it’s **not possible to leak objects** because any object not accessible from your application’s roots will be collected at some point. Second, it’s **not possible to corrupt memory** by accessing an object that was freed because references can only refer to living objects, because this is what keeps the objects alive anyway.

**A static field keeps whatever object it refers to forever or until the AppDomain that the types are loaded into is unloaded**. A common way to leak memory is to have a static field refer to a collection object and then to keep adding items to the collection object. The static field keeps the collection object alive and the collection object keeps all its items alive. For this reason, **it is best to avoid static fields whenever possible**.

### 1.3 GC and Debugging
 
As soon as a root goes out of scope, the object it refers to is unreachable and subject to having its memory reclaimed by a GC; **objects aren’t guaranteed to live throughout a method’s lifetime**.

## 2. Generations: Improving Performance

The CLR's GC is a *generational garbage collector* (also known as an *ephemeral garbage collector*). A generational GC makes the following assumptions about you code:

* The newer an object is, the shorter its lifetime will be;
* The older an object is, the longer its lifetime will be;
* Collecting a portion of the heap is faster than collecting the whole heap.

When initialized, the managed heap contains no objects. Objects added to the heap are said to be in generation 0. Stated simply, **objects in generation 0 are newly constructed objects that the garbage collector has never examined**.

When the CLR initializes, it selects a budget size (in kilobytes) for generation 0. So if allocating a new object causes generation 0 to surpass its budget, a garbage collection must start. **After one collection, generation 0 survivors are promoted to generation 1; generation 0 is empty.**

When the CLR initializes, it selects a budget for generation 0, it also selects a budget for generation 1.

For the 2nd collection, the garbage collector will just ignore the objects in generation 1 (if the G1 occupies less than G0), which will speed up the garbage collection process.

PS: Microsoft’s performance tests show that it takes **less than 1 millisecond** to perform a garbage collection of generation 0. Microsoft’s goal is to have garbage collections take no more time than an ordinary page fault.

After two collections, generation 0 survivors are promoted to generation 1 (**growing the size of generation 1**); generation 0 is empty.

After three collections, generation 0 survivors are promoted to generation 1 (**growing the size of generation 1 again**); generation 0 is empty.

After four collections: generation 1 survivors are promoted to generation 2, generation 0 survivors are promoted to generation 1, and generation 0 is empty.

The managed heap supports only three generations: generation 0, generation 1, and generation 2; **there is no generation 3**. When the CLR initializes, it selects budgets for all three generations. However, the CLR’s garbage collector is a self-tuning collector.

### 2.1 Garbage Collection Triggers

As you know, the CLR triggers a GC when it detects that generation 0 has  lled its budget. This is the most common trigger of a GC; however, there are additional GC triggers as listed here:

* Code explicitly calls System.GC’s static Collect method
* Windows is reporting low memory conditions
* The CLR is unloading an AppDomain
* The CLR is shutting down

### 2.2 Large Objects

There is one more performance improvement you might want to be aware of. **The CLR considers each single object to be either a small object or a large object.** In the previous discussion, I’ve been focusing on small objects. Today, a large object is 85,000 (could change in future) bytes or more in size. The CLR treats large objects slightly differently than how it treats small objects.

For the most part, large objects are transparent to you; you can simply ignore that they exist and that they get special treatment until you run into some unexplained situation in your program (like why you’re getting address space fragmentation).

### 2.3 GC Modes

When the CLR starts, it selects a GC mode, and this mode cannot change during the lifetime of the process. There are two basic GC modes:

* Workstation
* Server

By default, applications run with the Workstation GC mode. **A server application (such as ASP.NET or Microsoft SQL Server) that hosts the CLR can request the CLR to load the `Server` GC**. However, if the server application is running on a uniprocessor machine, then the CLR will always use Workstation GC mode. A stand alone application can tell the CLR to use the Server GC mode by creating a configuration file.

In addition to the two modes, the GC can run in two sub-modes: concurrent (the default) or non-concurrent. In concurrent mode, the GC has an additional background thread that marks objects concurrently while the application runs.

**When using the concurrent garbage collector, you will typically find that your application is consuming more memory than it would with the non-concurrent garbage collector**.

### 2.4 Forcing Garbage Collections

You can also force the garbage collector to perform a collection by calling `GC` class’s `Collect` method.









