struct Arista {
  int origen;
  int destino;
  int peso;
  Arista(int o, int d, int p) {
    origen = o;
    destino = d;
    peso = p;
  }
};

void DFS(Grafo *g, int o, bool *visitados) {
  visitados[o] = true;
  Iterador<Arista> *it = g->getAdyacentes(i);
  while (it->tieneSiguiente()) {
    Arista arista = it->siguiente();
    if (!visitados[arista.destino]) {
      DFS(g, arista.destino, visitados);
    }
  }
}

bool estaConectado(Grafo *g, int o, int d) {
  bool *visitados = new bool[g->getV() + 1];
  DFS(g, o, visitados);
  return visitados[d];
}

int compararArista(Arista a1, Arista a2) { return a1.peso - a2.peso; }

Grafo *kruskal(Grafo *g) {
  Grafo *ACM = new Grafo(g->getV());
  Heap<Arista *> *heap = new Heap<Arista *>(g->getE(), compararArista);
  for (int i = 1; i <= g->getV(); i++) {
    Iterador<Arista> *it = g->getAdyacentes(i);
    while (it->tieneSiguiente()) {
      Arista arista = it->siguiente();
      heap->insertar(arista);
    }
  }
  while (!heap->estaVacio()) {
    Arista arista = heap->tope();
    heap->removerTope();
    if (!estaConectado(g, arista.origen, arista.destino)) {
      ACM->addArista(a.origen, a.destino, a.peso);
    }
  }
  return ACM;
}
