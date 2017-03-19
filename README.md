# LLVM Tutorial Notebook

My notebook whilst working through the [LLVM Tutorial](http://llvm.org/docs/tutorial/).

## Progress

1. ~~Kaleidoscope: Tutorial Introduction and the Lexer~~ (2017-03-16)
2. ~~Kaleidoscope: Implementing a Parser and AST~~ (2017-03-18)
3. ~~Kaleidoscope: Code generation to LLVM IR~~ (2017-03-19)
4. Kaleidoscope: Adding JIT and Optimizer Support
5. Kaleidoscope: Extending the Language: Control Flow
6. Kaleidoscope: Extending the Language: User-defined Operators
7. Kaleidoscope: Extending the Language: Mutable Variables
8. Kaleidoscope: Compiling to Object Code
9. Kaleidoscope: Adding Debug Information
10. Kaleidoscope: Conclusion and other useful LLVM tidbits

## Usage

### Setup

```sh
$ brew install llvm
```

### Compile

```sh
$ make
```

### Test

```sh
$ make test
```

### Cleanup

```sh
$ make clean
```

## Notes

### 2017-03-18

At this stage, we’re only linking to LLVM for one utlility function:
`llvm::make_unique`.  This seems like an unnecessary complication but I don’t
know enough about unique pointers in C++ to know what the alternative would be.

Open question: *how do unique pointers and std::move relate to Rust’s borrow-checking mechanisms?*

Here’s what it currently looks like in action:

```
$ make test
c++  -I/usr/local/opt/llvm/include -std=c++11 -O3 -L/usr/local/opt/llvm/lib  main.cpp   -o main
./main
ready> 1 + 2;
Parsed a top-level expr
ready> 1 * (2 + 3);
Parsed a top-level expr
ready> 1 * (2 + );
Error: unknown token when expecting an expression
ready> def foo(a) a + 1;
Parsed a function definition.
ready> foo(a);
Parsed a top-level expr
ready> def foo(a, 1) a + 1;
Error: Expected ')' or ',' in argument list
ready> extern foo();
Parsed an extern
ready> extern foo(a);
Parsed an extern
ready> ^D
Bye!
```

### 2017-03-19

I think it would have been useful for the tutorial to draw attention to the
initialization of `TheContext` in main. In fact, there’s a bit of a discrepency
between the sample code and the inline snippets. Probably a good place to
contribute!

It was super exhilerating to see the IR appear when running the REPL. I
actually whooped!

Here’s what it currently looks like in action:

```
$ make test
c++  -g -O3 `/usr/local/opt/llvm/bin/llvm-config --cxxflags --ldflags --system-libs --libs core`   main.cpp   -o main
./main
ready> 4+5;
Read top-level expression:

define double @__anon_expr() {
entry:
  ret double 9.000000e+00
}

ready> def foo(a, b) a*a + 2*a*b + b*b;
Read function definition:

define double @foo(double %a, double %b) {
entry:
  %multmp = fmul double %a, %a
  %multmp1 = fmul double 2.000000e+00, %a
  %multmp2 = fmul double %multmp1, %b
  %addtmp = fadd double %multmp, %multmp2
  %multmp3 = fmul double %b, %b
  %addtmp4 = fadd double %addtmp, %multmp3
  ret double %addtmp4
}

ready> def bar(a) foo(a, 4.0) + bar(31337);
Read function definition:

define double @bar(double %a) {
entry:
  %calltmp = call double @foo(double %a, double 4.000000e+00)
  %calltmp1 = call double @bar(double 3.133700e+04)
  %addtmp = fadd double %calltmp, %calltmp1
  ret double %addtmp
}

ready> extern cos(x);
Read extern:

declare double @cos(double %x)

ready> cos(1.234);
Read top-level expression:

define double @__anon_expr() {
entry:
  ret double 9.000000e+00

entry1:                                           ; No predecessors!
  %calltmp = call double @cos(double 1.234000e+00)
  ret double %calltmp
}

ready> ^D
Bye!
; ModuleID = 'my cool jit'
source_filename = "my cool jit"

define double @__anon_expr() {
entry:
  ret double 9.000000e+00

entry1:                                           ; No predecessors!
  %calltmp = call double @cos(double 1.234000e+00)
  ret double %calltmp
}

define double @foo(double %a, double %b) {
entry:
  %multmp = fmul double %a, %a
  %multmp1 = fmul double 2.000000e+00, %a
  %multmp2 = fmul double %multmp1, %b
  %addtmp = fadd double %multmp, %multmp2
  %multmp3 = fmul double %b, %b
  %addtmp4 = fadd double %addtmp, %multmp3
  ret double %addtmp4
}

define double @bar(double %a) {
entry:
  %calltmp = call double @foo(double %a, double 4.000000e+00)
  %calltmp1 = call double @bar(double 3.133700e+04)
  %addtmp = fadd double %calltmp, %calltmp1
  ret double %addtmp
}

declare double @cos(double %x)
```
