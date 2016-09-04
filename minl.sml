(*
Our Language MinL
*)

datatype Val = ValBool of bool
             | ValInt of int
             | ValStr of string
             | Closure of (Val -> Val)
             | Error

datatype Exp = Lambda of (string * Exp)
             | Apply of (Exp * Exp)
             | Var of string
             | If of (Exp * Exp * Exp)
             | Let of (string * Exp * Exp)
             | Literal of Val

type Env = (string * Val) list

fun lookup (env : Env, name : string) : Val =
  if name = #1 (hd env)
  then #2 (hd env)
  else lookup (tl env, name)

fun eval (env: Env, exp : Exp) : Val = case exp of
    Lambda (argname, exp) =>
      Closure (fn argval =>
        let val newenv = (argname, argval) :: env
        in eval (newenv, exp) end)
  | Apply (f, exp) =>
      let val closure = eval (env, f)
          val argument = eval (env, exp)
      in case closure of (Closure f) => f argument
                       | _ => Error end
  | Var name => lookup (env, name)
  | If (pred, exp1, exp2) => (
      case eval (env, pred) of
          ValBool true => eval (env, exp1)
        | ValBool false => eval (env, exp2)
        | _ => Error)
  | Let (name, exp1, exp2) =>
      let val newenv = (name, eval (env, exp1)) :: env
      in eval (newenv, exp2) end
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
  Let ("twice", (*=*) (Lambda ("x", (Apply (Apply (Var "plus", Var "x"), Var "x")))),
  (*in*) (Apply (Var "twice", Literal (ValInt 3))) (*end*))

(* evaluate the expression in MinL *)
val result = eval (stdenv, exp)
