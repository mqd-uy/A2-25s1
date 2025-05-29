#include <cassert>
#include <iostream>
#include <limits>
#include <string>
using namespace std;
string objetos[6] = {"lingote", "ruby",         "diamanate",
                     "moneda",  "examen de A2", "caravana"};
int pesos[6] = {5, 4, 6, 2, 999, 1};
int valores[6] = {5, 8, 4, 3, 999, 3};

struct Solucion {
  int usado[6];
  int valor;
  Solucion() {
    for (int i = 0; i < 6; i++) {
      usado[i] = 0;
    }
    valor = 0;
  }
};

Solucion mochilaOInf(int capacidadActual, int objetoHasta) {
  if (capacidadActual == 0) { // no tengo mas capacidad
    return Solucion();
  }
  if (objetoHasta < 0) { // no tengo mas objetos
    return Solucion();
  }

  int pesoDelObjeto = pesos[objetoHasta];
  int valorDelObjeto = valores[objetoHasta];

  // si no entra el objeto es como si no lo tuviera en cosideracion
  if (pesoDelObjeto > capacidadActual) {
    return mochilaOInf(capacidadActual, objetoHasta - 1);
  }

  // Dividir y conquistar
  Solucion valorConObjeto =
      mochilaOInf(capacidadActual - pesoDelObjeto, objetoHasta);

  valorConObjeto.usado[objetoHasta]++;
  valorConObjeto.valor += valorDelObjeto;

  Solucion valorSinObjeto = mochilaOInf(capacidadActual, objetoHasta - 1);

  // merge
  return valorConObjeto.valor > valorSinObjeto.valor ? valorConObjeto
                                                     : valorSinObjeto;
}

int main() {

  Solucion mejorSolucion = mochilaOInf(13, 5);
  cout << mejorSolucion.valor << endl;
  for (int i = 0; i < 6; i++) {
    if (mejorSolucion.usado[i] > 0) {
      cout << "use " << mejorSolucion.usado[i] << " veces " << objetos[i]
           << endl;
    }
  }
  cout << endl;
  return 0;
}
