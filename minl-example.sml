val _ = use "minl.sml"

(* An Example Expression *)

(* an expression in ML*)
val result_ml  =
  let val twice = fn x => plus_ml x x
  in twice 3 end

(* the same expression in MinL *)
val exp =
  Let ("twice", (Lambda ("x", (Apply (Apply (Var "plus", Var "x"), Var "x")))),
       (Apply (Var "twice", Literal (ValInt 3))) (*end*))

(* evaluate the MinL expression *)
val result = eval stdenv exp
