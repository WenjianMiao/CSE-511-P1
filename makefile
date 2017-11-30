CC=gcc 
CFLAGS=-Wall -g -I $(INC)
SYNCOBJ=pe_sync.o
EXTLIBS=-lpthread -lrt
CONF=config
SRC=src
INC=inc
#LEX=flex -i -I $(SRC) $(INC)  //This is the flex that use ./config/path.lex to get ./src/path.lex.c . Because we have got that, we don't need that.
#YACC=bison -d -y -v           //This is the bison that use ./config/path.y to get ./src/path.yacc.c . Because we have got that, we don't need that.

all: readers_writers_test one_slot_buffer_test child_care_test child_care_bonus_test

part1: readers_writers_test one_slot_buffer_test
part2: child_care_test child_care_bonus_test

clean:
	rm -f parser.o lexer.o support.o path_exp.txt
	rm -f *.o *.bin 

.PHONY: all clean

#$(SRC)/path.lex.c: $(CONF)/path.lex
#	$(LEX) -o $@ $<

#$(SRC)/path.yacc.c $(SRC)/path.yacc.h: $(CONF)/path.y
#	$(YACC) -b path -o $(SRC)/path.yacc.c $<

lexer.o: $(SRC)/path.lex.c
	$(CC) $(CFLAGS) -c -o $@ $<

parser.o: $(SRC)/path.yacc.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.o: %.c %.h
	$(CC) $(CFLAGS) -c -o $@ $<

support.o: $(SRC)/support.c
	$(CC) $(CFLAGS) -c -o $@ $<



%_test: %_test.c %.o $(SYNCOBJ) parser.o lexer.o support.o
	$(CC) $(CFLAGS) $? -o $@.bin $(EXTLIBS)

