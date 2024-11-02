objects = recursive_descent.o lex.yy.o  

recursive_descent.exe: $(objects)
	gcc -o recursive_descent.exe $(objects)


lex.yy.o : lex.yy.c
	gcc -c lex.yy.c

recursive_descent.o : recursive_descent.c
	gcc -c recursive_descent.c
	
lex.yy.c : mylex.lex
	flex mylex.lex
	
clean :

	rm $(objects) lex.yy.c recursive_descent.exe

