# Language

eg. ML, Lambda Calculus, RegExp, Python

Collection of language constructs (which consist of syntax and semantics).
Defines the set of possible strings (programs, code) in the language, and how to combine smaller (parts of) programs into larger ones.

We define language constructs like this:


**Syntax**: *construct* := ... [EBNF](https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_Form) ...

**Statics**: premises ⊢ conclusions

**Dynamics**: `eval (*construct* *args*) = ...`


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


# Language Constructs in a subset of ML

Here are some of the basic language constructs, simplified from ML. These constructs appear (with more or less similar syntax and semantics) in the vast majority of programming languages.


## Expression

Expressions are either literal values, variables, or made up of smaller expressions.

The only thing that can be done with an expression is to evaluate it (in an environment), and the result is a value (of a certain type).


**Syntax**: *e* := *lambda* | *apply* | *infixapply* | *var* | *if* | *let* | *lit* | *list*



### Function Defintion (Lambda Abstraction, Lambda)

eg. `fn x => x + 1`

A Functions is an expression with *free* (unbound) names (like "holes"). The expression (function body) can only be evaluated after binding the argument name ("filling the hole").

We'll also need the bindings that are used in the function but defined outside it, so we pack the function and environment together and call it a **function closure**, which is the runtime representation of a function.

Closures can be named, used as arguments, and most importantly, evaluated by applying to arguments, in order to produce a value.

**Syntax**: *lambda* := `fn` *argname* `=>` *e*

where *argname* is a name, *e* is an expression

**Statics**: env_extend (*argname* : *t1); *e* : t2 ⊢ *lambda* : *t1* -> *t2*

**Dynamics**: `eval (lambda (argname, e)) = make_closure (env, argname, e)`


### Function Application (Lambda Elimination, Apply, Function Call)

eg. `length "hello"`

Function application "fills the hole" in a closure (binds the argument name to the argument value), and evaluates the expression (function body).

So to evaluate a function application, that is "to apply the function to the argument", means the following:
Evaluate the argument, then evaluate the function body in the environment at its definition extended by binding the argument value to the argument name.

**Syntax**: *apply* := *f* *e*

where *f* and *e* are expressions

**Static**: *f* : *t1* -> *t2*; *e* : *t1*  ⊢  *f* *e* : *t2*

**Dynamics** : ??


### Infix Operator Application

eg. `2 + 3`

Apply the operator to the operands.

**Syntax**: *infixapply* := *exp1* *op* *exp2*

where *exp1*, *exp2* are expressions, *op* is an operator

**Statics**: *op* : *t1* * *t2* -> *t3*; *e1* : *t1* ; *e2* : *t2*  ⊢  *e1* *op* *e2* : *t3*

**Dynamics**: `eval (infixapply (op, e1, e2)) = op (eval *e1*, eval *e2*)`


### Variable (Name)

e.g. `x`, `length`, `append`, `my_var`, `Cons`

A name to be looked up in the environment.

**Syntax** : *var* := *varname*

where *varname* is an identifier

**Statics**: ⊢ env_lookup *varname*

**Dynamics** : `eval (var (varname)) = env_lookup varname


### Conditional

e.g. `if x = 0 then "zero" else "nonzero"`

Use a boolean value to choose one of two expressions to evaluate.

**Syntax** : *if* := `if` *pred* `then` *e1* `else` *e2*

where *pred*, *e1*, *e2* are expressions

**Statics** : *pred* : bool; *e1* : *t*; *e2* : *t*  ⊢ if (*pred*, *e1*, *e2*) : *t*

**Dynamics** : `eval (if (pred, e1, e2)) = if (eval pred == true) then eval e1 else eval e2`


### Let Expression

eg. `let x = (39 + 1) in x + 2 end`

Evaluate the expression in an environment extended with some bindings.

**Syntax**: *let* := `let` *bindings* `in` *e* `end`  -- *bindings* is a list of bindings, *e* is an expression)

**Statics**: *e* is typechecked in an environment extended with *bindings*

**Dynamics**: *e* is evaluated in an environment extended with *bindings*


### Literal

Primitive values, written out verbatim in the program.

**Syntax**: *lit* := *litint* | *litstring* | *litlist*

Semantics according to each type of literal.


#### Integer Literal

eg. `42`

A whole number.

**Syntax**: *litint* : = `~?[0-9]+`

**Statics**: ⊢ int

**Dynamics**: `eval (litint chars)= ` the integer denoted by the decimal digits


#### String Literal

e.g. `"Hello, World!"`

A piece of text.

**Syntax**: `litstring` := `".*"`

**Statics**: ⊢ string

**Dynamics**: `eval (litstring chars) = ` the string denoted by the characters between quotes

Note: it's a bit more complex, escape sequences are supported.


#### List Expression

e.g. `[1, 2, 3]`, `["He", "llo"]`, `[]`

**Syntax** : *litlist* := `[` ( *e1* ( `,` *e2* ... )? )? `]`

where *e1*, *e2*, ... are expressions

**Statics**: *e1* : *t*; *e2* : *t*; ...  ⊢  [e1, e2, ...] : list of *t*

**Dynamic**: `eval (litlist (e1, e2, ...)) = Cons (eval *e1*, Cons (eval *e2* ... , nil ...)))`


## Binding

ML has value and function bindings.

**Syntax**: *binding* := *valbinding* | *funbinding*

Semantics are according to each type of binding.


### Identifier (syntax only)

eg. `x`, `length`, `my_var`, `list`, `SOME`, `Option`

An identifier is the syntax for writing down names for stuff (variables, functions, types, modules, etc), usually alphanumeric.

**Syntax** : `[A-Za-z_][A-Za-z0-9_]*`


### Value Binding

`val x = 42`

Bind an expression to a name.

**Syntax**: *valbinding* := `val` *valname* `=` *e*

where *valname* is an identifier, *e* is an expression

**Statics**: *e* : *t* ⊢ env_extend (*valname* : *t*)

**Dynamics**: `eval (valbining (valname, e)) = env_extend (valname, eval e)`


### Function Binding

`fun f x = x + 1`

Bind a function closure to a name.

**Syntax**: *funbinding* ='fun' *funname* *argname* '=' *e*

where *funname* and *argname* are identifiers, and *e* is an expression

**Statics**: env_extend (*argname* : *t1*); *e* : *t2*  ⊢ env_extend (*funname* : *t1* -> *t2*)

**Dynamics** : `eval (funbinding (funname, argname, e)) = env_extend (funname, make_closure (env, argname, e))`


## List of Bindings

**Syntax**: *bindings* := *binding* (`\n` | `;`) *bindings*

where *binding* is a binding, and *bindings* is a list of bindings

**Statics**: the remaining *bindings* are evaluated in an environment extended with *binding*

**Dynamics**: the remaining *bindings* are evaluated in an environment extended with *binding*


## Program (aka Top Level)

A program (at the top level of an `.sml` file) is a list of bindings.
