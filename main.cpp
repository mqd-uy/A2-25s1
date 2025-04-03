#include <cassert>
#include <iostream>
#include <limits>
#include <string>
#include "ListAdy.cpp"
#include "ColaFifo.cpp"
using namespace std;

int main() {
  ListAdy *miGrafito = new ListAdy(5, true, true);
  miGrafito->aniadirArista(1, 3, 2);
  miGrafito->aniadirArista(1, 2, 3);
  miGrafito->aniadirArista(3, 4, 8);
  miGrafito->aniadirArista(2, 3, 1);

  // BFS(1, miGrafito);
  ordTop(miGrafito);

  // QueueImp<int> *cola = new QueueImp<int>();
  // cola->enqueue(1);
  // cola->enqueue(2);
  // cola->enqueue(3);
  // cola->enqueue(4);
  // cola->enqueue(5);
  // cola->enqueue(6);
  // while(!cola->isEmpty()) {
  //   cout << cola->dequeue() << endl;
  // }

  return 0;
}
