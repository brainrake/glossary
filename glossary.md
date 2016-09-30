# Language

eg. ML, Lambda Calculus, RegExp, Python, XML

A Language is defined through a set of language constructs that specify how to write down strings (programs) in the language, and what they mean. Larger (pieces) of language strings

The set of possible correct strings (programs, code) in the language are all the combinations of language

## Programming Language

A language used to express data (information) and computation (transformation of information), usually meant to be run on a computer.

TODO: Turing


## Language Construct

Consists of Syntax and Semantics.

We define language constructs like this:

**Syntax**: *construct* := ... [EBNF](https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_Form) ...

**Statics**: premises ⊢ conclusions

**Dynamics**: `eval (construct (args...)) = ...`


### Syntax

How to write a construct down.


### Semantics

What a construct means (consists of static and dynamic semantics).


###$ Static Semantics (Typechecking Rules, Statics)

How to get (check) a construct's type, and how it affects the static environment.


#### Dynamic Semantics (Evaluation Rules, Dynamics)

How to get a construct's value, and how it affects the dynamic environment.


## Names (Variables)

We bind things to names so we can refer to them using names instead of repeating the things.


### Binding

The mapping from a name to the thing it refers to.

To "bind something to a name" means "to attach a name to something". Like putting a post-it note with a name on it.

We usually bind values (including functions) and their types to names so we can use them later by name, without having to type them again and again.

A binding (a variable definition) is used to extend a (static and dynamic) environment.
Later, when we use the name, the (static) type and (dynamic) value bound to the name can be looked up in the environment.

In this document, we will use `env_extend (name : type)`, `env_extend (name, value)` and `env_lookup name` to denote operations on the environment in semantics.


### Scope

The region of code where a certain binding is "live" (so the name is available).


### Environment

The set of bindings (so names) available at a certain point in code.


#### Static Environment

Mapping from names to types, used in typechecking (and compilation).


#### Dynamic Environment

Mapping from names to values, used in evaluation (aka during runtime).


## Expression

A language construct that can be evaluated (in an environment) to produce a value (of a certain type).


## Value

A piece of runtime data. The result of evaluating an expression.


## Type

Set of values.

Types are used to express and enforce relationships between data and operations, to ensure (through formal logical proof) that programs will run without getting stuck, throwing up, or going wrong.


## Function

An expression bundled together with a name (the "argument").
The argument will be bound during evaluation, at the point of use (function application).


## Closure

A function bundled together with the environment at the point where the function is defined.


## Execution Phases

The point of writing programs is to evaluate (run, execute) them.

Typed languages have a separation of execution phases:

* static phase: typecheck the program according to static semantics
* dynamic phase: evaluate the program according to dynamic semantics

In practice, there are varying extra steps. For compiled languages something like:

* run the compiler
  * parse the source text, turn it into a data structure representing the program in memory
  * typecheck
  * optimize
  * compile (translate to a lower level language)
  * link modules/libraries together
  * output executable file
* run the executable
  * evaluate

For interpreted (dynamic) languages, there is no phase separation since there is usually little or no typechecking and compilation, and the program is evaluated right away.


## R.I.P.

At some point in history we thought these were good ideas and increase the power of a language that includes them.

It turned out they are not good ideas. In their unrestricted forms, they cause undefined behavior (errors, crashes, incorrect results, security breaches) and intractable complexity.

Note: in fact, most programming languages are [Turing complete](https://en.wikipedia.org/wiki/Turing_completeness) so they can express the exact same computations, only differently.


### Dynamic Scope

Functions are evaluated in the environment at the point of use (instead of the environment at the point of definition, as with static scope).

Why we thought it's good: The meaning of a function can change depending on the environment where it is used, making it possible to extend functionality later.

Why it's bad: The meaning of a function can change  depending on the environment where it is used, in uncontrollable ways, allowing unintended (accidental or malicious) changes in the behaviour of a piece of code from the outside, resulting in errors, incorrect results, and security breaches. The function author can do nothing to prevent this.

What to use instead: Static scope. Names always refer to things that are visible at that point in the source text.


### Manual Memory Management


### Mutation (Assignment)

Instead of simple values, variables are like boxes (memory locations) whose contents can be changed any time.

Why we though it's good: We can write efficient programs by reusing memory. (TODO: is that all?)

Why it's bad:
- in general, it is impossible to find out what a name refers to, or where a certain value "came from", that is, which part of the program put it in the box
- the behavior of a piece of code can be changed from the outside in undefined, unintended or malicious ways
- the order of evaluation can change result of computations
- concurrent programs are exceedingly hard to write and require synchronization of the different computations
- all of the above allow undefined behaviour, unintended (accidental or malicious) changes in the behaviour of a piece of code from the outside, incorrect results, and security breaches
- the only way a programmer can completely avoid accidental or malicious mutation is to manually create copies of *every* value before passing it to a function or assigning it to a variable

What to use instead: pure functions, recursion, immutable data, monads. They have the exact same expressive power, and you can *always* trace where any value comes from, and what any name refers to.

Note: After proper optimization, performance and memory use of pure computations with immutable data is very close to that of mutable computations.


### Null


All variables, at any time, can have the value `Null` (in addition to the usual possible values for that type of variable).

Why we thought it's good: not sure...

Why it's bad: Any evaluation can result in a `Null` value, which, when used, will cause runtime errors like `NullPointerException` and incorrect results. The only way to eliminate the possibility of errors caused by `Null` is to check the result of *every* computation and handle the case where it is `Null` appropriately.

What to use instead: Algebraic Data Types describe all possible values of a variable, and can not be `Null`. To encode the possibility of a "missing" or "empty" value, we use an `Option` type, which requires the handling of the empty case, so it can not cause an error.


### Dynamic Type

Instead of checking that functions and values are used in compatible ways _before_ running the program, it is done at runtime.

Why we thought it's good:
- don't have to write down no stinking types
- don't get no stinking type errors during compilation

Why it's bad:
- those stinking types _have_ to be kept track of during runtime, decreasing performance
- those stinking type errors _do_ show up, during evaluation, when functions _do_ receive incompatible values and throw runtime type errors
- _every_ operation can fail
- runtime type errors can not be avoided, only mitigated by manually checking the types of arguments of _all_ functions we define

What to use instead:
- static types give us the strongest guarantee of the absence of runtime errors and exceptions: a formal logical proof
- since we proved the correct use of values and functions, we can throw away the type information during evaluation, increasing performance
- type inference eliminates the need to write down types


### Inheritance

reuse

fail at reuse, safety

What to use instead: polymorphic records (row subtyping).


### Object Oriented Programming

OOP combines inheritance, mutability, (a limited form of) dynamic scope, and (usually) `Null`, to achieve maximum fail.

Why we thought it's good:
- somewhat similar to the intuitive idea of interactions beetween physical objects "in real life"
- the lure of reuse through inheritance of attributes and behavior
- the Actor model

TODO: ^ ?

Why it's bad (in addition to all the above:
- tightly couples data and behavior
- the


What to use instead: polymorphic records, pure functions, immutable data, static types
