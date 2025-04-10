#include <cassert>
#include <iostream>
#include <limits>
#include <string>
#include "ListAdy.cpp"
using namespace std;

int main() {
  ListAdy *miGrafito = new ListAdy(8, true, true);
  miGrafito->aniadirArista(1, 4, 2);
  miGrafito->aniadirArista(1, 2, 10);
  miGrafito->aniadirArista(1, 3, 20);
  miGrafito->aniadirArista(2, 5, 10);
  miGrafito->aniadirArista(2, 3, 2);
  miGrafito->aniadirArista(3, 5, 1);
  miGrafito->aniadirArista(4, 2, 1);
  miGrafito->aniadirArista(5, 1, 8);
  miGrafito->aniadirArista(1, 8, 100);
  miGrafito->aniadirArista(8, 2, -99);
  miGrafito->aniadirArista(6, 7, 2);
  // miGrafito->aniadirArista(5, 2, -10);


  floyd(miGrafito);

  return 0;
}
