import std.stdio;
import pegged.grammar;

mixin(grammar(`
  AOQ:
    SExpr < "(" (Atom/SExpr)+ ")"

    Sign < "-"
    Integer <- digit+
    IntegerL <- Sign? Integer
    FloatL <- IntegerL "." Integer "f"
    List < "'(" (Atom / SExpr / List)* ")"

    Atom <- FloatL / IntegerL / Variable / List / Operator

    Comment < "//" (!endOfLine .)* endOfLine

    Variable <- (alpha / Alpha / Operator)+
    Operator < "+" / "-" / "*" / "/" / "<" / ">" / ">=" / "<=" / "=" / "_"
`));

struct Atom {
  string val;
}

Atom Eval ( ParseTree expr ) {
  import std.algorithm, std.array;
  foreach ( ref atom; expr.children ) {
    switch ( atom.name ) {
      default:
        assert(false, "Unknown atom name: " ~ atom.name);
      case "AOQ.Atom":
        return Eval(atom.children[0]);
      case "AOQ.Variable":
        return Atom(atom.input);
      case "AOQ.IntegerL":
        return Atom(atom.input);
      case "AOQ.FloatL":
        return Atom(atom.input);
      case "AOQ.SExpr":
        Atom func = expr.children[0].Eval;
        writeln("CHILD: ", expr.children[0].input);
        auto args = expr.children[1 .. $].map!(Eval).array;
        writeln("FUNC: ", func, " --- ", args);
      break;
    }
  }
  return Atom("");
}

auto Evaluate ( string str_expression ) {
  auto expression = AOQ(str_expression);
  writeln(expression);
  writeln("---");
  expression.Eval;
  return "";
}

void main() {
  "(+ 1 2)".Evaluate.writeln;
  // "(+ '(1 2.0f) somevar)".Evaluate.writeln;
}
