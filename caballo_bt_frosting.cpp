#include "ListAdy.cpp"
#include <cassert>
#include <iostream>
#include <limits>
#include <string>
using namespace std;

#define N 6

bool pasoPorDondeTegoQuePasar(int **camino, bool **tiene) {
  for (int f = 0; f < N; f++) {
    for (int c = 0; c < N; c++) {
      if (tiene[f][c] && camino[f][c] == -1) {
        return false;
      }
    }
  }
  return true;
}

bool esSolucion(int fAc, int cAc, int fDe, int cDes, int **camino,
                bool **tieneQuePasar) {
  return fAc == fDe && cAc == cDes &&
         pasoPorDondeTegoQuePasar(camino, tieneQuePasar);
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

bool puedoAplicarMovimiento(int f, int c, int **candidata, bool **prohibidos) {
  return esCoordenadaValida(f, c) && candidata[f][c] == -1 &&
         !prohibidos[f][c]; // si es una cordenada valida y no pase
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

int **clonarSolucion(int **origen) {
  int **duplicado = new int *[N]();
  for (int f = 0; f < N; f++) {
    duplicado[f] = new int[N]();
    for (int c = 0; c < N; c++) {
      duplicado[f][c] = origen[f][c];
    }
  }
  return duplicado;
}

void caballo_bt(int fAc, int cAc, int fDe, int cDe, bool **tieneQuePasar,
                bool **prohibidos, int **caminoCandidato, int &mejorPasos,
                int **&mejorCamino) {
  if (!puedoPodar(caminoCandidato[fAc][cAc], mejorPasos)) {
    if (esSolucion(fAc, cAc, fDe, cDe, caminoCandidato, tieneQuePasar) &&
        esMejorSolucion(caminoCandidato[fAc][cAc], mejorPasos)) {
      mejorPasos = caminoCandidato[fAc][cAc];
      mejorCamino = clonarSolucion(caminoCandidato);
    } else {
      int dFila[8] = {2, 1, -1, -2, -2, -1, 2, 1};
      int dCol[8] = {1, 2, -2, -1, 1, 2, -1, -2};
      int pasoActual = caminoCandidato[fAc][cAc];
      for (int mov = 0; mov < 8; mov++) {
        int fCand = fAc + dFila[mov];
        int cCand = cAc + dCol[mov];

        if (puedoAplicarMovimiento(fCand, cCand, caminoCandidato, prohibidos)) {
          aplicarMovimiento(fCand, cCand, pasoActual + 1, caminoCandidato);
          caballo_bt(fCand, cCand, fDe, cDe, tieneQuePasar, prohibidos,
                     caminoCandidato, mejorPasos, mejorCamino);
          deshacerMovimiento(fCand, cCand, caminoCandidato);
        }
      }
    }
  }
}

void caballo(int fAc, int cAc, int fDe, int cDe, bool **tieneQuePasar,
             bool **prohibidos) {
  int **candidata = new int *[N]();
  int **mejorSolucion = NULL;
  for (int f = 0; f < N; f++) {
    candidata[f] = new int[N]();
    for (int c = 0; c < N; c++) {
      candidata[f][c] = -1;
    }
  }
  candidata[fAc][cAc] = 1;
  int mejoresPasos = INT_MAX;
  caballo_bt(fAc, cAc, fDe, cDe, tieneQuePasar, prohibidos, candidata,
             mejoresPasos, mejorSolucion);
  if (mejorSolucion != NULL) {
    imprimirSolucion(mejorSolucion);
  } else {
    cout << "no existe ninguna solucion" << endl;
  }
}

bool **crearMatriz() {
  bool **matriz = new bool *[N]();
  for (int f = 0; f < N; f++) {
    matriz[f] = new bool[N]();
  }
  return matriz;
}

int main() {
  int filaOrigen = 0;
  int colOrigen = 0;
  int filaDestino = N - 1;
  int colDestino = N - 1;
  bool **tieneQuePasar = crearMatriz();
  bool **prohibidos = crearMatriz();
  tieneQuePasar[2][2] = true;
  tieneQuePasar[0][4] = true;
  prohibidos[2][3] = true;
  caballo(filaOrigen, colOrigen, filaDestino, colDestino, tieneQuePasar,
          prohibidos);
  return 0;
}
