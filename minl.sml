(*
Our Language MinL
*)

datatype Val = ValBool of bool
             | ValInt of int
             | ValStr of string
             | Closure of (Val -> Val) (* pass env through host language closure *)
             | Error

datatype Exp = Lambda of (string * Exp)
             | Apply of (Exp * Exp)
             | Var of string
             | If of (Exp * Exp * Exp)
             | Let of (string * Exp * Exp)
             | Literal of Val

type Env = (string * Val) list

fun lookup (env : Env) (name : string) : Val = case env of
    (name', value) :: env' => if name = name'
                              then value
                              else lookup env' name
  | Nil => Error

fun eval (env: Env) (exp : Exp) : Val = case exp of
    Lambda (argname, exp) =>
      Closure (fn argval =>
        let val newenv = (argname, argval) :: env (* use host language closure *)
        in eval newenv exp end)
  | Apply (funexp, exp) =>
      let val closure = eval env funexp
          val argval = eval env exp
      in case closure of Closure f => f argval
                       | _ => Error end
  | Var name => lookup env name
  | If (pred, exp1, exp2) => (
      case eval env pred of ValBool true => eval env exp1
                          | ValBool false => eval env exp2
                          | _ => Error)
  | Let (name, exp1, exp2) =>
      let val newenv = (name, eval env exp1) :: env
      in eval newenv exp2 end
  | Literal value => value


(*
the language's standard environment
*)

fun plus_ml x y = x + y

val plus = Closure (fn x => Closure (fn y =>
  case (x, y) of (ValInt vx, ValInt vy) => ValInt (vx + vy)
               | (_, _) => Error))

val stdenv = [("plus", plus)]

(*
an example expression
*)

(* the expression in ML *)
val result_ml  =
  let val twice = fn x => plus_ml x x
  in twice 3 end

(* the same expression in MinL *)
val exp =
  Let ((*val*) "twice", (*=*) (Lambda ("x", (Apply (Apply (Var "plus", Var "x"), Var "x")))),
       (*in*) (Apply (Var "twice", Literal (ValInt 3))) (*end*))

(* evaluate the expression in MinL *)
val result = eval stdenv exp


(*
parser
*)

fun parse_one ts =
  if null ts orelse (hd ts = "in")
  then (Literal Error, ts)
  else if hd ts = "let"
  then let val name = hd (tl ts)
           val (exp1, rest) = parse (tl (tl (tl ts)))
           val (exp2, rest) = parse (tl rest)
       in (Let (name, exp1, exp2), rest) end
  else if (hd ts) = "fn"
  then let val argname = hd (tl ts)
           val (exp, rest) = parse (tl (tl (tl ts)))
       in (Lambda (argname, exp), rest) end
  else if isSome (Int.fromString (hd ts))
  then (Literal (ValInt (valOf (Int.fromString (hd ts)))), tl ts)
  else if Char.isAlpha (hd (explode (hd ts)))
  then (Var (hd ts), tl ts)
  else (Literal Error, ts)

and parse_ap exp1 ts =
  let val (exp2, rest2) = parse_one ts
  in case exp2 of
       Literal Error => (exp1, ts)
     | _ => parse_ap (Apply (exp1, exp2)) rest2 end

and parse ts =
  let val (exp, rest) = parse_one ts
  in parse_ap exp rest end

fun tokenize str = String.tokens (fn c => c = #" ") str

fun compile str = #1 (parse (tokenize str))

val exp' = compile "let twice = fn x => plus x x in twice 3"

val result' = eval stdenv exp'
