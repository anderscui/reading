# Thread Basics

This part introduces the basic concepts concerning threads, and offers a way for developers to conceptualize about them and their use.

## 1. Why Does Windows Support Threads?

Back in the early days of computers, operating systems didn’t offer the concept of a thread. In effect, *there was just one thread of execution that ran throughout the entire system*, which *included both operating system code and application code*. The problem with having only one thread of execution was that a long-running task would prevent other tasks from executing. For example, in the days of 16-bit Windows, it was very common for an application that was printing a document to stall the entire machine, causing the operating system and all other applications to stop responding. And, sometimes applications would have a bug in them, resulting in an infinite loop that also stopped the entire machine from operating. (**A bug in one app stops the entire machine.**)

The newer OS had to be robust, reliable, scalable, and secure, and it had to improve the many deficiencies of 16-bit Windows. This OS kernel originally shipped in **Windows NT**. Over the years, this kernel has had many tweaks and features added to it.

When Microsoft was designing this operating system kernel, they decided to run each instance of an application in what is called a **process**. **A process is just a collection of resources** that is used by **a single instance of an application**.

Each process is given a **virtual address space**, ensuring that the code and data used by one process is not accessible to another process. This makes application instances robust because **one process cannot corrupt code or data being used by another**. In addition, **the operating system’s kernel code and data are not accessible to processes**; therefore, it’s not possible for application code to corrupt operating system code or data.

So `process` makes the data cannot be corrupted and is more secure. This is all well and good, but what about the CPU itself? What if an application enters an infinite loop? Well, if there is only one CPU in the machine, then it executes the infinite loop and cannot execute anything else.

Microsoft needed to fix this problem, too, and `threads` were the answer. **A thread is a Windows concept whose job is to virtualize the CPU.** Windows gives each process its very own thread(which functions similar to a CPU), and if application code enters an infinite loop, the process associated with that code freezes up, but other processes (which have their own threads) are not frozen; they keep running!

## 2. Thread Overhead

Threads are awesome because they enable Windows to be responsive even when applications are executing long-running tasks. Threads allow the user to use one app (like Task Manager) to do sth. like `Force Quit`. But as with every virtualization mechanism, **threads have space (memory consumption) and time (runtime execution performance) overhead associated** with them.

Every thread has one of each of the following:

* **Thread kernel object**: The operating system allocates and initializes one of these data structures for each thread created in the system. The data structure contains a bunch of properties (discussed later in this chapter) that describe the thread, and also contains what is called the **thread’s context**. The context is a block of memory that contains a set of the CPU’s registers.
* **Thread environment block (TEB)**: The TEB is a block of memory allocated and initialized in **user mode** (address space that application code can quickly access). 
* **User-mode stack**: **The user-mode stack is used for local variables and arguments passed to methods.** It also contains the address indicating what the thread should execute next when the current method returns. By default, Windows allocates 1 MB of memory for each thread’s user mode stack.
* **Kernel-mode stack**:
* **DLL thread-attach and thread-detach notifications**: In the early days of Windows, many processes had maybe 5 or 6 DLLs loaded into them, but today, some processes have several hundred DLLs loaded into them. Right now, on my machine, Microsoft Visual Studio has about 470 DLLs loaded into its process address space! This means that whenever a new thread is created in Visual Studio, 470 DLL functions must get called before the thread is allowed to do what it was created to do. And these 470 functions must be called again whenever a thread in Visual Studio dies. Wow—this can seriously affect the performance of creating and destroying threads within a process.

So now, we can see all the space and time overhead that is associated with creating a thread, letting it sit around in the system, and destroying it. But the situation gets even worse—now we’re going to start talking about **context switching(传说中的上下文切换)**. A computer with only one CPU in it can do only one thing at a time. Therefore, W**indows has to share the actual CPU hardware among all the threads (logical CPUs) that are sitting around in the system**.

At any given moment in time, Windows assigns one thread to a CPU. That thread is allowed to run for a **time-slice**. When the time-slice expires, Windows context switches to another thread. Every context switch requires that Windows performs the following actions:

* Save the values in the CPU's registers to the currenty running thread's context structure inside the thread's kernel object.
* Select one thread from the set of existing threads to schedule next.
* Load the values in the selected thread’s context structure into the CPU’s registers.

Windows performs context switches about every 30 ms. Context switches are pure overhead; that is, there is no memory or performance benefit that comes from context switches.

