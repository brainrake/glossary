(* Our Language, MinL *)

datatype Sum = Left of Val | Right of Val

and      Val = Error of string
             | Closure of (Val -> Val) (* pass env through host language closure *)
             | Sum of Sum
             | Product of (Val * Val)
             | Unit
             | Bool of bool
             | Int of int
             | Str of string

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
  | Nil => Error ("Name " ^ name ^ " not found")

fun eval (env: Env) (exp : Exp) : Val = case exp of
    Lambda (argname, exp) =>
      Closure (fn argval =>
        let val newenv = (argname, argval) :: env (* use host language closure *)
        in eval newenv exp end)
  | Apply (funexp, exp) =>
      let val closure = eval env funexp
          val argval = eval env exp
      in case closure of Closure f => f argval
                       | _ => Error ("can only apply closures") end
  | Var name => lookup env name
  | If (pred, exp1, exp2) => (
      case eval env pred of Bool true => eval env exp1
                          | Bool false => eval env exp2
                          | _ => Error "predicate must be boolean")
  | Let (name, exp1, exp2) =>
      let val newenv = (name, eval env exp1) :: env
      in eval newenv exp2 end
  | Literal value => value

fun show (v : Val) = case v of
     Error s => "Error: " ^ s
   | Closure f => "<fn>"
   | Sum sum => (case sum of
       (Left v) => "(Left " ^ show v ^ ")"
     | (Right v) => "(Right " ^ show v ^ ")")
   | Product (fst, snd) => "(" ^ show fst ^ ", " ^ show snd ^ ")"
   | Unit => "()"
   | Bool b => if b then "True" else "False"
   | Int i => Int.toString i
   | Str s => s


(* MinL Standard Environment *)

val plus = Closure (fn x => Closure (fn y =>
  case (x, y) of (Int vx, Int vy) => Int (vx + vy)
               | (_, _) => Error "arguments to plus must be Ints"))

val stdenv = [("plus", plus)]


(* parser *)

fun parse_one ts =
  if null ts
  then (Literal (Error "empty"), ts)
  else if (hd ts = "in") orelse (hd ts = "=>") orelse (hd ts = ")")
  then (Literal (Error ("expected expression, found " ^ hd ts)), ts)
  else if hd ts = "("
  then let val (exp, rest) = parse (tl ts)
       in (exp, tl rest) end
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
  then (Literal (Int (valOf (Int.fromString (hd ts)))), tl ts)
  else if Char.isAlpha (hd (explode (hd ts)))
  then (Var (hd ts), tl ts)
  else (Literal (Error ("unknown token: " ^ hd ts)), ts)
  (* TODO: if, literals *)

and parse_ap exp1 ts =
  let val (exp2, rest2) = parse_one ts
  in case exp2 of
       Literal (Error err) => (exp1, ts)
     | _ => parse_ap (Apply (exp1, exp2)) rest2 end

and parse ts =
  let val (exp, rest) = parse_one ts
  in parse_ap exp rest end

fun tokenize str =
  String.tokens (fn c => c = #" " orelse c = #"\n") str

fun compileStr str = #1 (parse (tokenize str))

fun compileFile filename =
  compileStr (TextIO.inputAll (TextIO.openIn filename))

val args = CommandLine.arguments()
val filename = if null args then "test.minl" else hd args

val exp = compileFile filename

val result = eval stdenv exp

val _ = print ((show result) ^ "\n")
val _ = OS.Process.exit(OS.Process.success)
