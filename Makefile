#COPT=-Wall -g -c -O3 -std=c++11 -fPIC -fprofile-arcs -ftest-coverage
COPT=-Wall -g -c -O3 -std=c++11 -fPIC
#COPT=-Wall -g -pg -c -std=c++11

all: MK85 libMK85.so API_example1

MK85: lex.yy.o y.tab.o MK85.o utils.o picosat.o
	#g++ MK85.o y.tab.o lex.yy.o utils.o -L/usr/local/lib/ -g -pg -o MK85
	#g++ -fprofile-arcs -ftest-coverage MK85.o y.tab.o lex.yy.o utils.o picosat.o -L/usr/local/lib/ -g -o MK85
	g++ MK85.o y.tab.o lex.yy.o utils.o picosat.o -L/usr/local/lib/ -g -o MK85

libMK85.so: MK85.o utils.o picosat.o
	#g++ MK85.o y.tab.o lex.yy.o utils.o -L/usr/local/lib/ -g -pg -o MK85
	#g++ -fprofile-arcs -ftest-coverage -shared MK85.o y.tab.o lex.yy.o utils.o picosat.o -L/usr/local/lib/ -g -o libMK85.so
	g++ -shared MK85.o y.tab.o lex.yy.o utils.o picosat.o -L/usr/local/lib/ -g -o libMK85.so

picosat.o: picosat/picosat.h picosat/picosat.c
	gcc $(COPT) picosat/picosat.c
	#gcc $(COPT) -DNDEBUG picosat/picosat.c

utils.o: utils.cc utils.hh
	g++ $(COPT) utils.cc

lex.yy.c: smt2.l y.tab.h
	flex smt2.l
	#flex -d smt2.l

lex.yy.o: lex.yy.c
	g++ $(COPT) -DYYDEBUG=1 lex.yy.c

y.tab.h y.tab.c: smt2.yy
	bison -y -d -t smt2.yy

y.tab.o: y.tab.c y.tab.h
	g++ $(COPT) -DYYDEBUG=1 y.tab.c

MK85.o: MK85.cc
	g++ $(COPT) MK85.cc

API_example1: API_example1.c
	gcc API_example1.c -o API_example1 libMK85.so 

install:
	mkdir -p /usr/lib/python2.7/dist-packages/MK85
	cp MK85.py /usr/lib/python2.7/dist-packages/MK85
	cp libMK85.so /usr/lib/python2.7/dist-packages/MK85
	cp __init__.py /usr/lib/python2.7/dist-packages/MK85
	#touch /usr/lib/python2.7/dist-packages/MK85/__init__.py
 
clean:
	rm *.o
	rm lex.yy.c
	rm y.tab.c
	rm y.tab.h

