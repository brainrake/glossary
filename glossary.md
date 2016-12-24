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
