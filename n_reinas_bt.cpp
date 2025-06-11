#include "ListAdy.cpp"
#include <cassert>
#include <iostream>
#include <limits>
#include <string>
using namespace std;

bool esSolucion(int c, int n) { return c == n; }
void imprimirSolucion(int n, bool **reinas) {
  for (int f = 0; f < n; f++) {
    for (int c = 0; c < n; c++) {
      cout << "[";
      if (reinas[f][c]) {
        cout << "R";
      } else {
        cout << " ";
      }
      cout << "] ";
    }
    cout << endl;
  }
  cout << endl << endl;
}
bool esCoordenadaValida(int f, int c, int n) {
  return f >= 0 && c >= 0 && f < n && c < n;
}
bool puedoAplicarMovimiento(int filaCand, int colCand, int n,
                            bool **candidata) {
  // chequeo la horizontal
  int f = filaCand;
  int c = colCand;
  while (esCoordenadaValida(f, c, n)) {
    if (candidata[f][c]) {
      return false;
    }
    c--;
  }
  // chequea arriba - izquierda
  f = filaCand;
  c = colCand;
  while (esCoordenadaValida(f, c, n)) {
    if (candidata[f][c]) {
      return false;
    }
    c--;
    f--;
  }
  // chequea abajo - izquierda
  f = filaCand;
  c = colCand;
  while (esCoordenadaValida(f, c, n)) {
    if (candidata[f][c]) {
      return false;
    }
    c--;
    f++;
  }
  return true;
}
void aplicarMovimiento(int f, int c, bool **candidata) {
  candidata[f][c] = true;
}
void deshacerMovimiento(int f, int c, bool **candidata) {
  candidata[f][c] = false;
}
void n_reinas_bt(int colAc, int n, bool **candidata, int &cantSoluciones) {
  if (esSolucion(colAc, n)) {
    cantSoluciones++;
    // imprimirSolucion(n, candidata);
  } else {
    for (int filaAc = 0; filaAc < n; filaAc++) {
      if (puedoAplicarMovimiento(filaAc, colAc, n, candidata)) {
        aplicarMovimiento(filaAc, colAc, candidata);
        n_reinas_bt(colAc + 1, n, candidata, cantSoluciones);
        deshacerMovimiento(filaAc, colAc, candidata);
      }
    }
  }
}
void n_reinas_una_bt(int colAc, int n, bool **candidata, bool &exito) {
  if (!exito) {
    if (esSolucion(colAc, n)) {
      exito = true;
      imprimirSolucion(n, candidata);
    } else {
      for (int filaAc = 0; filaAc < n; filaAc++) {
        if (puedoAplicarMovimiento(filaAc, colAc, n, candidata)) {
          aplicarMovimiento(filaAc, colAc, candidata);
          n_reinas_una_bt(colAc + 1, n, candidata, exito);
          deshacerMovimiento(filaAc, colAc, candidata);
        }
      }
    }
  }
}
int n_reinas(int n) {
  bool **candidata = new bool *[n]();
  int cantSol = 0;
  for (int i = 0; i < n; i++) {
    candidata[i] = new bool[n]();
  }
  n_reinas_bt(0, n, candidata, cantSol);
  return cantSol;
}
void n_reinas_una(int n) {
  bool **candidata = new bool *[n]();
  for (int i = 0; i < n; i++) {
    candidata[i] = new bool[n]();
  }
  bool exito = false;
  n_reinas_una_bt(0, n, candidata, exito);
}
int main() {
  int n;
  cin >> n;
  n_reinas_una(n);
  return 0;
}
