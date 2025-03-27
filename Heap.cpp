#include <cassert>

template <typename T>
class MinHeap {
    private:
        T* arr;
        int sig;
        int cap;
        int (*comparacion)(T,T);

        int padre(int pos) {
            return pos / 2;
        }

        int hIzq(int pos) {
            return pos * 2;
        }

        int hDer(int pos) {
            return (pos * 2) + 1;
        }

        void swap(int pos1, int pos2) {
            T aux =  arr[pos1];
            arr[pos1] = arr[pos2];
            arr[pos2] = aux;
        }

        void flotar(int pos) {
            if(pos > 1) {// no estamos en la raiz
                int posPadre =  padre(pos);
                T padreEl = arr[posPadre];
                T el = arr[pos];
                if (comparacion(padreEl, el) > 0) {
                    swap(pos, posPadre);
                    flotar(posPadre);
                }
            }
        }

        void hundir(int pos) {
            int posHIzq = hIzq(pos);
            int posHDer = hDer(pos);
            if(posHIzq < sig) { // al menos tengo un hijo
                int posMenorHijo = posHIzq;
                // si tengo hijo derecho y el hijo derecho es menor que mi hijo izquierdo
                if(posHDer < sig && comparacion(arr[posHIzq], arr[posHDer]) > 0) { 
                    posMenorHijo = posHDer;
                }

                if (comparacion(arr[pos], arr[posMenorHijo]) > 0) {
                    swap(pos, posMenorHijo);
                    hundir(posMenorHijo);
                }
            }
        }

    public:
        MinHeap(int _cap, int (*_comparacion)(T,T)) {
            arr = new T[_cap+1]();
            sig = 1; // team rojo!
            cap = _cap;
            comparacion = _comparacion;
        }

        void insertar(T el) {
            assert(!estaLleno());
            arr[sig] = el;
            sig++;
            flotar(sig - 1);
        }

        T tope() {
            assert(!estaVacio());
            return arr[1];
        }

        void removerTope(){
            assert(!estaVacio());
            arr[1] = arr[sig - 1]; // swap(1, sig - 1)
            sig--;
            hundir(1);
        }

        bool estaLleno() {
            return this->sig > this->cap;
        }

        bool estaVacio() {
            return this->sig == 1;
        }
};