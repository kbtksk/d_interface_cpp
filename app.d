import cppif;

version(Posix) {
    pragma(lib, "dl");
    pragma(lib, "phobos2");
    pragma(lib, "stdc++");
}

template LoadFunction (Func) {
    import core.runtime;
    import std.conv : to;
    import std.exception : enforce;

    auto LoadFunction(void* dylib, immutable(char*) name) {
        version(Windows) {
            import core.sys.windows.windows;
            import std.windows.syserror;

            FARPROC fp = GetProcAddress(cast(HANDLE)dylib, name);
            enforce(fp !is null, sysErrorString(GetLastError()) ~ " - " ~ name.to!string);
            return cast(Func)fp;
        }
        else {
            import core.sys.posix.dlfcn;

            Func fp = cast(Func)dlsym(dylib, name);
            enforce(fp, dlerror().to!string);
            return fp;
        }
    }
}

template LoadFunction (alias Func) {
    import std.traits : ReturnType, Parameters;
    import std.string : toStringz;

    alias Type = ReturnType!Func function(Parameters!Func);
    auto LoadFunction(void *dylib) {
        return LoadFunction!Type(dylib, toStringz(Func.mangleof));
    }
}

void test(int, int, int){}
int main() {
    version (DYNAMIC) {
        import core.runtime;

        version (Windows) {
            const libDynamic = "./cppifd.dll";
        }
        else {
            const libDynamic = "./libcppifd.so";
        }

        // Import Dynamic Library
        auto dylib = Runtime.loadLibrary(libDynamic);
        scope (exit) Runtime.unloadLibrary(dylib);

        import std.string;
        // Get Function Pointer on dylib
        alias InstanceFunc = BaseClass function(); // for Instantiate
        alias ReleaseFunc = void function(BaseClass); // for Release
        InstanceFunc func = dylib.LoadFunction!(InstanceFunc)(createInstance.mangleof);
        ReleaseFunc releaser = dylib.LoadFunction!(releaseInstance)();

        // call C++ Functions
        auto instance = func();
        instance.test(); // Call C++ class method
        releaser(instance); // release instance

        // C++ Linkage Functions
        //   function type loaded from definition on "lib.di"
        auto funcClassCpp = dylib.LoadFunction!(ClassCpp function())(getClassCpp.mangleof);
//         auto funcClassCpp = dylib.LoadFunction!(getClassCpp); // for short expression
        ClassCpp cpp = funcClassCpp();
        cpp.func(); // Call C++ class method
        cpp.release(); // release myself
    }
    else {
        // Functions are linked static

        // Make instance by C-Linkage Function
        auto instance = createInstance();
        instance.test(); // Call C++ class method

        // C++ Linkage Functions
        ClassCpp cpp =  getClassCpp();
        cpp.func(); // Call C++ class method

        // Release Instances
        releaseInstance(instance);
        cpp.release();
    }

    return 0;
}

