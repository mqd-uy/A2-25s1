void DFS(Grafo *g, int actual, bool* visitados){
  visitados[actual] = true;
  NodoArista * ady = g->getAdyacentes(actual);
  while(ady!=NULL){
    if(!visitados[ady->dato.destino]){
      DFS(g, ady->datos.destino, visitados);
    }
    ady = ady->sig;
  }
}

int contarComponentesConexas(Grafo * g, int ignorar) {
  int V = g->getV();
  bool * visitados = new bool[V + 1]();
  int compConexas = 0;
  visitados[ignorar] = true;
  for(int v = 1; v <= V; v++) {
    if(!visitados[v]) {
      compConexas++;
      DFS(g, v, visitados);
    }
  }
  return compConexas;
}

List<int> puntosDeArticulacion(Grafo *g) {
  int cantComponConexasOriginal = contarComponentesConexas(g, 0);
  List<int> * puntosDeArticulacion = new List<Int>();
  int V = g->getV();
  for(int v = 1; v <= V; v++) {
      int cantComponConexasIgnorando = contarComponentesConexas(g, v);
      if(cantComponConexasOriginal < cantComponConexasIgnorando) {
          puntosDeArticulacion->add(v);
      }
  }
  return puntosDeArticulacion;
}  
