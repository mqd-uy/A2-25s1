#include <cassert>
#include <iostream>
#include <limits>
#include <string>

using namespace std;
template <typename T> struct BSTNode {
  T data;
  BSTNode *left;
  BSTNode *right;
  BSTNode(T data) {
    this->data = data;
    this->left = nullptr;
    this->right = nullptr;
  }
};

template <typename T> class BST {
private:
  BSTNode<T> *root;

  void insertRec(BSTNode<T> *&node, T data) {
    if (node == nullptr) {
      node = new BSTNode<T>(data);
      return;
    }
    if (data < node->data) {
      this->insertRec(node->left, data);
    } else {
      this->insertRec(node->right, data);
    }
  }
  bool existRec(BSTNode<T> *node, T data) {
    if (node == nullptr) {
      return false;
    }
    if (node->data == data) {
      return true;
    }
    if (data < node->data) {
      return this->existRec(node->left, data);
    } else {
      return this->existRec(node->right, data);
    }
  }

public:
  BST() { this->root = nullptr; }
  void insert(T data) { this->insertRec(this->root, data); }
  bool exist(T data) { return this->existRec(this->root, data); }
};
