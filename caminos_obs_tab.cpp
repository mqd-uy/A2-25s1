#include <cassert>
#include <iostream>
#include <limits>
#include <string>
using namespace std;

int filas = 3;
int columnas = 6;

bool **esPared;

int caminos(int filas, int columnas) {
  int **tab = new int *[filas];
  for (int i = 0; i < filas; i++) {
    tab[i] = new int[columnas]();
  }

  // "casos base"
  tab[0][0] = 1; // hay un camino desde el origen
                 // "paso recursivo"
  for (int f = 0; f < filas; f++) {
    for (int c = 0; c < columnas; c++) {
      if (f == 0 && c == 0) {
        continue; // caso base
      } else if (esPared[f][c]) {
        tab[f][c] = 0; // si es pared no hay forma de ir
      } else if (f == 0) {
        tab[f][c] = tab[f][c - 1]; // si estamos en la primera fila
      } else if (c == 0) {
        tab[f][c] = tab[f - 1][c]; // si estamos en la primera columna
      } else {
        tab[f][c] =
            tab[f - 1][c] +
            tab[f][c - 1]; // suma de caminos desde arriba y desde la izquierda
      }
    }
  }
  return tab[filas - 1][columnas - 1];
}

int main() {
  esPared = new bool *[filas];
  for (int i = 0; i < filas; i++) {
    esPared[i] = new bool[columnas]();
  }
  esPared[0][2] = true;

  esPared[1][3] = true;
  esPared[1][5] = true;

  cout << caminos(filas, columnas) << endl;
  return 0;
}
