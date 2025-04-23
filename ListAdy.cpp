#include "ColaFifo.cpp"
#include "Heap.cpp"
#include "MFSet.cpp"
#include <climits>
#include <iostream>

using namespace std;

struct Arista {
  int origen;
  int destino;
  int peso;
  Arista() {}
  Arista(int _origen, int _destino, int _peso = 1) {
    origen = _origen;
    destino = _destino;
    peso = _peso;
  }
};

template <typename T> struct Nodo {
  T dato;
  Nodo<T> *sig;
  Nodo(T _dato) {
    dato = _dato;
    sig = nullptr;
  }
  Nodo(T _dato, Nodo<T> *_sig) {
    dato = _dato;
    sig = _sig;
  }
};

class ListAdy {
private:
  int V;
  int A;
  Nodo<Arista> **grafo;
  bool dirigido;
  bool ponderado;

public:
  ListAdy(int _V, bool _dirigido, bool _ponderado) {
    V = _V;
    A = 0;
    dirigido = _dirigido;
    ponderado = _ponderado;
    grafo = new Nodo<Arista> *[V + 1]();
    for (int i = 0; i < V + 1; i++) {
      grafo[i] = nullptr;
    }
  }

  int getV() { return V; }

  int getA() { return A; }

  void aniadirArista(int origen, int destino, int peso = 1) {
    assert(peso == 1 || ponderado);
    assert(origen >= 1 && origen <= V);
    assert(destino >= 1 && destino <= V);
    Arista arista(origen, destino, peso);
    Nodo<Arista> *nuevoNodo = new Nodo<Arista>(arista, grafo[origen]);
    grafo[origen] = nuevoNodo;
    if (!dirigido) {
      Arista arista2(destino, origen, peso);
      grafo[destino] = new Nodo<Arista>(arista2, grafo[destino]);
    }
    A++;
  }

  Nodo<Arista> *adyacentesA(int origen) {
    Nodo<Arista> *aux = grafo[origen];
    Nodo<Arista> *aristasClone = nullptr;
    while (aux != nullptr) {
      aristasClone = new Nodo<Arista>(aux->dato, aristasClone);
      aux = aux->sig;
    }
    return aristasClone;
  }
};

void BFS(int inicio, ListAdy *grafo) {
  QueueImp<int> *cola = new QueueImp<int>();
  bool *encolados = new bool[grafo->getV() + 1]();
  cola->enqueue(inicio);
  encolados[inicio] = true;
  while (!cola->isEmpty()) {
    int ver = cola->dequeue();
    cout << ver << endl;
    Nodo<Arista> *ady = grafo->adyacentesA(ver);
    while (ady != nullptr) {
      int destino = ady->dato.destino;
      if (!encolados[destino]) {
        encolados[destino] = true;
        cola->enqueue(destino);
      }
      ady = ady->sig;
    }
  }
}

void ordTop(ListAdy *grafo) {
  int V = grafo->getV();
  int *gradoDeEntrada = new int[V + 1]();

  for (int v = 1; v < V + 1; v++) {
    Nodo<Arista> *ady = grafo->adyacentesA(v);
    while (ady != nullptr) {
      int destino = ady->dato.destino;
      gradoDeEntrada[destino]++;
      ady = ady->sig;
    }
  }

  QueueImp<int> *cola = new QueueImp<int>();
  for (int v = 1; v < V + 1; v++) {
    if (gradoDeEntrada[v] == 0) {
      cola->enqueue(v);
    }
  }

  while (!cola->isEmpty()) {
    int v = cola->dequeue();
    cout << v << endl;
    Nodo<Arista> *ady = grafo->adyacentesA(v);
    while (ady != nullptr) {
      int destino = ady->dato.destino;
      gradoDeEntrada[destino]--;
      if (gradoDeEntrada[destino] == 0) {
        cola->enqueue(destino);
      }
      ady = ady->sig;
    }
  }
}

struct VerticeCosto {
  int ver;
  int cos;
  VerticeCosto() {}
  VerticeCosto(int _ver, int _cos) {
    ver = _ver;
    cos = _cos;
  }
};

int comparacionVC(VerticeCosto vc1, VerticeCosto vc2) {
  return vc1.cos - vc2.cos;
}

void imprimirCamino(int *vengo, int estoy) {
  if (vengo[estoy] != -1 && vengo[estoy] != estoy) {
    imprimirCamino(vengo, vengo[estoy]);
  }
  cout << "->" << estoy;
}

