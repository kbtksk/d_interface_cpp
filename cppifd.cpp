#include <iostream>


#if defined(_WIN32) || defined(_WIN64)
/// Define DllMain for Windows Environment
#include <windows.h>
BOOL WINAPI DllMain(HINSTANCE hInstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
    switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
        break;
    case DLL_PROCESS_DETACH:
        break;
    case DLL_THREAD_ATTACH:
        break;
    case DLL_THREAD_DETACH:
        break;
    default:
        break;
    }
    return TRUE;
}
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

//=============================================================================
// Definitions
//=============================================================================

/*+
 * Class Interface Definition
 * +*/
class BaseClass {
public:
    /// virtual destructor
    virtual ~BaseClass() { }

    /// function for test call
    virtual void test() = 0;
};

/*+
 * Class Interface Implementation
 * +*/
class BaseClassImpl : public BaseClass {
public:
    /// Destructor (nothing to do)
    virtual ~BaseClassImpl() { }

    /// function for test call
    virtual void test() {
        std::printf("C++ Method Call! <BasicClassImpl>\n");
    }
};


/*+
 * Class Instance Factory Method for BaseClass
 *  + this method create instance of BaseClassImpl
 * +*/
extern "C"
EXPORT BaseClass *createInstance() {
    auto ptr = new BaseClassImpl();
    std::printf("> BaseClass(%p) allocated.\n", ptr);
    return ptr;
}

/*+
 * Class Interface Releaser Method
 * +*/
extern "C"
EXPORT void releaseInstance(BaseClass *ptr) {
    delete ptr;
    std::printf("> BaseClass`(%p) released.\n", ptr);
}

//----------------------------------
/*+
 * Class Definition without Interfaces
 * +*/
class ClassCpp {
public:
    /// Destructor (nothing to do)
    virtual ~ClassCpp() { }

    /// test call
    virtual void func() {
        std::printf("C++ Method Call <ClassCpp>\n");
    }
    /// release instance
    virtual void release() {
        std::printf("> ClassCpp(%p) released.\n", this);
        delete this;
    }
};

/*+
 * Class Instance Factory Method for ClassCpp
 * +*/
EXPORT ClassCpp* getClassCpp() {
    auto ptr = new ClassCpp();
    std::printf("> ClassCpp(%p) allocated.\n", ptr);
    return ptr;
}




