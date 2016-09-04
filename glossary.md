# Language

eg. ML, Lambda Calculus, RegExp, Python

Collection of language constructs (which consist of syntax and semantics).
Defines the set of possible strings (programs, code) in the language, and how to combine smaller (parts of) programs into larger ones.

We define language constructs like this:


**Syntax**: (see EBNF)

**Statics**: premises ⊢ conclusions

**Dynamics**: ...


## Language Constructs - Syntax

How to write it down.


## Language Constructs - Semantics

What it means (consists of static and dynamic semantics).


### Static Semantics

How to get (check) its type, and how it affects the static environment.


### Dynamic Semantics (Evaluation Rules)

How to get its value, and how it affects the dynamic environment.


## Names

We bind things to names so we can refer to them using names instead of repeating the things.


### Binding

The mapping from a name to the thing it refers to.

To "bind something to a name" means "to attach a name to something". Like putting a name tag on it.

We usually bind expressions (including functions) and their types to names so we can use them later by name, without having to type them again and again.

A binding, aka variable definition, is used to extend a (static and dynamic) environment, making the name available within the binding's scope.
Later, when we use the name, (static) type and (dynamic) value bound to the name can be looked up in the respective environment.


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

An expression with "free" (unbound) names, to be bound later, at the point of use (function application).



# ML Language Constructs

Here are some of the basic language constructs as used in ML. These constructs appear (with more or less similar syntax and semantics) in the vast majority of programming languages.


## Expression

Expressions are either literal values are made up of smaller expressions.

The only thing that can be done with an expression is to evaluate it (in an environment), and the result is a value (of a certain type).

The different types of expressions in ML are the following:


### Literal

Primitive values, written out verbatim in the program.


#### Integer Literal

eg. `42`

A whole number.

**Syntax**: `~?[0-9]+`

**Statics**: ⊢ int

**Dynamics**: value is the integer denoted by the decimal digits


#### String Literal

e.g. `"Hello, World!"`

A piece of text.

**Syntax**: `".*"`

**Statics**: ⊢ string

**Dynamics**: value is the string denoted by the characters between quotes

Note: it's a bit more complex, escape sequences are supported


#### List Literal

e.g. `[1, 2, 3]`, `["He", "llo"]`, `[]`

**Syntax** : `[` ( *e1* ( `,` *e2* ... )? )? `]` -- *e1*, *e2*, ... *en* are expressions

**Statics**: *e1*:*t*; *e2*:*t*; ...  ⊢  [e1, e2, ...] : list of *t*

**Dynamic**: Cons (eval *e1*, Cons (eval *e2*, ... Cons (eval *en*, nil)))


### Variable (Name)

e.g. `x`, `length`, `append`, `my_var`, `Cons`

A name to be looked up in the environment.

**Syntax** : *varname*  -- *varname* is an identifier

**Statics**: get `varname`'s type from env

**Dynamics** : get `varname`'s value from env


### Conditional

e.g. `if x = 0 then "zero" else "nonzero"`

Use a boolean value to choose one of two expressions to evaluate.

**Syntax** : `if` *pred* `then` *e1* `else` *e2*  -- *pred*, *e1*, *e2* are expressions

**Statics** : *pred* : bool; *e1* : *t*; *e2* : *t*  ⊢  (if *pred* then *e1* else *e2*) : *t*

**Dynamics** : if *pred* evaluates to `true` then evaluate *e1*, otherwise evaluate *e2*


### Function Application

eg. `length "hello"`

"Apply the function to the argument" means the following:
Evaluate the argument, then evaluate the function body in the environment at its definition extended by binding the argument value to the argument name.

**Syntax**: *f* *e* -- *f* and *e* are expressions

**Static**: *f* : *t1* -> *t2*; *e* : *t1*  ⊢  *f* *e* : *t2*

**Dynamics** : ??


### Infix Operator Application

eg. `2 + 3`

Apply the operator to the operands.

**Syntax**: *e1* *op* *e2* -- *e1*, *e2* are expressions, *op* is an operator

**Statics**: *op* : *t1* * *t2* -> *t3*; *e1* : *t1* ; *e2* : *t2*  ⊢  *e1* *op* *e2* : *t3*

**Dynamics**: (*op*) (eval *e1*, eval *e2*)


### Let Expression

eg. `let x = (39 + 1) in x + 2 end`

Evaluate the expression in an environment extended with some bindings.

**Syntax**: `let` *bindings* `in` *e* `end`  -- *bindings* is a list of bindings, *e* is an expression)

**Statics**: *e* is typechecked in an environment extended with *bindings*

**Dynamics**: *e* is evaluated in an environment extended with *bindings*


## Binding

ML has value and function bindings.


### Identifier (syntax only)

eg. `x`, `length`, `my_var`, `list`, `SOME`, `Option`

Syntactic names for stuff (variables, functions, types, modules, etc), usually alphanumeric.

**Syntax** : `[A-Za-z_][A-Za-z0-9_]*`


### Value Binding

`val x = 42`

Bind an expression to a name.

**Syntax**: `val` *valname* `=` *e*  --  *valname* is an identifier, *e* is an expression

**Statics**: *e* : *t* ⊢ *valname* : *t*

**Dynamics**: the env after the binding is extended with *valname* = eval *e*


### Function Binding

`fun f x = x + 1`

Bind a function to a name.

**Syntax**: 'fun' *funname* *argname* '=' *e* -- *funname* and *argname* are identifiers, *e* is an expression

**Statics**: *x* : *t1*, *e* : *t2*  ⊢  *funname* : *t1* -> *t2*

**Dynamics** : - the env after the binding is extended with *funname* = `<fn>`


## Top Level

The Top Level (at the root of an SML file) is a list of bindings.

**Syntax**: bindings

**Statics**: each binding is added to the environment

**Dynamics**: each binding is added to the environment
