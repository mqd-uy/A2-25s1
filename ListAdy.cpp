#include "ColaFifo.cpp"
#include <iostream>

using namespace std;

struct Arista {
    int origen;
    int destino;
    int peso;
    Arista(){}
    Arista(int _origen, int _destino, int _peso = 1) {
        origen = _origen;
        destino = _destino;
        peso = _peso;
    }
};

template <typename T>
struct Nodo {
    T dato;
    Nodo<T> *sig;
    Nodo(T _dato) {
        dato = _dato;
        sig = nullptr;
    }
    Nodo(T _dato, Nodo<T> * _sig) {
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
            grafo = new Nodo<Arista>*[V+1]();
            for(int i = 0; i < V + 1; i++) {
                grafo[i] = nullptr;
            }
        }

        int getV() {
            return V;
        }

        int getA() {
            return A;
        }

        void aniadirArista(int origen, int destino, int peso = 1) {
            assert(peso == 1 || ponderado);
            assert(origen >=1 && origen <= V);
            assert(destino >=1 && destino <= V);
            Arista arista(origen, destino, peso);
            Nodo<Arista> * nuevoNodo = new Nodo<Arista>(arista, grafo[origen]);
            grafo[origen] = nuevoNodo;
            if (!dirigido) {
                Arista arista2(destino, origen, peso);
                grafo[destino] = new Nodo<Arista>(arista2, grafo[destino]);
            }
            A++;
        }

        Nodo<Arista> * adyacentesA(int origen) {
            Nodo<Arista> * aux = grafo[origen];
            Nodo<Arista> * aristasClone = nullptr;
            while(aux != nullptr) {
                aristasClone = new Nodo<Arista>(aux->dato, aristasClone);
                aux = aux->sig;
            }
            return aristasClone;
        }
};


void BFS(int inicio, ListAdy* grafo) {
    QueueImp<int> *cola = new QueueImp<int>();
    bool * encolados = new bool[grafo->getV()+1]();
    cola->enqueue(inicio);
    encolados[inicio] = true;
    while(!cola->isEmpty()) {
        int ver = cola->dequeue();
        cout << ver << endl;
        Nodo<Arista> * ady = grafo->adyacentesA(ver);
        while(ady != nullptr) {
            int destino = ady->dato.destino;
            if(!encolados[destino]) {
                encolados[destino] = true;
                cola->enqueue(destino);
            }
            ady = ady->sig;
        }
    }
}

void ordTop(ListAdy* grafo) {
    int V = grafo->getV();
    int *gradoDeEntrada = new int[V + 1]();

    for(int v = 1 ; v < V + 1; v++) {
        Nodo<Arista> * ady = grafo->adyacentesA(v);
        while(ady != nullptr) {
            int destino = ady->dato.destino;
            gradoDeEntrada[destino]++;
            ady = ady->sig;
        }
    }

    QueueImp<int> *cola = new QueueImp<int>();
    for(int v = 1 ; v < V + 1; v++) {
        if(gradoDeEntrada[v] == 0) {
            cola->enqueue(v);
        }
    }

    while(!cola->isEmpty()) {
        int v = cola->dequeue();
        cout << v << endl;
        Nodo<Arista> * ady = grafo->adyacentesA(v);
        while(ady != nullptr) {
            int destino = ady->dato.destino;
            gradoDeEntrada[destino]--;
            if(gradoDeEntrada[destino] == 0){
                cola->enqueue(destino);
            }
            ady = ady->sig;
        }
    }
}