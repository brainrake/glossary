# Language Constructs in a subset of ML

Here are some of the basic language constructs, simplified from ML. These constructs appear (with more or less similar syntax and semantics) in the vast majority of programming languages.


## Expression

Expressions are either literal values, variables, or made up of smaller expressions.

The only thing that can be done with an expression is to evaluate it (in an environment), and the result is a value (of a certain type).


**Syntax**: *exp* := *lambda* | *apply* | *infixapply* | *var* | *if* | *let* | *lit* | *list*



### Function Defintion (Lambda Abstraction, Lambda)

eg. `fn x => x + 1`

A Functions is an expression with *free* (unbound) names (like "holes"). The expression (function body) can only be evaluated after binding the argument name ("filling the hole").

We'll also need the bindings that are used in the function but defined outside it, so we pack the function and environment together and call it a **function closure**, which is the runtime representation of a function.

Closures can be named, used as arguments, and most importantly, evaluated by applying to arguments, in order to produce a value.

**Syntax**: *lambda* := `fn` *argname* `=>` *exp*

where *argname* is a name, *exp* is an expression

**Statics**: env_extend (*argname* : *t1); *exp* : t2 ⊢ *lambda* : *t1* -> *t2*

**Dynamics**: `eval (lambda (argname, exp)) = make_closure (env, argname, e)`


### Function Application (Lambda Elimination, Apply, Function Call)

eg. `length "hello"`

Function application "fills the hole" in a closure (binds the argument name to the argument value), and evaluates the expression (function body).

So to evaluate a function application, that is "to apply the function to the argument", means the following:
Evaluate the argument, then evaluate the function body in the environment at its definition extended by binding the argument value to the argument name.

**Syntax**: *apply* := *f* *exp*

where *f* and *exp* are expressions

**Static**: *f* : *t1* -> *t2*; *exp* : *t1*  ⊢  *f* *exp* : *t2*

**Dynamics** : ??


### Infix Operator Application

eg. `2 + 3`

Apply the operator to the arguments.

An operator is a function with a special name (usually symbols like `+` `*` `^` `/` , written between the two arguments ("infix") instead of before ("prefix").

**Syntax**: *infixapply* := *exp1* *op* *exp2*

where *exp1*, *exp2* are expressions, *op* is an operator

**Statics**: *op* : *t1* * *t2* -> *t3*; *exp1* : *t1* ; *exp2* : *t2*  ⊢  *exp1* *op* *exp2* : *t3*

**Dynamics**: `eval (infixapply (exp1, op exp2)) = op (eval *exp1*, eval *exp2*)`


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

**Syntax** : *if* := `if` *pred* `then` *exp1* `else` *exp2*

where *pred*, *exp1*, *exp2* are expressions

**Statics** : *pred* : bool; *exp1* : *t*; *exp2* : *t*  ⊢ if (*pred*, *exp1*, *exp2*) : *t*

**Dynamics** : `eval (if (pred, exp1, exp2)) = if (eval pred == true) then eval exp1 else eval exp2`


### Let Expression

eg. `let x = (39 + 1) in x + 2 end`

Evaluate the expression in an environment extended with some bindings.

**Syntax**: *let* := `let` *bindings* `in` *exp* `end`  -- *bindings* is a list of bindings, *exp* is an expression)

**Statics**: *exp* is typechecked in an environment extended with *bindings*

**Dynamics**: *exp* is evaluated in an environment extended with *bindings*


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

**Syntax** : *litlist* := `[` ( *exp1* ( `,` *exp2* ... )? )? `]`

where *exp1*, *exp2*, ... are expressions

**Statics**: *exp1* : *t*; *exp2* : *t*; ...  ⊢  [exp1, exp2, ...] : list of *t*

**Dynamic**: `eval (litlist (exp1, exp2, ...)) = Cons (eval *exp1*, Cons (eval *exp2* ... , nil ...)))`


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

**Syntax**: *valbinding* := `val` *valname* `=` *exp*

where *valname* is an identifier, *exp* is an expression

**Statics**: *exp* : *t* ⊢ env_extend (*valname* : *t*)

**Dynamics**: `eval (valbining (valname, e)) = env_extend (valname, eval e)`


### Function Binding

`fun f x = x + 1`

Bind a function closure to a name.

**Syntax**: *funbinding* ='fun' *funname* *argname* '=' *exp*

where *funname* and *argname* are identifiers, and *exp* is an expression

**Statics**: env_extend (*argname* : *t1*); *exp* : *t2*  ⊢ env_extend (*funname* : *t1* -> *t2*)

**Dynamics** : `eval (funbinding (funname, argname, exp)) = env_extend (funname, make_closure (env, argname, exp))`


## List of Bindings

**Syntax**: *bindings* := *binding* (`\n` | `;`) *bindings*

where *binding* is a binding, and *bindings* is a list of bindings

**Statics**: the remaining *bindings* are evaluated in an environment extended with *binding*

**Dynamics**: the remaining *bindings* are evaluated in an environment extended with *binding*


## Program (aka Top Level)

A program (at the top level of an `.sml` file) is a list of bindings.