void dijkstra(int origen, ListAdy *grafo) {
  int V = grafo->getV();
  bool *visitado = new bool[V + 1]();
  int *vengo = new int[V + 1]();
  int *costo = new int[V + 1]();

  for (int i = 1; i < V + 1; i++) {
    visitado[i] = false;
    vengo[i] = -1;
    costo[i] = INT_MAX;
  }

  MinHeap<VerticeCosto> *heap = new MinHeap<VerticeCosto>(V * V, comparacionVC);
  VerticeCosto inicial(origen, 0);
  costo[origen] = 0;
  heap->insertar(inicial);

  while (!heap->estaVacio()) {
    VerticeCosto aProcesar = heap->tope();
    int o = aProcesar.ver;
    heap->removerTope();

    if (visitado[o]) {
      continue;
    }
    visitado[o] = true;

    Nodo<Arista> *ady = grafo->adyacentesA(o);
    while (ady != nullptr) {
      int d = ady->dato.destino;
      int costoArista = ady->dato.peso;
      if (!visitado[d] && costo[d] > costoArista + costo[o]) {
        costo[d] = costoArista + costo[o];
        vengo[d] = o;
        VerticeCosto aux(d, costo[d]);
        heap->insertar(aux);
      }
      ady = ady->sig;
    }
  }

  for (int i = 1; i < V + 1; i++) {
    if (i == origen) {
      continue;
    }
    if (visitado[i]) {
      cout << "el costo de ir desde " << origen << " hasta " << i
           << " es de: " << costo[i] << endl;
      cout << "el camino es: ";
      imprimirCamino(vengo, i);
      cout << endl;
    } else {
      cout << "no se puede ir desde " << origen << " hasta " << i << endl;
    }
  }
}

void bellmanford(int origen, ListAdy *grafo) {
  int V = grafo->getV();
  bool *encolado = new bool[V + 1]();
  int *vengo = new int[V + 1]();
  int *costo = new int[V + 1]();
  int *vecesEncolado = new int[V + 1]();

  for (int i = 1; i < V + 1; i++) {
    encolado[i] = false;
    vengo[i] = -1;
    costo[i] = INT_MAX;
    vecesEncolado[i] = 0;
  }

  QueueImp<int> *aProcesar = new QueueImp<int>();
  aProcesar->enqueue(origen);
  encolado[origen] = true;
  costo[origen] = 0;
  vecesEncolado[origen]++;

  while (!aProcesar->isEmpty()) {
    int verActual = aProcesar->dequeue();
    assert(vecesEncolado[verActual] <= V); // hay ciclo negativo!
    encolado[verActual] = false;
    Nodo<Arista> *ady = grafo->adyacentesA(verActual);
    while (ady != nullptr) {
      int destino = ady->dato.destino;
      int costoArista = ady->dato.peso;
      if (costo[destino] > costoArista + costo[verActual]) {
        costo[destino] = costoArista + costo[verActual];
        vengo[destino] = verActual;
        if (!encolado[destino]) {
          aProcesar->enqueue(destino);
          encolado[destino] = true;
          vecesEncolado[destino]++;
        }
      }
      ady = ady->sig;
    }
  }

  for (int i = 1; i < V + 1; i++) {
    if (i == origen) {
      continue;
    }
    if (vengo[i] != -1) {
      cout << "el costo de ir desde " << origen << " hasta " << i
           << " es de: " << costo[i] << endl;
      cout << "el camino es: ";
      imprimirCamino(vengo, i);
      cout << endl;
    } else {
      cout << "no se puede ir desde " << origen << " hasta " << i << endl;
    }
  }
}

int **initMatrizCosto(ListAdy *grafo) {
  int V = grafo->getV();
  int **matrizCosto = new int *[V + 1]();
  for (int i = 1; i <= V; i++) {
    matrizCosto[i] = new int[V + 1]();
    for (int j = 1; j <= V; j++) {
      matrizCosto[i][j] = INT_MAX;
    }
  }

  for (int origen = 1; origen <= V; origen++) {
    Nodo<Arista> *ady = grafo->adyacentesA(origen);
    while (ady != nullptr) {
      int destino = ady->dato.destino;
      int costoArista = ady->dato.peso;
      matrizCosto[origen][destino] = costoArista;
      ady = ady->sig;
    }
  }

  for (int origen = 1; origen <= V; origen++) {
    matrizCosto[origen][origen] = 0;
  }

  return matrizCosto;
}

int **initMatrizVengo(ListAdy *grafo) {
  int V = grafo->getV();
  int **matrizVengo = new int *[V + 1]();
  for (int i = 0; i <= V; i++) {
    matrizVengo[i] = new int[V + 1]();
    for (int j = 0; j <= V; j++) {
      matrizVengo[i][j] = -1;
    }
  }

  for (int origen = 1; origen <= V; origen++) {
    Nodo<Arista> *ady = grafo->adyacentesA(origen);
    while (ady != nullptr) {
      int destino = ady->dato.destino;
      int costoArista = ady->dato.peso;
      matrizVengo[origen][destino] = origen;
      ady = ady->sig;
    }
  }

  return matrizVengo;
}

