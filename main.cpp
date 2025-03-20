#include <cassert>
#include <iostream>
#include <limits>
#include <string>
#include "HashCerrado.cpp"
using namespace std;


// Ref: https://cseweb.ucsd.edu/~kube/cls/100/Lectures/lec16/lec16-15.html
int hash3(string key) {
  int h = 0;
  for (int i = 0; i < key.length(); i++)
    h = 31 * h + int(key[i]);
  return h;
}


int main() {
  HashCerrado<string, int> *miTabla = new HashCerrado<string, int>(10, hash3);
  miTabla->insertar("pepe", 12);
  miTabla->insertar("pepe2", 14);
  miTabla->insertar("pepe3", 15);
  miTabla->insertar("pepe4", 22);
  miTabla->insertar("pepe5", 12);
  miTabla->insertar("pepe6", 12);
  miTabla->insertar("pepe7", 66);
  miTabla->insertar("pepe8", 90);
  miTabla->insertar("pepe9", 90);
  miTabla->insertar("pepe10", 90);
  miTabla->insertar("pepe11", 90);

  cout <<  miTabla->factorDeCarga() << endl;

  cout << miTabla->buscar("pepe11") << endl;

  return 0;
}
