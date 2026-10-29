WHILE_LOOP
==========

Build:
  make

Run parser and generate TAC:
  ./compiler < sample.in

View TAC:
  cat tac.txt

Optimize TAC:
  ./optimizer tac.txt optimized.txt
  cat optimized.txt

Generate target code:
  ./backend optimized.txt target.txt
  cat target.txt

Manual Lex/YACC build:
  yacc -d parser.y
  lex lexer.l
  gcc y.tab.c lex.yy.c -o compiler
