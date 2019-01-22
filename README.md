Dlang: using C++ class from DLL example
===============

This repository aim to know how to handling C++ Classses by D language.


Test Environment
---------------

### Windows

- Windows 10 64bit
- VisualStudio Community 2017 (x64)
- dmd v2.083.0
    + Appended to PATH variable

### Linux

- Archlinux
- GCC 8.2.1 20181127
- dmd v2.083.1

Build
---------------

Binaries and libraries are build with `make` command.
`make` command generates executable files `dyn` and `stat`.

`dyn` uses dynamic link library (DLL on Windows, .so on Linux.)

`stat` uses static link with c++ compiled object.

### Windows

Use `nmake` with `Developer Command Prompt for VisualStudio 2017 (Native Tools x64)`.

```shell
cd `<path_to_repo>`
nmake -f Win64.mak all
```

### Linux

Use `make`.

```shell
cd `<path_to_repo>
make all
```


Note
---------------

C++ interface on D is introduced on [dlang.org](dlang.org)

### .di files

Definitions about Interfaces, Class, and Functions should be written in `.di` files.
Because class method implementation needed when classes are defined on `.d`files.

So many C++ class has virtual destructor.
If they defined on `.d` files, implementation are required on there.
`.di` file avoid these problem.

```d
// on '.d'
class Foo {
    void bar(); // Link error (undefined reference)
}

// on '.di'
class Foo {
    void bar(); // Implemention is not needed
}
```

(*If definitions are on `.d` separated by compiling source code, the implementations are not required?*)

### Differences on object instance type

On C++, class instance type is `type*` (then allocated with `new`, not on stack).
Class instances defined with `type` are not able to have `interface`.
So they are actually struct.

On D, class instance type is `type`, not `type*` (D's class allocated in heap).

For example, function `foo` returns instance of class `Bar`,
then definitions are;


```c++
// C++
Bar* foo() { return new Bar(); }
```

```d
// D
Bar foo() { return new Bar(); }
```

### Reference Type of object
```d
void test(ref Type);
```

```c++
void test(Type *&val);
```

--------------

### Problems

- VisualStudio `cl.exe` build for x86 cannot work with dmd `-m32mscoff` build.


### TODO

- Interface behaviour
- COM library behaviour
- COM like design
- POD
- Struct passing
- Check align of member variables (with vtables)
- Check `.di` detailed work

Reference
---------------
- [dlang.org](https://dlang.org/)
    + [Interfacing to C++](https://dlang.org/spec/cpp_interface.html) page
    + [Application Binary Interface](https://dlang.org/spec/abi.html) page

