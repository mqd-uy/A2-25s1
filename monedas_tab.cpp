#include <cassert>
#include <climits>
#include <iostream>
#include <limits>
#include <string>
using namespace std;

int cantMonedas = 6;

int monedas[6] = {1, 2, 5, 10, 12, 50};

void cambio_tab2(int cambio) {
  int **tab = new int *[cantMonedas + 1];
  for (int i = 0; i < cantMonedas + 1; i++) {
    tab[i] = new int[cambio + 1]();
  }
  for (int i = 1; i <= cambio; i++) {
    tab[0][i] = INT_MAX; // fila 0 es no tener monedas, por ende no puedo dar
                         // cambio de nada
  }
  for (int monedaIndex = 1; monedaIndex <= cantMonedas; monedaIndex++) {
    int valorMoneda = monedas[monedaIndex - 1];
    for (int cambioIndex = 1; cambioIndex <= cambio; cambioIndex++) {
      if (valorMoneda <= cambioIndex) { // puedo usar la moneda
        int usoMoneda = tab[monedaIndex][cambioIndex - valorMoneda] != INT_MAX
                            ? 1 + tab[monedaIndex][cambioIndex - valorMoneda]
                            : INT_MAX;
        int noUsoMoneda = tab[monedaIndex - 1][cambioIndex];
        tab[monedaIndex][cambioIndex] =
            usoMoneda < noUsoMoneda ? usoMoneda : noUsoMoneda;
      } else {
        // no puedo usar la moenda porque es mas grande que el cambio que tengo
        // que dar
        tab[monedaIndex][cambioIndex] = tab[monedaIndex - 1][cambioIndex];
      }
    }
  }
  int monedasUsadas = tab[cantMonedas][cambio];
  if (monedasUsadas == INT_MAX) {
    cout << "no se puede dar cambio" << endl;
  } else {
    cout << "necesitamos " << monedasUsadas << " monedas" << endl;
  }
}
void cambio_tab1(int cambio) {
  int *tab = new int[cambio + 1]();
  // caso base, para cambio 0 no tengo que dar cambio
  tab[0] = 0;
  // paso recursivo
  for (int i = 1; i <= cambio; i++) {
    int min = INT_MAX;
    for (int monedaIndex = 0; monedaIndex < cantMonedas; monedaIndex++) {
      int valorMoneda = monedas[monedaIndex];
      if (valorMoneda <= i) {
        // puedo usar la moneda
        if (tab[i - valorMoneda] < min) {
          min = tab[i - valorMoneda];
        }
      }
    }
    if (min == INT_MAX) {
      tab[i] = INT_MAX; // si no puedo dar cambio no quiero pasarme a INT_MIN
                        // (con +1)
    } else {
      tab[i] = min + 1;
    }
  }

  if (tab[cambio] == INT_MAX) {
    cout << "no se puede dar cambio" << endl;
  } else {
    cout << "necesitamos " << tab[cambio] << " monedas" << endl;
  }
  // que monedas use??
  // TODO
}

int main() {
  cambio_tab1(15);
  cambio_tab2(15);
  return 0;
}