In addition, when performing a garbage collection, the CLR must suspend all the threads, walk their stacks to find the roots to mark ob ects in the heap, walk their stacks again (updating roots to objects that moved during compaction), and then resume all the threads.

From this discussion, you should conclude that you must avoid using threads as much as possible because they consume a lot of memory and they require time to create, destroy, and manage. Time is also wasted when Windows context switches between threads and when garbage collections occur. However, this discussion should also **help you realize that threads must be used sometimes because they allow Windows to be robust and responsive**.

I should also point out that a computer with multiple CPUs (or hyperthreaded CPUs, or multi-core CPUs) in it can actually run multiple threads simultaneously, increasing scalability (the ability to do more work in less time).

## 3. Stop the Madness

If all we cared about was raw performance, then the optimum number of threads to have on any machine is identical to the number of CPUs on that machine:) 
However, Microsoft designed Windows to favor reliability and responsiveness as opposed to favoring raw speed and performance.

## 4. CPU Trends

In the past, CPU speeds used to increase with time, so an application that ran slowly on one machine would typically run faster on a newer machine. However, CPU manufacturers are unable to continue the trend of making CPUs faster.

Because CPU manufacturers can’t continuously produce higher-speed CPUs, they have instead turned their attention to making transistors smaller so that more of them can reside on a single chip. Today, we can have a single silicon chip that contains two or more CPU cores. **The result is that our software only gets faster if we write our software to use the multiple cores**.

Computers use three kinds of multi-CPU technologies today:

* Multiple CPUs (older, larger machines)
* Hyperthreaded chips (Intel)
* Multi-core chips

## 5. CLR Threads and WIndows Threads

Today, **the CLR uses the threading capabilities of Windows**, so we will focus on how the threading capabilities of Windows are exposed to developers who write code by using the CLR. I will explain about how threads in Windows work and how the CLR alters the behavior (if it does).

PS: Back in the early days of the .NET Framework, the CLR team felt that they would someday have the CLR offer logical threads, which did not necessarily map to Windows threads. However, around 2005, this was attempted unsuccessfully, causing the CLR team to give up on the idea. So today, **a CLR thread is identical to a Windows thread**.

## 6. Using a Dedicatd Thread to Perform an Asynchronous Compute-Bound Operation

Typically, you’d want to create a dedi- cated thread if you’re going to execute code that requires the thread to be in a particular state that is not normal for a thread pool thread. For example, explicitly create your own thread if any of the following is true:

* You need the thread to run with a non-normal thread priority. All thread pool threads run at normal priority.
* You need the thread to behave as a foreground thread, thereby preventing the application from dying until the thread has completed its task. Thread pool threads are always background threads.
* The compute-bound task is extremely long-running.
* You want to start a thread and possibly abort it prematurely by calling Thread’s `Abort` method.

Constructing a `Thread` object is a relatively lightweight operation because it does not actually create a physical operating system thread. **To actually create the operating system thread and have it start executing the callback method, you must call Thread’s Start method**, passing into it the object (state) that you want passed as the callback method’s argument.

The `Join` method causes the calling thread to stop executing any code until the thread identified by dedicatedThread has destroyed itself or been terminated.

## 7. Reasons to Use Threads

There are really two reasons to use threads:

* Responsiveness (typically for client-side GUI apps): 
* Performance (for client and server side apps): Today, machines with multiple CPUs in them are quite common, so designing your application to use multiple cores makes sense.

Now, I’d like to share with you a theory of mine. Every computer has an incredibly powerful resource inside it: the CPU itself. If someone spends money on a computer, then that computer should be working all the time. In other words, I believe that all the CPUs in a computer should be running at 100 percent utilization all the time.

Today, **computers ship with phenomenal amounts of computing power**. Earlier in this chapter, I showed you how Task Manager was reporting that my CPU was busy just 5 percent of the time. If my computer contained a quad-core CPU in it instead of the dual-core CPU that it now has, then Task Manager will report 2 percent more often. When an 80-core processor comes out, the machine will look like it’s doing nothing almost all the time. To computer purchasers, **it looks like they’re spending more money for more CPUs and the computer is doing less work**!

We now have an abundance of computing power available and more is on the way, so **developers can aggressively consume it** (more background threads?). That’s right—in the past, we would never dream of having our applications perform some computation unless we knew the end user wanted the result of that computation. But now that we have extra computing power, we can dream like this.

