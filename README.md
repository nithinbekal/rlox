# Rlox

Ruby implementation of the Lox programming language from the book [Crafting Interpreters](https://craftinginterpreters.com/) by Robert Nystrom.

## Reading the code

- [Scanner](lib/rlox/scanner.rb) takes the source code and returns a list of tokens, which are [Token](lib/rlox/token.rb) objects.
- [Parser](lib/rlox/parser.rb) takes the tokens and builds an abstract syntax tree (AST) using recursive descent parsing.
- [Expr](lib/rlox/expr.rb) classes represent AST nodes for expressions (Binary, Unary, Literal, Grouping, etc).

Other code:

- [AstPrinter](lib/rlox/ast_printer.rb) implements the Visitor pattern to convert AST nodes to string representations.
