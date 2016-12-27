## R.I.P.

At some point in history we thought the following programming language concepts are good ideas and increase the expressive power of a language that includes them.

It turned out they are not good ideas. In their unrestricted forms, they cause undefined behavior (resulting in errors, crashes, incorrect results, security breaches) and intractable complexity.

Besides automating brittle processes, a common theme is that we simply get rid of some features, thereby reducing the number of possible execution paths of programs, often exponentially, to the point where the meaning of each piece can be understood by looking at that piece in isolation, and bigger pieces are built of smaller pieces in the most straightforward way. The programmer doesn't have to think about a huge number of ways a piece of code might fail, because it can't. The result is robust, correct software, increased productivity, and more help from the computer during development, because it has a better idea of what we are trying to do.

Note: in fact, most programming languages are [Turing complete](https://en.wikipedia.org/wiki/Turing_completeness) so they can express the exact same computations, only differently.


### Dynamic Scope

With [dynamic scope](https://en.wikipedia.org/wiki/Dynamic_scope#Dynamic_scoping), names in functions are looked up in the environment where the function is called, not where it is defined. Thus the meaning of a function names can change depending on where it was called from.

The `this` or `self` keyword in many OOP languages is a restricted form of dynamic scope, it refers to the object on which the method was called. Its problems are somewhat less severe, and more noticeable in dynamic languages.

**Why we thought it's good:** The meaning of a function can change depending on the environment where it is used, making it possible to extend functionality later.

**Why it's bad:** The meaning of a function can change  depending on the environment where it is used, in uncontrollable ways, allowing unintended (accidental or malicious) changes in the behaviour of a piece of code from the outside, resulting in errors, incorrect results, and security breaches. The function author can do nothing to prevent this, except give the variables unusual names and hope for the best.

**What to use instead:** [static/lexical scope](https://en.wikipedia.org/wiki/Static_scope#Lexical_scoping) - names always refer to the environment where they are used in the source text. This is the default in most current languages.


### Manual Memory Management

With [manual memory management](https://en.wikipedia.org/wiki/Manual_memory_management), the allocation and deallocation of memory for data is requested from the operating system manually.

**Why we thought it's good:** In the very early days of computing, garbage collectors were thought to introduce a large overhead. Manual Memory management was the default, as it allows fine-grained control over when and where and how much allocation and deallocation is done.

**Why it's bad**: Managing memory manually is a tedious and error-prone process. Doing it incorrectly causes [a wide range of memory errors](https://en.wikipedia.org/wiki/Memory_safety#Types_of_memory_errors) leading to data corruption and even overwriting of the executable code, allowing severe security breaches like remote code execution.

**What to use instead:**: Automatic memory management, usually [garbage collection](https://en.wikipedia.org/wiki/Garbage_collection_(computer_science))


### Null

All variables, at any time, can have the value [`Null`](https://en.wikipedia.org/wiki/Null_pointer) (in addition to the usual possible values for variables of that type). This can be used to indicate a missing/empty value.

**Why we thought it's good:**
- historically, it is the most straightforward, fast, low level way to signal a missing value or failure, distinguishable from a valid memory address if one cared to check
- It was easy to implement. [Seriously](https://en.wikipedia.org/wiki/Null_pointer#History).

**Why it's bad:** Almost any evaluation can result in a `Null` value, which, when used, will cause runtime errors like [`NullPointerException`](https://en.wikipedia.org/wiki/Null_pointer#Dereferencing) and incorrect results that only show up later in the computation and have to be traced back to where they are caused. The only way to eliminate the possibility of errors caused by `Null` is to check the result of *every* computation and handle the case where it is `Null` appropriately.

**What to use instead:** [Algebraic Data Types](https://en.wikipedia.org/wiki/Algebraic_data_type) describe all possible values of a variable, and can not be `Null`. To encode the possibility of a "missing" or "empty" value, use an [Option type](https://en.wikipedia.org/wiki/Option_type), which requires the handling of the empty case at some point, so it can never cause undefined behavior or exceptions.


### Mutation

Instead of simple values, variables in imperative programming are like boxes (memory locations) whose contents can be changed any time.

**Why we though it's good:** We can write efficient programs by reusing memory.

**Why it's bad:**
- in general, it is impossible to find out what value a name refers to, or where a certain value "came from", that is, which part of the program put it in the box
- the behavior of a piece of code can be changed from the outside in undefined, accidental or malicious ways
- the order and number of times a piece of code is evaluated can change result
- concurrent programs are very hard to write and require careful synchronization of the different computations to prevent severe problems like [race conditions](https://en.wikipedia.org/wiki/Race_condition#Software) and [deadlocks](https://en.wikipedia.org/wiki/Deadlock)
- all of the above allow undefined behaviour, unintended (accidental or malicious) changes in the behaviour of a piece of code from the outside, incorrect results, and security breaches
- the only way a programmer can completely avoid accidental or malicious mutation is to manually create copies of *every* value before passing it to a function or assigning it to a variable

**What to use instead:**
- immutable data with [pure functions](https://en.wikipedia.org/wiki/Pure_function). They have the exact same expressive power, and one can *always* trace where any value comes from, and what any name refers to. They also make compiler optimizations and garbage collection easier. With modern compilers, processor and memory use of pure computations with immutable data is as good as with mutable computations.
- if necessary, algorithms can be written in an imperative manner by using safe local mutation, e.g. by sequencing operations on `Option` types, or using the [ST Monad](https://en.wikipedia.org/wiki/Haskell_features#ST_monad)
- [uniqueness types](https://en.wikipedia.org/wiki/Uniqueness_type) allow safe overwriting and reuse of memory by ensuring that there are no references to the old data (that was overwritten). E.g. in [Rust](https://doc.rust-lang.org/book/ownership.html) and [Idris](http://docs.idris-lang.org/en/latest/reference/uniqueness-types.html).


### Side Effects

Instead of functions that just compute a result from the arguments, procedures/methods in imperative programming can have [side effects](https://en.wikipedia.org/wiki/Side_effect_(computer_science)) like accessing and manipulating resources and mutable state defined outside them.

**Why we thought it's good:**
- it is the way the [underlying architecture](https://en.wikipedia.org/wiki/Von_Neumann_architecture) of modern processors works
- it is the traditional way of interacting with the outside world - how else would we communicate on the network or show things on the screen?
- it is the traditional way of using a computer's memory - making a new variable every time would use up all memory pretty soon

**Why it's bad:**
- procedures can have different results when called with the same arguments, depending on the state of the world outside them, making it hard to think about their results
- procedures can _modify_ the state of the world outside them, making it hard to track the interactions between different parts of a program
- _any_ part of a program may communicate with the outside world, making it hard to track the interaction between the program and the world
- the number of times and the order in which code is executed can change the result
- testing is irritatingly hard, e.g. just to test some networking code, you have to implement part of (aka mock) the network API and modify your code to work with exchangeable networking components
- sometimes testing is impossible, e.g. when you can't modify parts of the system
- writing concurrent programs is hard and leads to many difficult to track down bugs, see [thread safety](https://en.wikipedia.org/wiki/Thread_safety)

**What to use instead:** pure functions and immutable data with effects described as data and executed by the language runtime, e.g.:
- if you're stuck in an imperative language, keep all points of contact with the outside world in one place (e.g. `main`), and write everything else as [referentially transparent](https://en.wikipedia.org/wiki/Referential_transparency) functions that transform data - "functional core, reactive shell"
- simple effects producing input messages [as in Elm](https://guide.elm-lang.org/architecture/effects/)
- IO monad [as in Haskell](https://en.wikipedia.org/wiki/Monad_(functional_programming)#The_I.2FO_monad)
- algebraic effects [as in Idris](http://docs.idris-lang.org/en/latest/effects/introduction.html)


### Runtime Exceptions

When an operation fails (e.g. a file was not found, a network connection closed, or an element in a list was not found), instead of _returning_ a value indicating failure, a [https://en.wikipedia.org/wiki/Exception_handling#Exception_handling_in_software](runtime exception) is _thrown_, and execution flow jumps out and over one or more method returns to the nearest enclosing `try/catch` block which can can handle the specific exception - called a _non-local return_. If there there is no such handler, exceptions are usually caught at the top level by the language runtime, after which they are displayed to the user and the program terminates.

[Checked exceptions](https://en.wikipedia.org/wiki/Exception_handling#Checked_exceptions) are a small improvement, requiring the programmer to declare that a method can throw a certain exception, or handle it.

**Why we thought they're good:**
- they seem like a flexible tool for handling failure
- can not be avoided in the case of dynamic languages while keeping the language practical

**Why they're bad:**:
- they introduce complexity by creating an exponential number of hidden execution paths
- they are difficult to handle correctly, often leading programmers to try to [cheat](http://i.imgur.com/9ArGADw.png)
- program state and user data may often be corrupted because of execution paths unaccounded for
- an unhandled error and the resulting program crash with a long and unintelligible error message is exceptionally bad user experience

**What to use instead:**
- Algebraic data types, specifically [`Option`](https://en.wikipedia.org/wiki/Option_type) to indicate possible failure with no additional information, or `Result` (aka `Error`, `Either`) to describe different ways an operation can fail or provide more information about the failure.
- safe, contained non-local returns can be described by sequencing operations on `Option` types, or using an Error Monad or Exception Effect


### Dynamic Types

Instead of checking that functions and values are used in compatible ways _before_ running the program, it is done during runtime. Thus the majority of language constructs and standard library features need to check wether they are used correctly when they are evaluated, and throw runtime exceptions when they are not.

**Why we thought they're good:**
- no need to write down types - the type of each variable and expression is stored along with its value during runtime
- no type errors during compilation (dynamic languages usually don't have a separate compilation step)
- sometimes programs can be expressed more concisely
- easier to implement
- internals of language features can be easier to expose and override, allowing easier metaprogramming

**Why they're bad:**
- no possibility to write down types and check their correct use before the program is run
- in fact, types _must_ be kept track of and checked during runtime, decreasing performance, and still requiring the implementation of type checking rules, although in a less structured way
- the same type errors _do_ show up, but only when the program is run, functions receive incompatible values and throw runtime type errors, e.g. `TypeError: undefined is not a function` or `AttributeError: NoneType has no attribute 'foo'`
- _every_ operation can fail and throw an exception during runtime, including core language features like array or object item access, method calls, and built-in functions
- values with incorrect types can propagate through the program and cause errors and incorrect results much later, making them hard to debug because they have to be traced back to their source
- extensive test suites are often used to increase the safety and robustness of software in dynamic languages, but tests can only prove the _presence_ of bugs, not the absence thereof
- runtime type errors can not be avoided, only mitigated by manually checking the types of arguments of _all_ functions we define, and handling exceptions (see above)

**What to use instead:**
- [static types](https://en.wikipedia.org/wiki/Type_system#STATIC) give us the strongest guarantee of the absence of runtime exceptions: a formal logical proof extracted from the program by the type checker
- since we already proved the correct use of values and functions, there is no need to keep type information around during runtime, so the compiler throws it away, increasing performance
- with [type inference](https://en.wikipedia.org/wiki/Type_inference), we don't have to write down types in static languages, so this apparent advantage disappears.

Note: Adding type annotations to top-level functions is recommended even in languages that can infer them, to help humans read the code and to make type errors more precise. However, since the type checker already knows the types, this can be done automatically (e.g. with a keyboard combo). In the other direction, with Type Driven Development, we write down the types first, and the compiler completes parts of the program for us.


### Inheritance

[TODO] : way to organize concepts in a logical system, reuse

**Why we thought it's good:**
- reuse
- [TODO]


**Why it's bad:**
- hierarchies in the world around us and everyday life are based on containment/ownership, not inheritance
- fail at reuse, safety
- logic fail
- multiple inheritance is impossible to deal with correctly in general
- [TODO]

**What to use instead**: parametric polymorphism, polymorphic (extensible) records, composition of interfaces


### Object Oriented Programming

OOP usually combines imperative programming (so mutability and side effects), inheritance, a limited form of dynamic scope (`this`), and `Null`.

**Why we thought it's good:**
- it is similar to the intuitive idea of interactions beetween physical objects: objects have an internal state and can act on and be acted upon by other objects
- the lure of reuse through inheritance of data and behavior
- it promises to help reuse by hiding implementation details through encapsulation (private class members)
- the Actor model [TODO]
- [TODO]


**Why it's bad:** (in addition to the points from each component)**:**
- tightly couples data and behavior, leading to more difficult extensibility or reuse of either
- objects usually have mutable state, which may be changed by any piece of code with a reference to the object
- breaks encapsulation in several ways, eg. superclasses are not well encapsulated from subclasses
- object identity is problematic: equality (deciding if two objects are the same) can be by value (hard to implement, impossible in general when using inheritance), by reference (incorrect in general), or by assigning a unique identifier (incorrect in general)
- its many shortcomings resulted in the rise and fame of [design patterns](https://en.wikipedia.org/wiki/Design_Patterns#Criticism), which are basically recipes for workarounds to common problems in OOP

[TODO] [see](https://medium.com/@cscalfani/goodbye-object-oriented-programming-a59cda4c0e53#.m7x1zvrc2)

**What to use instead:** **functional programming** with algebraic data types, polymorphic records, immutable data, pure functions, and reuse through composition of functions and interfaces.


### Testing

Tests are small pieces of code that we write to run pieces of our actual code with specific inputs, and check that the results are as expected. This is a straightforward way to ensure functional correctness of (pieces of) our program, but only for the inputs actually tested. It also helps avoid regressions, that is, breaking working parts of our program when we add or change features.

**Why it's not good enough:**
- main point: tests can only prove the _presence_ of bugs, not the absence thereof
- unit tests can only cover a hopelessly small fraction of possible inputs
- finding edge cases manually is a laborious and hopeless exercise (there are always cases you didn't think of), but we do our best
- imperative code can be annoyingly hard to test, so even in imperative languages it's a good idea write referentially transparent code
- there are better ways to ensure correctness that provide more safety with less work

**What to use** in addition to and instead of tests**:**
- static types make a large fraction of tests unnecessary, mainly those that check for correct use of types and correct handling of type-related errors
- property-based testing, aka [QuickCheck](https://hackage.haskell.org/package/QuickCheck) aka [fuzz testing](http://package.elm-lang.org/packages/elm-community/elm-test/latest) tests your code with randomly-generated input and checks that the specified correctness properties are satisfied. failing inputs can be "shrunk" until a minimal failing case is found.
- with [Domain Driven Design](http://fsharpforfunandprofit.com/ddd/) and [Type Driven Development](http://tomasp.net/blog/type-first-development.aspx/), we describe the logical structure of our problem in the domain language, by first writing down its type, which is also a specification for the solution. [Type, Define, Refine [pdf]](https://manning-content.s3.amazonaws.com/download/1/dc78582-0565-472e-a2dc-b88af151b064/Brady_TDDwithIdris_MEAP_V13_ch1.pdf), see Chapter 1.2.
- with a rich enough type system (e.g. [dependent types](https://en.wikipedia.org/wiki/Dependent_type), a type can be given that is so precise as to make it impossible to write an incorrect program; combine with TDD for full benefits


## I want to use this stuff now

**If this is all new for you**, take this great [Programming Languages course](https://www.coursera.org/learn/programming-languages) on Coursera from University of Washington with Dan Grossman. He's a great teacher, easy to follow, yet precise.

From the introduction video:

> This course is about an opportunity to learn the fundamental concepts of programming languages and we're going to do it in a way that will, I believe, make you a better programmer in any programming language. And in fact, in programming languages that we're not even going to use during this course. The idea is really to learn the ideas around which every programming language is built and understand precisely the different ideas that we use when we program, and how those ideas are expressed in lots of different programming languages.

Part A of the course will also teach you everything you need to know to get started with functional programming and algebraic types, so you can move on to the next step below. I recommend Part B and Part C as well, because it will give you a deep understanding of dynamic languages and OOP, and the differences between approaches.

**If you're already somewhat comfortable** with functional programming and algebraic data types, you're ready to write cool interactive apps in a delightfully simple language called [Elm](http://elm-lang.org/).

Follow the [introduction guide](https://guide.elm-lang.org/) and you'll be writing applications with rich user interfaces, animation, network connectivity, and so on, that never throw runtime exceptions, in a very short time. Elm is also ridiculously easy to [integrate with Javascript](https://guide.elm-lang.org/interop/javascript.html).

**If you want to write native or backend apps**, you will need to learn a bit more, because managing system resources like files, buffers, and network connections is tricky in general.

[Haskell](https://www.haskell.org/) is the go-to general purpose functional language, so you should definitely look into it, although it can be somewhat difficult at times.

If you use Java or C# developer, you're in luck, [Scala](https://www.scala-lang.org/) and [F#](http://fsharp.org) offer a straightforward migration path. They run on the JVM / .NET CLI or mono, and can access existing Java / C# code directly so are easy to integrate into existing projects.

[OCaml](http://www.ocaml.org/) also deserves a mention here. Amongst others things, you can write [unikernels](https://en.wikipedia.org/wiki/Unikernel) using [MirageOS](https://mirage.io/wiki/overview-of-mirage) that skip the OS and run directly on top of Virtual Machine Hypervisors like Xen, used by many cloud providers.

For safe, high performance, low level software with zero-cost abstractions, try [Rust](https://www.rust-lang.org/en-US/). It is memory safe without a garbage collector, using ownership (aka [uniqueness types](https://en.wikipedia.org/wiki/Uniqueness_type)).

**For safe and functional software stacks**, use the [Nix](https://nixos.org/nix/) package manager. It's great for development environments, e.g. updating one package can't break another, and everything is rebuilt that is necessary, but nothing that is not. It runs on most unixes, Linux, and macOS. There's a wonderful Linux distribution based on it, [NixOS](https://nixos.org/), which applies the same purely functional, immutable, declarative principles to operating system configuration: say what you want, not how to get there. It also gives you rollbacks, and changes are atomic and thus reliable: they either succeed, or they don't, in which case you're exactly where you started, not in a half-applied inconsistent state.

**If you want to get a glimpse of the future** and try the most advanced type system in a real-world usable language, check out [Idris](http://docs.idris-lang.org/en/latest/tutorial/introduction.html). It is a language with dependent types, meaning types are normal values, and functions can take and return them. It has some mind-bending features that will have impact for decades to come. The language itself is mostly ready for prime time, but there are not many libraries available yet.

**What's missing?**
- A functional database. [Datomic](http://www.datomic.com/) fits the bill, but it's not open source.
- A backend language that can be recommended without reservations.
