COMPILER LAB EXAM CODE - SIMPLE HUMAN-STYLE VERSION
===================================================

Folders:
  1. while_loop
  2. if_else
  3. simple_assignment

Each folder has:
  lexer.l      - Lex token rules
  parser.y     - YACC grammar and TAC semantic actions
  sample.in    - Example input
  Makefile     - Build commands
  optimizer.c  - Simple constant-folding optimizer
  backend.c    - Simple TAC-to-pseudo-assembly converter

Requirements on Ubuntu/Linux:
  sudo apt install flex bison gcc

The code is formatted with braces on separate lines and straightforward names.

Build and run, for example:
  cd while_loop
  make
  ./compiler < sample.in
  cat tac.txt
  ./optimizer tac.txt optimized.txt
  ./backend optimized.txt target.txt
  cat optimized.txt
  cat target.txt

Traditional Lex/YACC commands, if compiling manually:
  yacc -d parser.y
  lex lexer.l
  gcc y.tab.c lex.yy.c -o compiler

IMPORTANT:
- Use a semicolon after each assignment.
- This is a small lab grammar, not a full C compiler.
- The while and if-else grammars handle one outer control statement.
- Target code is illustrative pseudo-assembly.
