#include <cassert>
#include <iostream>
#include <limits>
#include <string>
using namespace std;

int caminos(int filas, int columnas) {
  int **tab = new int *[filas];
  for (int i = 0; i < filas; i++) {
    tab[i] = new int[columnas]();
  }

  // "casos base"
  for (int c = 0; c < columnas; c++) {
    tab[0][c] = 1; // hay una sola forma de ir desde origen a cualquier celda de
                   // la primera fila
  }
  for (int f = 0; f < filas; f++) {
    tab[f][0] = 1; // idem para la primera columna
  }
  // "paso recursivo"
  for (int f = 1; f < filas; f++) {
    for (int c = 1; c < columnas; c++) {
      tab[f][c] = tab[f - 1][c] + tab[f][c - 1]; // suma de caminos desde arriba
                                                 // y desde la izquierda
    }
  }
  return tab[filas - 1][columnas - 1];
}

int main() {
  cout << caminos(3, 6) << endl;
  return 0;
}
