import std.stdio;

void main() {
  import pegged.grammar;

  mixin(grammar(`
    AOQ:
      Expr < Variable / IntegerLiteral / FloatLiteral / "(" Operator Expr+ ")"

      Sign < "-"
      Integer < digit+
      IntegerLiteral < Sign? Integer
      FloatLiteral < Sign? Integer "." Integer "f"

      Comment < "//" (!endOfLine .)* endOfLine

      Variable <- (alpha / Alpha / "_") (alpha / Alpha / "_" / digit)*

      Operator < "+" / "-" / "*" / "/" / PredefinedFunctions

      PredefinedFunctions < "set" / "lambda"
  `));

  auto parse_tree = AOQ("(set x (lambda (t y) (+ t y t y)))");
  writeln(parse_tree);
}
