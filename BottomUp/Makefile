CC = gcc

TARGET = execf

all: $(TARGET)

$(TARGET): lex.yy.c bison_bottom_up.tab.c
	$(CC) -o $(TARGET) lex.yy.c bison_bottom_up.tab.c

lex.yy.c: mylex.lex
	flex mylex.lex

bison_bottom_up.tab.c bison_bottom_up.tab.h: bison_bottom_up.y
	bison -d bison_bottom_up.y

clean:
	rm -f $(TARGET) lex.yy.c bison_bottom_up.tab.* bison_bottom_up.output
