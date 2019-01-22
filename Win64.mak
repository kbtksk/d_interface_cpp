DC=dmd

dyn: app.d cppifd.dll
#	$(DC) -m32mscoff -of"dyn.exe" app.d -version=DYNAMIC
	$(DC) -m64 -of"dyn.exe" app.d -version=DYNAMIC

stat: app.d cppifd.obj
#	#$(DC) -m32mscoff -of"stat.exe" app.d cppifd.obj -version=STATIC
	$(DC) -m64 -of"stat.exe" app.d cppifd.obj -version=STATIC

cppifd.obj: cppifd.cpp
	$(CXX) -c cppifd.cpp /nologo /EHsc

cppifd.dll: cppifd.cpp
	$(CXX) cppifd.cpp /link /DLL /out:cppifd.dll /nologo /EHsc

all: dyn stat

.PHONY: clean
clean:
	del *.obj *.exp *.lib *.dll *.exe *.pdb

