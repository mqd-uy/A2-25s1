#ifndef QUEUE_IMP
#define QUEUE_IMP

#include <cassert>

template <class T> class QueueImp {
private:
  class Node {
  public:
    T element;
    Node *next;
    Node *previous;
    Node(T element, Node *previous, Node *next)
        : element(element), previous(previous), next(next) {}
  };
  Node *front, *back;
  int size;

public:
  // front(older) <-> ... <-> back (newer)
  QueueImp() : front(nullptr), back(nullptr), size(0) {}

  void enqueue(T element) {
    Node *newNode = new Node(element, nullptr, back);
    if (isEmpty()) {
      front = newNode;
      back = newNode;
    } else {
      back->previous = newNode;
      back = newNode;
    }
    size++;
  }

  T next() {
    assert(!this->isEmpty());
    return front->element;
  }

  T dequeue() {
    assert(!this->isEmpty());
    T element = front->element;
    Node *toDelete = front;
    front = front->previous;
    if (front == nullptr) {
      back = nullptr;
    }
    delete toDelete;
    size--;
    return element;
  }

  bool isEmpty() { return front == nullptr; }
};

#endif
