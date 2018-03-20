all:test_fopen

test_fopen:test_fopen.s
	as --32 test_fopen.s -o test_fopen.o
	gcc -m32 test_fopen.o -o test_fopen

clean:
	rm -vf *.o test_fopen
