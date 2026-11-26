# PasKenzie Compiler (lexical and syntax analyzer in C)

Front end of a compiler for **PasKenzie**, a teaching language inspired by Pascal, written in plain C. Built for the Compilers course at Mackenzie Presbyterian University, as a pair project.

The program reads a source file, recognizes tokens one at a time and validates the program structure against the language grammar. If everything is correct, it reports how many lines it analyzed. If not, it reports the **error type (lexical or syntax), the line number, and what was expected**.

> Scope: this repository covers **lexical and syntax analysis**. There is no semantic analysis or code generation.

> Note: source comments and diagnostic messages are in Portuguese, the language of the course.

## What it does

**Lexical analyzer** (`obter_atomo`)
- Skips whitespace, tabs and newlines while counting lines.
- Recognizes identifiers (up to 15 characters), reserved words, integer constants, `char` constants (`'a'`) and comments `(* ... *)`.
- Integer constants accept a decimal exponent with `d` (for example, `5d2` is 500).
- Recognizes operators and symbols: `+ - * ; , . ( ) = := < > <= >= <>`.
- Lexical errors: unknown symbol, identifier longer than 15 characters, malformed `char`, unterminated comment.

**Syntax analyzer** (recursive descent, one function per grammar rule)
- No backtracking: a single lookahead token decides which rule to follow.
- Comments are accepted anywhere between tokens.
- An empty statement is accepted before `;`, `end` or `else` (for example, `x := 1;` right before `end`).
- Syntax errors report the line and the expected versus found token.

## Grammar

```
<program>              ::= program identifier ';' <block> '.'
<block>                ::= <variable_declaration_part> <statement_part>
<variable_declaration_part> ::= [ var <variable_declaration> ';' { <variable_declaration> ';' } ]
<variable_declaration> ::= identifier { ',' identifier } ':' <type>
<type>                 ::= char | integer | boolean
<statement_part>       ::= begin <statement> { ';' <statement> } end
<statement>            ::= <assignment> | <read> | <write> | <if> | <while> | <statement_part>
<assignment>           ::= identifier ':=' <expression>
<read>                 ::= read '(' identifier { ',' identifier } ')'
<write>                ::= write '(' identifier { ',' identifier } ')'
<if>                   ::= if <expression> then <statement> [ else <statement> ]
<while>                ::= while <expression> do <statement>
<expression>           ::= <simple_expression> [ <relational_operator> <simple_expression> ]
<relational_operator>  ::= '=' | '<>' | '<' | '<=' | '>' | '>=' | or | and
<simple_expression>    ::= <term> { ('+' | '-') <term> }
<term>                 ::= <factor> { ('*' | div) <factor> }
<factor>               ::= identifier | constint | constchar | true | false | '(' <expression> ')' | not <factor>
```

## Build and run

```bash
gcc -Wall -Wno-unused-result -g -Og compilador.c -o compilador -lm
./compilador examples/valido.pas
```

## Examples

`examples/valido.pas`: factorial with `while` and `if/else`.

```
# 1:program
# 1:identifier : fatorial
# 1:ponto_virgula
# 2:comentario
# 3:var
...
# 16:end
# 16:ponto

16 linhas analisadas, programa sintaticamente correto
```

`examples/erro_sintatico.pas` (`x := 5 +;`):

```
# 4:mais
# 4:erro sintatico, fator invalido. Esperado [identifier, constint, '(', ...], mas encontrado [;]
```

`examples/erro_lexico.pas` (`x := 5 @ 3`):

```
# 4: erro lexico, simbolo desconhecido: @
```

## Layout

```
compilador.c        # lexer + parser
examples/           # valid and invalid programs (lexical, syntax, invalid statement)
```

## Known limitations

- No symbol table or type checking: `ok := 5` is accepted even if `ok` is a `boolean`.
- `read` and `write` accept only identifiers, as in the course grammar.
- A very large `constint` can overflow `int` without a warning.

## Authors

- [Diego Sugai](https://github.com/DiegoSugai)
- Leonardo Moreira dos Santos
