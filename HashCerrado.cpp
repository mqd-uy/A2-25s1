#include <iostream>
using namespace std;


template <typename K, typename V>
struct KeyValue {
    K key;
    V value;
    KeyValue(K unaKey, V unValue) {
        key = unaKey;
        value = unValue;
    }
};

template <typename K, typename V>
class HashCerrado {
    private:
        KeyValue<K,V> **arr;
        int N;
        int B;
        int (*hash)(K);

        void insertar(KeyValue<K,V> ** _arr, K key, V value, int _B, bool crecerN) {
            int pos = abs(this->hash(key)) % _B;
            bool inserte = false;
            int intentos = 0;
            while(!inserte){
                assert(intentos < _B);
                if(_arr[pos] == nullptr) {
                    _arr[pos] = new KeyValue<K,V>(key, value);
                    inserte = true;
                    if(crecerN) {
                        N++;
                    }
                } else {
                    if(_arr[pos]->key == key) {
                        _arr[pos]->value = value;
                        inserte = true;
                    }
                }
                intentos++;
                pos = (pos + intentos) % _B;
            }
        }

        void rehash() {
            KeyValue<K,V> ** newArr = new KeyValue<K,V>*[B * 2](); // nuevo array
            for(int i=0; i < B; i++) {
                if(arr[i] != nullptr) {
                    insertar(newArr, arr[i]->key, arr[i]->value, B * 2, false);
                }
            }
            KeyValue<K,V> ** toDelete =  arr;
            arr = newArr;
            B = B*2;
            delete[] toDelete;
        }

    public:
        HashCerrado(int unB, int (*unHash)(K)){
            arr = new KeyValue<K,V>*[unB]();
            for(int i=0; i < unB; i++) {
                arr[i] = nullptr;
            }
            B = unB;
            N = 0;
            hash = unHash;
        }

        void insertar(K key, V value) {
            if(this->factorDeCarga() > 0.7) {
                cout << "Hago rehash!" << endl;
                this->rehash();
            }
            insertar(this->arr, key, value, this->B, true);
        }

        bool existe(K key) {
            int pos = abs(this->hash(key)) % this->B;
            int intentos = 0;
            while(intentos < this->B) { // ponemos un limite a la busqueda
                if(arr[pos] == nullptr) {
                    return false;
                } else {
                    if(arr[pos]->key == key) {
                        return true;
                    }
                }
                intentos++;
                pos = (pos + intentos) % this->B;
            }
            return false;
        }

        V buscar(K key) {
            assert(existe(key));
            int pos = abs(this->hash(key)) % this->B;
            int intentos = 0;
            while(intentos < this->B) { // ponemos un limite a la busqueda
                assert(arr[pos] != nullptr);
                if(arr[pos]->key == key) {
                    return arr[pos]->value;
                }
                intentos++;
                pos = (pos + intentos) % this->B;
            }
            return V();
        }

        float factorDeCarga() {
            return (float)this->N/this->B;
        }

};