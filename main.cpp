#include "AVL.cpp"
#include <cassert>
#include <iostream>
#include <limits>
#include <string>
using namespace std;
int main() {
  AVL<int> *miArbolito = new AVL<int>();
  miArbolito->insert(2);
  miArbolito->insert(3);
  miArbolito->insert(4);
  miArbolito->insert(1);
  miArbolito->insert(-3);
  miArbolito->printInOrder();
  return 0;
}
