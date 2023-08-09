//
// Created by Hamza Beder on 8/8/2023.
//

#include "PriorityQueue.h"
using namespace std;
PriorityQueue ::PriorityQueue(int size) {
    pq = new Heap(size);
}

void PriorityQueue:: insert(HeapNode * newNode){
    pq->heap_size++;
    int i = pq->heap_size-1;
    pq->nodes[i] = newNode;
    while(i >= 0 && pq->nodes[i]->freq < pq->nodes[(i-1)/2]->freq){
        HeapNode * temp = pq->nodes[i];
        pq->nodes[i] = pq->nodes[(i-1)/2];
        pq->nodes[(i-1)/2] = temp;
        i = (i-1)/2;
    }
}

void PriorityQueue::createQueue(vector<char> chars, vector<int> freqs) {
    for(int i = 0; i < this->pq->length; i++){
        HeapNode * newNode = new HeapNode(chars[i], freqs[i]);
        this->insert(newNode);
    }
}

HeapNode * PriorityQueue:: extractMin(){
    HeapNode* head = this->heapMin();
    this->pq->nodes[0] = this->pq->nodes[this->pq->heap_size-1];
    this->pq->heap_size--;
    this->pq->minHeapify(0);
    return head;
}

HeapNode * PriorityQueue:: heapMin(){
    return this->pq->nodes[0];
}


