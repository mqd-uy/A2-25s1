#include "ListAdy.cpp"
#include <cassert>
#include <iostream>
#include <limits>
#include <string>
using namespace std;

int main() {
  ListAdy *miGrafito = new ListAdy(6, false, true);
  miGrafito->aniadirArista(1, 2, 5);
  miGrafito->aniadirArista(1, 4, 3);
  miGrafito->aniadirArista(1, 5, 1);
  miGrafito->aniadirArista(1, 6, 2);
  miGrafito->aniadirArista(2, 3, 5);
  miGrafito->aniadirArista(2, 4, 5);
  miGrafito->aniadirArista(2, 5, 10);
  miGrafito->aniadirArista(3, 4, 3);
  miGrafito->aniadirArista(3, 5, 2);
  miGrafito->aniadirArista(4, 5, 1);
  miGrafito->aniadirArista(4, 6, 1);
  miGrafito->aniadirArista(5, 6, 8);

  // prim(miGrafito);
  kruskal(miGrafito);
  return 0;
}
