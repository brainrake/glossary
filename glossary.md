# Language

eg. ML, Lambda Calculus, RegExp, Python

Collection of language constructs (which consist of syntax and semantics).
Defines the set of possible strings (programs, code) in the language, and how to combine smaller (parts of) programs into larger ones.

We define language constructs like this:


**Syntax**: *construct* := ... [EBNF](https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_Form) ...

**Statics**: premises ⊢ conclusions

**Dynamics**: `eval (construct (args...)) = ...`


## Language Constructs - Syntax

How to write it down.


## Language Constructs - Semantics

What it means (consists of static and dynamic semantics).


### Static Semantics (Typechecking Rules, Statics)

How to get (check) its type, and how it affects the static environment.


### Dynamic Semantics (Evaluation Rules, Dynamics)

How to get its value, and how it affects the dynamic environment.


## Names (Variables)

We bind things to names so we can refer to them using names instead of repeating the things.


### Binding

The mapping from a name to the thing it refers to.

To "bind something to a name" means "to attach a name to something". Like putting a name tag on it.

We usually bind expressions (including functions) and their types to names so we can use them later by name, without having to type them again and again.

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

Types are used to express and enforce relationships between data and operations, to ensure that programs can be run without getting stuck, throwing up, or going wrong.


## Function

An expression with "free" (unbound) names.
The names will be bound during evaluation, at the point of use (function application).


## Closure

A function bundled together with the environment at the point where the function is defined.

In this document, we will use `make_closure (env, argname, expression)` to denote the above in dynamics.


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


