#include "ListAdy.cpp"
#include <cassert>
#include <iostream>
#include <limits>
#include <string>
using namespace std;

#define N 8

bool esSolucion(int fAc, int cAc, int fDe, int cDes) {
  return fAc == fDe && cAc == cDes;
}

void imprimirSolucion(int **camino) {
  for (int f = 0; f < N; f++) {
    for (int c = 0; c < N; c++) {
      cout << "[";
      if (camino[f][c] == -1) {
        cout << "  ";
      } else if (camino[f][c] < 10) {
        cout << " " << camino[f][c];
      } else {
        cout << camino[f][c];
      }
      cout << "] ";
    }
    cout << endl;
  }
}

bool esCoordenadaValida(int f, int c) {
  return f < N && c < N && f >= 0 && c >= 0;
}

bool puedoAplicarMovimiento(int f, int c, int **candidata) {
  return esCoordenadaValida(f, c) &&
         candidata[f][c] == -1; // si es una cordenada valida y no pase
}
void aplicarMovimiento(int fCand, int cCand, int pasoActual,
                       int **caminoCandidato) {
  caminoCandidato[fCand][cCand] = pasoActual;
}

void deshacerMovimiento(int fCand, int cCand, int **caminoCandidato) {
  caminoCandidato[fCand][cCand] = -1;
}
bool esMejorSolucion(int pasosActual, int mejoresPasos) {
  return pasosActual < mejoresPasos;
}
bool puedoPodar(int actual, int mejor) { return actual > mejor; }
void caballo_bt(int fAc, int cAc, int fDe, int cDe, int **caminoCandidato,
                int &mejorPasos) {
  if (!puedoPodar(caminoCandidato[fAc][cAc], mejorPasos)) {
    if (esSolucion(fAc, cAc, fDe, cDe) &&
        esMejorSolucion(caminoCandidato[fAc][cAc], mejorPasos)) {
      mejorPasos = caminoCandidato[fAc][cAc];
      cout << "encontro solucion" << endl;
      imprimirSolucion(caminoCandidato);
      cout << endl;
    } else {
      int dFila[8] = {-1, -2, -2, -1, 1, 2, 2, 1};
      int dCol[8] = {-2, -1, 1, 2, 2, 1, -2, -2};
      int pasoActual = caminoCandidato[fAc][cAc];
      for (int mov = 0; mov < 8; mov++) {
        int fCand = fAc + dFila[mov];
        int cCand = cAc + dCol[mov];

        if (puedoAplicarMovimiento(fCand, cCand, caminoCandidato)) {
          aplicarMovimiento(fCand, cCand, pasoActual + 1, caminoCandidato);
          caballo_bt(fCand, cCand, fDe, cDe, caminoCandidato, mejorPasos);
          deshacerMovimiento(fCand, cCand, caminoCandidato);
        }
      }
    }
  }
}

void caballo(int fAc, int cAc, int fDe, int cDe) {
  int **candidata = new int *[N]();
  for (int f = 0; f < N; f++) {
    candidata[f] = new int[N]();
    for (int c = 0; c < N; c++) {
      candidata[f][c] = -1;
    }
  }
  candidata[fAc][cAc] = 1;
  int mejoresPasos = INT_MAX;
  caballo_bt(fAc, cAc, fDe, cDe, candidata, mejoresPasos);
}

int main() {
  int filaOrigen = 0;
  int colOrigen = 0;
  int filaDestino = N - 1;
  int colDestino = N - 1;
  caballo(filaOrigen, colOrigen, filaDestino, colDestino);
  return 0;
}
