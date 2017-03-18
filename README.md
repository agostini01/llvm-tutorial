# LLVM Tutorial Notebook

My notebook whilst working through the [LLVM Tutorial](http://llvm.org/docs/tutorial/).

## Progress

 1. [x] Kaleidoscope: Tutorial Introduction and the Lexer
 2. [x] Kaleidoscope: Implementing a Parser and AST
 3. [ ] Kaleidoscope: Code generation to LLVM IR
 4. [ ] Kaleidoscope: Adding JIT and Optimizer Support
 5. [ ] Kaleidoscope: Extending the Language: Control Flow
 6. [ ] Kaleidoscope: Extending the Language: User-defined Operators
 7. [ ] Kaleidoscope: Extending the Language: Mutable Variables
 8. [ ] Kaleidoscope: Compiling to Object Code
 9. [ ] Kaleidoscope: Adding Debug Information
10. [ ] Kaleidoscope: Conclusion and other useful LLVM tidbits

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
