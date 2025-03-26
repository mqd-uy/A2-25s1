#include <cassert>
#include <iostream>
#include <limits>
#include <string>
#include "Heap.cpp"
using namespace std;

class Persona {
  public:
    int edad;
    Persona(int _edad) {
      edad = _edad;
    }
    Persona(){}
};

int compararPersonas(Persona p, Persona p2) {
  return p2.edad - p.edad;
}

int main() {
  
  MinHeap<Persona> *miHeap = new MinHeap<Persona>(4, compararPersonas);
  miHeap->tope();
  Persona p1(50);
  Persona p2(20);
  Persona p3(30);
  Persona p4(40);
  miHeap->insertar(p1);
  miHeap->insertar(p2);
  miHeap->insertar(p3);
  miHeap->insertar(p4);

  Persona p = miHeap->tope();
  cout << p.edad << endl;
  return 0;
}
