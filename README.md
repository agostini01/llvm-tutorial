# LLVM Tutorial Notebook

My notebook whilst working through the [LLVM Tutorial](http://llvm.org/docs/tutorial/).

## Setup

```sh
$ brew install llvm
```

## Compile

```sh
$ make
```

## Test

```sh
$ make test
```

## Cleanup

```sh
$ make clean
```

## Notes

### 2017-03-18

At this stage, we’re only linking to LLVM for one utlility function:
`llvm::make_unique`.  This seems like an unnecessary complication but I don’t
know enough about unique pointers in C++ to know what the alternative would be.

Open question: *how do unique pointers and std::move relate to Rust’s borrow-checking mechanisms?*
