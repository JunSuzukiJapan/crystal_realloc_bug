# realloc_bug

# Bug Reproduction

1. Clone or download zip.

2. Change dir to project root.

3. Run ```crystal run src/realloc_bug.cr```.

Then, the error occurs, like below.

```
Negative size (ArgumentError)
  from /usr/local/Cellar/crystal-lang/0.24.1_2/src/pointer.cr:0:7 in 'realloc'
  from /usr/local/Cellar/crystal-lang/0.24.1_2/src/array.cr:1778:7 in 'resize_to_capacity'
  from /usr/local/Cellar/crystal-lang/0.24.1_2/src/array.cr:1772:5 in 'double_capacity'
  from /usr/local/Cellar/crystal-lang/0.24.1_2/src/array.cr:1768:5 in 'check_needs_resize'
  from /usr/local/Cellar/crystal-lang/0.24.1_2/src/array.cr:1344:5 in 'push'
  from src/observable.cr:18:11 in 'to_ary'
  from src/realloc_bug.cr:7:5 in '__crystal_main'
  from /usr/local/Cellar/crystal-lang/0.24.1_2/src/crystal/main.cr:11:3 in '_crystal_main'
  from /usr/local/Cellar/crystal-lang/0.24.1_2/src/crystal/main.cr:112:5 in 'main_user_code'
  from /usr/local/Cellar/crystal-lang/0.24.1_2/src/crystal/main.cr:101:7 in 'main'
  from /usr/local/Cellar/crystal-lang/0.24.1_2/src/crystal/main.cr:135:3 in 'main'
```

# crystal version

```
Crystal 0.24.1 (2018-01-27)

LLVM: 5.0.1
Default target: x86_64-apple-macosx
```

# os

macOS 10.13.3
