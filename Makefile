DC=dmd
OBJS="build"


dyn: app.d libcppifd.so
	$(DC) -of"dyn" app.d -version=DYNAMIC

stat: app.d cppifd.o
	$(DC) -of"stat" app.d cppifd.o -version=STATIC

cppifd.o: cppifd.cpp
	$(CXX) -c cppifd.cpp

libcppifd.so: cppifd.o
	$(CXX) -shared -fPIC cppifd.cpp -o libcppifd.so

all: dyn stat

.PHONY: clean
clean:
	rm -f dyn stat *.so *.o

