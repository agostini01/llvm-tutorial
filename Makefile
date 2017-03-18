LDFLAGS  = -L/usr/local/opt/llvm/lib
CPPFLAGS = -I/usr/local/opt/llvm/include -std=c++11 -O3

test: main
	./main

