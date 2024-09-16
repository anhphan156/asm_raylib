all: main.o
	gcc -o out main.o -z noexecstack -nostartfiles -lraylib -lpthread

main.o: src/main.s
	as -g src/main.s -o main.o

test:
	gcc -o test src/main.c -lraylib -lm
	objdump -M intel -C --disassemble=main test

run:
	./out

clean:
	rm main.o out test
