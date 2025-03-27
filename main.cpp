#include <cassert>
#include <iostream>
#include <limits>
#include <string>
#include "Heap.cpp"
using namespace std;

class Persona {
  public:
    int edad;
    string nombre;
    int llegada;
    Persona(int _edad, string _nombre, int _llegada) {
      edad = _edad;
      nombre = _nombre;
      llegada = _llegada;
    }
    Persona(){}
};

int compararPersonas(Persona p, Persona p2) {
  if(p.edad != p2.edad) {
    return p.edad - p2.edad;
  }else {
    return p.llegada - p2.llegada; 
  }
}

int main() {
  
  MinHeap<Persona> *miHeap = new MinHeap<Persona>(10, compararPersonas);
  Persona p1(40, "A", 1);
  miHeap->insertar(p1);
  Persona p2(30, "B", 2);
  miHeap->insertar(p2);
  Persona p3(30, "C", 3);
  miHeap->insertar(p3);
  Persona p4(40, "D", 4);
  miHeap->insertar(p4);
  Persona p5(30, "E", 5);
  miHeap->insertar(p5);


  while(!miHeap->estaVacio()) {
    Persona p = miHeap->tope();
    miHeap->removerTope();
    cout << p.nombre << " " << p.edad << endl;
  }
  return 0;
}
