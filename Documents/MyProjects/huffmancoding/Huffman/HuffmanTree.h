//
// Created by Hamza Beder on 8/8/2023.
//

#ifndef HUFFMANCODING_HUFFMANTREE_H
#define HUFFMANCODING_HUFFMANTREE_H

#include <map>
#include <vector>
#include <fstream>
#include "Heap.h"
#include "PriorityQueue.h"


class HuffmanTree{
public:
    HeapNode * root;
    std::map<std::string, char> decompressingMap;
    std::map<char, std::string> HuffmanCodes;
    void countFrequency(std::vector<char> &chars, std::vector<int> &freqs, std::string path);
    void createTree(std::vector <char> chars, std::vector<int> freqs, std:: string path);
    void getCodes(HeapNode * currNode, std::string code);
    void compress(std::string path);
    void decompress();
};


#endif //HUFFMANCODING_HUFFMANTREE_H
