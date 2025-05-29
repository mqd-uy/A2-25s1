#include "../ColaFifo.cpp"
#include <cassert>
#include <iostream>
#include <limits>
#include <string>
using namespace std;

int contarAtentendidos(QueueImp<int> *operariosIndex,
                       QueueImp<int> *cuadtrillaIndex, int K) {
  int cantidadAtentidos = 0;

  while (!operariosIndex->isEmpty() && !cuadtrillaIndex->isEmpty()) {
    int operario = operariosIndex->next();
    int cuadrilla = cuadtrillaIndex->next();

    if (abs(operario - cuadrilla) <= K) {
      cantidadAtentidos++;
      operariosIndex->dequeue();
      cuadtrillaIndex->dequeue();
    } else if (operario < cuadrilla) {
      operariosIndex->dequeue();
    } else {
      cuadtrillaIndex->dequeue();
    }
  }

  return cantidadAtentidos;
}

int main() {
  int casos;
  int K;
  int largoCaso;
  string nivel;
  cin >> casos;

  for (int i = 0; i < casos; i++) {
    cin >> K >> largoCaso;
    QueueImp<int> *operariosIndex = new QueueImp<int>();
    QueueImp<int> *cuadtrillaIndex = new QueueImp<int>();
    for (int j = 0; j < largoCaso; j++) {
      cin >> nivel;
      if (nivel == "O") {
        operariosIndex->enqueue(j);
      } else if (nivel == "C") {
        cuadtrillaIndex->enqueue(j);
      }
    }
    if (operariosIndex->isEmpty() || cuadtrillaIndex->isEmpty()) {
      cout << "0" << endl;
      continue;
    }

    int cantidadAtentidos =
        contarAtentendidos(operariosIndex, cuadtrillaIndex, K);
    cout << cantidadAtentidos << endl;
  }

  return 0;
}
