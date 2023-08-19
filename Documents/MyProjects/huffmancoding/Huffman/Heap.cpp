//
// Created by Hamza Beder on 8/8/2023.
//

#include "Heap.h"
#include <vector>
using namespace std;
HeapNode:: HeapNode(){
        this->c = 0;
        this->freq = 0;
        this->left = this->right = nullptr;
}

HeapNode:: HeapNode(char c, int freq){
        this->c = c;
        this->freq = freq;
        this->left = this->right = nullptr;
}

Heap:: Heap(){

}
Heap:: Heap(int length){
    this->length = length;
    this->heap_size = 0;
    this->nodes = new HeapNode*[length];
}

void Heap:: minHeapify(int idx){
    int smallest = idx;
    if(2*idx+1 < this->heap_size && this->nodes[2*idx+1]->freq < this->nodes[smallest]->freq)
        smallest = 2*idx+1;
    if(2*idx+2 < this->heap_size && this->nodes[2*idx+2]->freq < this->nodes[smallest]->freq)
        smallest = 2*idx+2;
    if(smallest != idx){
        HeapNode * temp = this->nodes[smallest];
        this->nodes[smallest] = this->nodes[idx];
        this->nodes[idx] = temp;
        minHeapify(smallest);
    }
}
