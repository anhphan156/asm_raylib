all: main.o
	gcc -o out main.o -z noexecstack -nostartfiles -lraylib -lpthread

main.o: src/main.s
	as src/main.s -o main.o

run:
	./out

clean:
	rm main.o out
