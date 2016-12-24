## R.I.P.

At some point in history we thought the following language features were good ideas and increase the expressive power of a language that includes them.

It turned out they are not good ideas. In their unrestricted forms, they cause undefined behavior (errors, crashes, incorrect results, security breaches) and intractable complexity.

Note: in fact, most programming languages are [Turing complete](https://en.wikipedia.org/wiki/Turing_completeness) so they can express the exact same computations, only differently.


### Dynamic Scope

With [dynamic scope](https://en.wikipedia.org/wiki/Dynamic_scope#Dynamic_scoping), functions are evaluated in the environment at the point of use. Thus the meaning of variable and function names used inside a function can change depending on where the function was called from.

The `this` or `self` keyword in many OOP languages is a restricted form of dynamic scope, it refers to the object on which the method was called. Its problems are somewhat less severe, and more noticeable in dynamic languages.

**Why we thought it's good:** The meaning of a function can change depending on the environment where it is used, making it possible to extend functionality later.

**Why it's bad:** The meaning of a function can change  depending on the environment where it is used, in uncontrollable ways, allowing unintended (accidental or malicious) changes in the behaviour of a piece of code from the outside, resulting in errors, incorrect results, and security breaches. The function author can do nothing to prevent this.

**What to use instead:** [static/lexical scope](https://en.wikipedia.org/wiki/Static_scope#Lexical_scoping) - names always refer to things that are reachable from where they are used in the source text.


### Manual Memory Management

With [manual memory management](https://en.wikipedia.org/wiki/Manual_memory_management), the allocation and deallocation of memory for data is requested from the operating system manually.

**Why we thought it's good:** In the very early days of computing, garbage collectors were thought to introduce a large overhead. Manual Memory management was the default, as it allows fine-grained control over when and where and how much allocation and deallocation is done.

**Why it's bad**: Managing memory manually is a tedious and error-prone process. Doing it incorrectly causes [a wide range of memory errors](https://en.wikipedia.org/wiki/Memory_safety#Types_of_memory_errors) leading to data corruption and even overwriting of the executable code, allowing severe security breaches like remote code execution.

**What to use instead:** automatic memory management, usually [garbage collection](https://en.wikipedia.org/wiki/Garbage_collection_(computer_science)).


### Null

All variables, at any time, can have the value [`Null`](https://en.wikipedia.org/wiki/Null_pointer) (in addition to the usual possible values for variables of that type). This can be used to indicate a missing/empty value.

**Why we thought it's good:** It was easy to implement. That's it. [Seriously](https://en.wikipedia.org/wiki/Null_pointer#History).

**Why it's bad:** Any evaluation can result in a `Null` value, which, when used, will cause runtime errors like [`NullPointerException`](https://en.wikipedia.org/wiki/Null_pointer#Dereferencing) and incorrect results that only show up later in the computation and have to be traced back to where they are caused. The only way to eliminate the possibility of errors caused by `Null` is to check the result of *every* computation and handle the case where it is `Null` appropriately.

**What to use instead:** [Algebraic Data Types](https://en.wikipedia.org/wiki/Algebraic_data_type) describe all possible values of a variable, and can not be `Null`. To encode the possibility of a "missing" or "empty" value, use an [Option type](https://en.wikipedia.org/wiki/Option_type), which requires the handling of the empty case, so it can never cause undefined behavior or exceptions.


### Mutation

Instead of simple values, variables in imperative programming are like boxes (memory locations) whose contents can be changed any time.

**Why we though it's good:** We can write efficient programs by reusing memory.

**Why it's bad:**
- in general, it is impossible to find out what value a name refers to, or where a certain value "came from", that is, which part of the program put it in the box
- the behavior of a piece of code can be changed from the outside in undefined, accidental or malicious ways
- the order of evaluation can change result of computations
- concurrent programs are very hard to write and require careful synchronization of the different computations to prevent severe problems like [race conditions](https://en.wikipedia.org/wiki/Race_condition#Software) and [deadlocks](https://en.wikipedia.org/wiki/Deadlock)
- all of the above allow undefined behaviour, unintended (accidental or malicious) changes in the behaviour of a piece of code from the outside, incorrect results, and security breaches
- the only way a programmer can completely avoid accidental or malicious mutation is to manually create copies of *every* value before passing it to a function or assigning it to a variable

**What to use instead:**
- immutable data with [pure functions](https://en.wikipedia.org/wiki/Pure_function). They have the exact same expressive power, and you can *always* trace where any value comes from, and what any name refers to. They also make compiler optimizations and garbage collection easier. With modern compilers, performance and memory use of pure computations with immutable data is as good as with mutable computations.
- [uniqueness types](https://en.wikipedia.org/wiki/Uniqueness_type) allow safe overwriting and reuse of memory by ensuring that there are no references to the old data that is not available anymore. E.g. in [Rust](https://doc.rust-lang.org/book/ownership.html) and [Idris](http://docs.idris-lang.org/en/latest/reference/uniqueness-types.html).



### Side Effects

Instead of functions that just compute a result from the arguments, procedures in imperative programming can have [side effects](https://en.wikipedia.org/wiki/Side_effect_(computer_science)) like accessing and manipulating resources and mutable state defined outside them.

**Why we thought it's good:**
- it's the traditional

**Why it's bad:**
- procedures can have different results when called with the same arguments, depending on outside state (like dynamic scope), making it hard to think about what their results and effects can be
- procedures can modify
- the order of execution can change the result


**What to use instead:** pure functions and immutable data with monads or algebraic effects


### Runtime Exceptions

https://en.wikipedia.org/wiki/Exception_handling


### Dynamic Types

Instead of checking that functions and values are used in compatible ways _before_ running the program, it is done during runtime. Thus the majority of language constructs and standard library features need to check wether they are used correctly when they are evaluated, and throw runtime exceptions when they are not.

**Why we thought it's good:**
- no need to write down types - the type of each variable and expression is stored along with its value during runtime
- no type errors during compilation (most dynamic languages don't have a separate compilation step)
- sometimes programs can be expressed more concisely
- easier to implement
- internals of language features can be easier to expose and override, allowing easier metaprogramming

**Why it's bad:**
- no possibility to write down types and enforce their correct use before the program is run
- in fact, types _must_ be kept track of and checked during runtime, decreasing performance, and requiring the implementation of type checking rules, although in a less structured way
- the same type errors _do_ show up, but only when the program is run, functions receive incompatible values and throw runtime type errors, e.g. `TypeError: undefined is not a function` or `AttributeError: NoneType has no attribute 'foo'`
- _every_ operation can fail or throw an exception during runtime, including core language features like array or object item access, method calls, and built-in functions
- values with incorrect types can propagate through the program and cause errors and incorrect results much later, making them hard to debug because they have to be traced back to their source
- runtime type errors can not be avoided, only mitigated by manually checking the types of arguments of _all_ functions we define, and catching exceptions

**What to use instead:**
- [static types](https://en.wikipedia.org/wiki/Type_system#STATIC) give us the strongest guarantee of the absence of runtime errors and exceptions: a formal logical proof extracted from the program by the type checker
- since we already proved the correct use of values and functions, there is no need to check them during runtime, so the compiler can throw away the type information, increasing performance
- with [type inference](https://en.wikipedia.org/wiki/Type_inference), we don't have to write down types in static languages, so this apparent advantage disappears. writing down the types of top-level functions is recommended though, for documentation and to make it easier to debug type errors


### Inheritance

**Why we thought it's good:**
- reuse
- [TODO]


**Why it's bad:**
fail at reuse, safety
- data and behavior are tightly coupled, leading to extensibility problems
- multiple inheritance is very hard to deal with

**What to use instead**: parametric polymorphism, polymorphic (extensible) records, interfaces/typeclasses, composition


### Object Oriented Programming

OOP usually combines imperative programming, mutability, inheritance, a limited form of dynamic scope (`this`), and `Null`, to achieve maximum fail.

**Why we thought it's good:**
- it is similar to the intuitive idea of interactions beetween physical objects: objects have an internal state and can act on and be acted upon by other objects
- the lure of reuse through inheritance of data and behavior
- the Actor model (?)


OOP provides a clear modular structure for programs which makes it good for defining abstract datatypes where implementation details are hidden and the unit has a clearly defined interface.
OOP makes it easy to maintain and modify existing code as new objects can be created with small differences to existing ones.
OOP provides a good framework for code libraries where supplied software components can be easily adapted and modified by the programmer. This is particularly useful for developing graphical user interfaces.

Implementation details are hidden from other modules and other modules has a clearly defined interface.
It is easy to maintain and modify existing code as new objects can be created with small differences to existing ones.
objects, methods, instance, message passing, inheritance are some important properties provided by these particular languages
encapsulation, polymorphism, abstraction are also counts in these fundamentals of programming language.
It implements real life scenario.
In OOP, programmer not only defines data types but also deals with operations applied for data structures



TODO: ^ ?

**Why it's bad** (in addition to the bad from each component)**:**
- tightly couples data and behavior
- objects usually have mutable state
- object identity introduces difficulties, equality (deciding if two objects are the same) can be by value (hard to implement, especially in the case of inheritance), by reference (sometimes incorrect), or by assigning a unique identifier (sometimes incorrect)


**What to use instead:** **functional programming** with polymorphic records, algebraic data types, immutable data, pure functions, and reuse through composition of functions and interfaces.


## I want to use this stuff now

**If this is all new for you**, take this great [Programming Languages course](https://www.coursera.org/learn/programming-languages) on Coursera from University of Washington with Dan Grossman. He's a great teacher, easy to follow, yet precise.

From the introduction video:

> This course is about an opportunity to learn the fundamental concepts of programming languages and we're going to do it in a way that will, I believe, make you a better programmer in any programming language. And in fact, in programming languages that we're not even going to use during this course. The idea is really to learn the ideas around which every programming language is built and understand precisely the different ideas that we use when we program, and how those ideas are expressed in lots of different programming languages.

Part A of the course will also teach you everything you need to know to get started with functional programming and algebraic types, so you can move on to the next step below. I recommend Part B and Part C as well, because it will give you a deep understanding of dynamic languages and OOP, and the differences between approaches.

**If you're already somewhat comfortable** with functional programming and algebraic data types, you're ready to write cool interactive apps in a delightfully simple language called [Elm](http://elm-lang.org/).

Follow the [introduction guide](https://guide.elm-lang.org/) and you'll be writing applications with rich user interfaces, animation, network connectivity, and so on, that never throw runtime exceptions, in a very short time.

**If you want to write native or backend apps**, you will need to learn a bit more, because managing system resources like files, buffers, and network connections is tricky in general.

[Haskell](https://www.haskell.org/) is the go-to general purpose functional language, so you should definitely look into it, although it can be somewhat difficult at times.

If you're a Java or C# developer, check out [Scala](https://www.scala-lang.org/) and [F#](http://fsharp.org) for an easy migration path. They run on the JVM / .NET CLI or mono, and can access Java / C# code direcrtly.

[OCaml](http://www.ocaml.org/) also deserves a mention here. Amongst others things, you can write [unikernels](https://en.wikipedia.org/wiki/Unikernel) using [MirageOS](https://mirage.io/wiki/overview-of-mirage) that skip the OS and run directly on top of Virtual Machine Hypervisors like Xen, used by many cloud providers.

For safe, high performance, low level software, try [Rust](https://www.rust-lang.org/en-US/).

**For safe and functional software stacks**, use the [Nix](https://nixos.org/nix/) package manager. It's great for development environments, e.g. updating one package can't break another, and everything is rebuilt that is necessary, but nothing that is not. It runs on most unixes, Linux, and macOS. There's a great Linux distribution based on it, [NixOS](https://nixos.org/), which applies the same purely functional, immutable, declarative principles to operating system configuration: say what you want, not how to get there.

**If you want to get a glimpse of the future** and try the most advanced type system in a real-world usable language, try [Idris](http://docs.idris-lang.org/en/latest/tutorial/introduction.html). It is a language with dependent types, meaning types are normal values, and functions can take and return them. It has some mind-bending features that will have impact for decades to come. The language is mostly ready for prime time, but there are not many libraries available yet.
