all:sat_color

sat_color:sat_color.s
	as --32 sat_color.s -o sat_color.o
	gcc -m32 -o $@ sat_color.o -lncurses 

clean:
	rm -vf *.o sat_color
