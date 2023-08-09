//
// Created by Hamza Beder on 8/8/2023.
//

#ifndef HEAP_H
#define HEAP_H
#include <iostream>
#include <fstream>
#include <vector>
#include <map>
#include <queue>

class HeapNode {
public:
    char c;
    int freq;
    HeapNode * left;
    HeapNode * right;
    HeapNode();
    HeapNode(char c, int freq);
};

class Heap{
public:
    int length;
    int heap_size;
    HeapNode ** nodes;
    Heap(int length);
    Heap();
    void minHeapify(int idx);
};

#endif