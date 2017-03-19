LLVM_CONFIG = /usr/local/opt/llvm/bin/llvm-config
CPPFLAGS = -g -O3 `$(LLVM_CONFIG) --cxxflags --ldflags --system-libs --libs core`

default: main

test: main
	./main

clean:
	rm main
