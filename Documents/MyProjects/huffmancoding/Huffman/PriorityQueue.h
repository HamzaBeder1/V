//
// Created by Hamza Beder on 8/8/2023.
//

#ifndef PRIORITYQUEUE_H
#define PRIORITYQUEUE_H
#include <vector>
#include "Heap.h"

class PriorityQueue {
public:
    Heap * pq;
    PriorityQueue(int size);
    void insert(HeapNode * newNode);
    void createQueue(std::vector <char> chars, std::vector<int> freqs);
    HeapNode * extractMin();
    HeapNode * heapMin();

    //Builing the queue:
    //Step 1: use a create heap method to create one of size = 0
    //Step 2: initialize the heap nodes to their frequencies and characters. Create the same number as the number of characters and store them in an array
    //Step 3: add the nodes to this created heap using the insert method: increase the size of the heap by 1, set nodes[i] = current node, compare the current node with its parent (at (i-1)/2). If it has a smaller frequency, swap them. Keep swapping until in correct position
    //Step 4: once the queue is created, call extractmin. This will extract the root, set the new root to the last element, and call heapify on this root. This will ensure the smallest frequency element is always at the root.

    //Building the Huffman tree:
    //Step 1: call extractmin twice, create a new node with the frequency = sum of the two, the use the insert method to put it in the hea
    //Step 2: repeat until thre is a single heap node in the tree, meaning root->left=root->right = null. Then return this node

    //Compressing:
    //Search the tree until a leaf node is obtained, add this leaf node's char attribute to a dictionary. The dictionary's values will be the corresponding code
    //Then, loop through the file again. Replace each character with their code, and write back to the file this code

    //Decompressing:
    //Search a tree using the code inside the compressed file. Keep searching either left or right until a leaf is found. Then write this character to a new file.
    //Then, start from the root again and repeat
};


#endif //HUFFMANCODING_PRIORITYQUEUE_H
