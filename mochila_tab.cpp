#include <cassert>
#include <climits>
#include <iostream>
#include <limits>
#include <string>
using namespace std;

int cantObjetos = 4;
string nombres[4] = {"ruby", "lingote", "moneda", "diamante"};
int valores[4] = {10, 7, 5, 20};
int pesos[4] = {5, 6, 2, 3};

void mochila_01(int capacidad) {
  int **tab = new int *[cantObjetos + 1];
  for (int i = 0; i < cantObjetos + 1; i++) {
    tab[i] = new int[capacidad + 1]();
  }
  for (int objetoIndex = 1; objetoIndex <= cantObjetos; objetoIndex++) {
    int valorObjeto = valores[objetoIndex - 1];
    int pesoObjeto = pesos[objetoIndex - 1];
    for (int capacidadIndex = 1; capacidadIndex <= capacidad;
         capacidadIndex++) {
      if (pesoObjeto <= capacidadIndex) { // puedo usar el objeto
        int valorDeLaMochilaUsandoElObjeto =
            valorObjeto + tab[objetoIndex - 1][capacidadIndex - pesoObjeto];
        int valorDeLaMochilaNOusandoElObjeto =
            tab[objetoIndex - 1][capacidadIndex];
        tab[objetoIndex][capacidadIndex] =
            valorDeLaMochilaUsandoElObjeto > valorDeLaMochilaNOusandoElObjeto
                ? valorDeLaMochilaUsandoElObjeto
                : valorDeLaMochilaNOusandoElObjeto;
      } else {
        // no puedo usar el objeto por ende lo ignoro
        tab[objetoIndex][capacidadIndex] = tab[objetoIndex - 1][capacidadIndex];
      }
    }
  }
  int valorRecolectado = tab[cantObjetos][capacidad];
  cout << "pudimos tomar " << valorRecolectado << endl;
  int objetoIndex = cantObjetos;
  int capacidadIndex = capacidad;
  while (objetoIndex > 0 && capacidad > 0) {
    int pesoObjeto = pesos[objetoIndex - 1];
    string nombreObjeto = nombres[objetoIndex - 1];
    bool useObejto = tab[objetoIndex - 1][capacidadIndex] !=
                     tab[objetoIndex][capacidadIndex];
    if (useObejto) {
      cout << "Use el objeto " << nombreObjeto << endl;
      capacidadIndex -= pesoObjeto;
    }
    objetoIndex--;
  }
}

int main() {
  mochila_01(13);
  return 0;
}
