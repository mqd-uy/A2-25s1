#include <cassert>
#include <iostream>
#include <limits>
#include <string>

class MFSet {

private:
  int *parent;
  int *altura;
  int tam;

public:
  MFSet(int _tam) {
    parent = new int[_tam]();
    altura = new int[_tam]();
    tam = _tam;
    for (int i = 0; i < tam; i++) {
      parent[i] = -1;
      altura[i] = 1;
    }
  }
  int find(int x) {
    if (parent[x] == -1) {
      return x;
    }
    parent[x] = find(parent[x]);
    return parent[x];
  }
  void merge(int x, int y) {
    int parentX = find(x);
    int parentY = find(y);
    if (parentX != parentY) {
      if (altura[parentX] > altura[parentY]) {
        parent[parentY] = parentX;
      } else if (altura[parentX] < altura[parentY]) {
        parent[parentX] = parentY;
      } else {
        parent[parentY] = parentX;
        altura[parentX]++;
      }
    }
  }
};
