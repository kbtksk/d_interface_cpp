module cppif;

/*
 * C++ Interface Definition
 */
extern (C++, class)
class BaseClass {
    ~this();
    void test();
}

/*
 * C Linkage functions
 *  for create C++ Class Instance
 *  and release instances
 */
extern (C) {
    BaseClass createInstance();
    void releaseInstance(BaseClass ptr);
}

/*
 * another definition of C++ Class
 *   + be used without interface
 *   + releases myself
 */
extern (C++)
class ClassCpp {
public:
    ~this();
    void func();
    void release();
}

/*
 * Instantiate function for `ClassCpp`
 *   Linked with C++ Linkage
 */
extern (C++)
ClassCpp getClassCpp();

