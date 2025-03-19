#include "AVL.cpp"
#include <cassert>
#include <iostream>
#include <limits>
#include <string>
using namespace std;
int main() {
  AVL<int> *miArbolito = new AVL<int>();
  int a;
  int b;
  cin >> a;
  for (int i = 0; i < a; i++) {
    cin >> b;
    if (miArbolito->exist(b))
      continue;
    miArbolito->insert(b);
  }
  miArbolito->inOrder();

  return 0;
}
