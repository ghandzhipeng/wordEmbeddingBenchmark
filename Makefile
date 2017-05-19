CXXFLAGS=-lm -pthread -Ofast -march=native -Wall -funroll-loops -ffast-math -Wno-unused-result -lgsl -lgslcblas

CXX=g++

all:
	$(CXX) -o line line.cpp $(CXXFLAGS)
	
clean:
	rm -f line 