void floyd(ListAdy *grafo) {
  int V = grafo->getV();
  int **matrizCosto = initMatrizCosto(grafo);
  int **matrizVengo = initMatrizVengo(grafo);

  for (int i = 1; i <= V; i++) {
    for (int o = 1; o <= V; o++) {
      for (int d = 1; d <= V; d++) {
        if (matrizCosto[o][i] == INT_MAX || matrizCosto[i][d] == INT_MAX) {
          continue;
        }
        if (matrizCosto[o][i] + matrizCosto[i][d] < matrizCosto[o][d]) {
          matrizCosto[o][d] = matrizCosto[o][i] + matrizCosto[i][d];
          matrizVengo[o][d] = i;
        }
      }
    }
  }

  // Imprimir los caminos mas cortos entre todo par de vertices.
  for (int origen = 1; origen <= V; origen++) {
    cout << endl << "Desde origen " << origen << ":" << endl;
    for (int destino = 1; destino < V + 1; destino++) {
      if (destino == origen) {
        continue;
      }
      if (matrizVengo[origen][destino] != -1) {
        cout << "el costo de ir desde " << origen << " hasta " << destino
             << " es de: " << matrizCosto[origen][destino] << endl;

        cout << "el camino es: ";
        imprimirCamino(matrizVengo[origen], destino);
        cout << endl;
      } else {
        cout << "no se puede ir desde " << origen << " hasta " << destino
             << endl;
      }
    }
  }
}

void prim(ListAdy *grafo) {
  int origen = 1;
  int V = grafo->getV();
  bool *visitado = new bool[V + 1]();
  int *vengo = new int[V + 1]();
  int *costo = new int[V + 1]();

  for (int i = 1; i < V + 1; i++) {
    visitado[i] = false;
    vengo[i] = -1;
    costo[i] = INT_MAX;
  }

  MinHeap<VerticeCosto> *heap = new MinHeap<VerticeCosto>(V * V, comparacionVC);
  VerticeCosto inicial(origen, 0);
  costo[origen] = 0;
  heap->insertar(inicial);

  while (!heap->estaVacio()) {
    VerticeCosto aProcesar = heap->tope();
    int o = aProcesar.ver;
    heap->removerTope();

    if (visitado[o]) {
      continue;
    }
    visitado[o] = true;

    Nodo<Arista> *ady = grafo->adyacentesA(o);
    while (ady != nullptr) {
      int d = ady->dato.destino;
      int costoArista = ady->dato.peso;
      if (!visitado[d] && costo[d] > costoArista) {
        costo[d] = costoArista;
        vengo[d] = o;
        VerticeCosto aux(d, costo[d]);
        heap->insertar(aux);
      }
      ady = ady->sig;
    }
  }
  int costoTotal = 0;
  for (int i = 1; i < V + 1; i++) {
    if (visitado[i] && vengo[i] != -1) {
      cout << i << "<--" << costo[i] << "-->" << vengo[i] << endl;
      costoTotal += costo[i];
    }
  }
  cout << "costo total es de " << costoTotal << endl;
}

int comparacionArista(Arista a1, Arista a2) { return a1.peso - a2.peso; }

void kruskal(ListAdy *grafo) {
  int V = grafo->getV();
  MinHeap<Arista> *heap = new MinHeap<Arista>(grafo->getA(), comparacionArista);
  // metmos todas la Aristas del grafo en el heap
  for (int i = 1; i <= grafo->getV(); i++) {
    Nodo<Arista> *ady = grafo->adyacentesA(i);
    while (ady != nullptr) {
      if (ady->dato.origen < ady->dato.destino) {
        heap->insertar(ady->dato);
      }
      ady = ady->sig;
    }
  }
  MFSet *conjuntos = new MFSet(V + 1);
  int aristasAceptadas = 0;
  int costoArbol = 0;
  while (!heap->estaVacio() && aristasAceptadas < V - 1) {
    Arista a = heap->tope();
    heap->removerTope();
    if (conjuntos->find(a.origen) != conjuntos->find(a.destino)) {
      cout << a.origen << "<--" << a.peso << "-->" << a.destino << endl;
      costoArbol += a.peso;
      aristasAceptadas++;
      conjuntos->merge(a.origen, a.destino);
    }
  }
  cout << "costo total es de " << costoArbol << endl;
}