Here's an example: when you stop typing in Visual Studio’s editor, **Visual Studio automatically spawns the compiler and compiles your code**. This makes developers incredibly productive because they can see warnings and errors in their source code as they type and can fix things immediately.

Here are some **more examples of aggressive CPU consumption**: **spell checking** (many apps, Outlook/Evernote...) and grammar checking of documents, recalculation of spreadsheets, indexing files on your disk for fast searching (Everything), and defragmenting your hard disk to improve I/O performance.

I want to live in a world where the UI is reduced and simplified, I have more screen real estate to visualize the data that I’m actually working on, and applications offer me information that helps me get my work done quickly and efficiently instead of me telling the application to go get information for me. I think **the hardware has been there for software developers to use** for the past few years. **It’s time for the software to start using the hardware creatively**.

## 8. Thread Scheduling and Priorities

After a time-slice, Windows looks at all the thread kernel objects currently in existence. Of these objects, **only the threads that are not waiting for something are considered schedulable**. Windows selects one of the schedulable thread kernel objects and context switches to it. Windows actually keeps a record of how many times each thread gets context switched to. (You can see this when using a tool such as `Microsoft Spy++`.) At this point, the thread is executing code and manipulating data in its process’s address space. After another time-slice, Windows performs another context switch. **Windows performs context switches from the moment the system is booted and continues until the system is shut down.**

Windows is called a **preemptive multithreaded operating system** (抢占式多任务处理，与协作式多任务处理相对) because a thread can be stopped at any time and another thread can be scheduled. As you’ll see, **you have some control over this, but not much**. Just remember that you cannot guarantee that your thread will always be running and that no other thread will be allowed to run.

Every thread is assigned a priority level ranging from 0 (the lowest) to 31 (the highest). When the system decides which thread to assign to a CPU, it examines the priority 31 threads first and schedules them in a r**ound-robin fashion**.

As long as priority 31 threads are schedulable, the system never assigns any thread with a prior- ity of 0 through 30 to a CPU. This condition is called **starvation**, and it occurs when higher-priority threads use so much CPU time that they prevent lower-priority threads from executing. **Higher-priority threads always preempt lower-priority threads, regardless of what the lower-priority threads are executing**.

PS: By the way, when the system boots, it creates a special thread called the zero page thread. This thread is assigned priority 0 and is the only thread in the entire system that runs at priority 0.

Microsoft realized that assigning priority levels to threads was going to be too hard for developers to rationalize. Should this thread be priority level 10? Should this other thread be priority level 23? To resolve this issue, **Windows exposes an abstract layer over the priority level system**.

When designing your application, you should decide whether your application needs to be more or less responsive than other applications that may be running on the machine. Then you choose a process priority class to reflect your decision. **Windows supports six process priority classes: Idle, Below Normal, Normal, Above Normal, High, and Realtime**.

The `Idle` priority class is perfect for applications (like screen savers) that run when the system is all but doing nothing. You should use the `High` priority class only when absolutely necessary. You should avoid using the `Realtime` priority class if possible.

After you select a priority class, you should stop thinking about how your application relates to other applications and just **concentrate on the threads within your application**. **Windows supports seven relative thread priorities: Idle, Lowest, Below Normal, Normal, Above Normal, Highest, and Time-Critical**. These **priorities are relative to the process’s priority class**. Again, Normal relative thread priority is the default, and it is therefore the most common.

The concept of a process priority class confuses some people. They think that this somehow means that Windows schedules processes. However, **Windows never schedules processes; Windows only schedules threads.** The **process priority class is an abstract concept that Microsoft created to help you rationalize how your application compares with other running applications**; it serves no other purpose.

## 9. Foreground Threads vs. Background Threads

**The CLR considers every thread to be either a foreground thread or a background thread**. When all the foreground threads in a process stop running, the CLR forcibly ends any background threads that are still running. **These background threads are ended immediately; no exception is thrown**.

Therefore, you should use foreground threads to execute tasks that you really want to complete, like flushing data from a memory buffer out to disk. And you should use background threads for tasks that are not mission-critical.

It is possible to change a thread from foreground to background and vice versa at any time during its lifetime. An application’s primary thread and any threads explicitly created by constructing a `Thread` object default to being foreground threads. On the other hand, thread pool threads default to being background threads. Also, any **threads created by native code** that enter the managed ex- ecution environment are marked as background threads.

Note: Try to avoid using foreground threads as much as possible.

## 10. What Now?

TODO:



