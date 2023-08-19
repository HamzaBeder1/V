//
// Created by Hamza Beder on 8/8/2023.
//

#include "HuffmanTree.h"
#include <fstream>
using namespace std;

void HuffmanTree:: countFrequency(vector<char> &chars, vector<int> &freqs, string path){
    vector <vector<int>> result;
    vector <int> freqTemp(256,0);
    vector <int> charTemp(256,0);
    ifstream fin;
    fin.open(path);
    char c;
    while(fin.get(c))
    {
        charTemp[c] = 1;
        freqTemp[c]++;
    }

    for(int i = 0; i<256; i++){
        if(charTemp[i] == 1){
            chars.push_back(i);
            freqs.push_back(freqTemp[i]);
        }
    }
}

void HuffmanTree:: createTree(vector<char> chars, vector<int> freqs, string path){
    countFrequency(chars, freqs, path);
    PriorityQueue *pq = new PriorityQueue(chars.size());
    pq->createQueue(chars,freqs);
    while(pq->pq->heap_size > 1){
        HeapNode * node1 = pq->extractMin();
        HeapNode* node2 = pq->extractMin();
        HeapNode * newNode = new HeapNode(0, node1->freq+node2->freq);
        newNode->left = node1;
        newNode->right = node2;
        pq->insert(newNode);
    }
    this->root = pq->extractMin();
}

void HuffmanTree::getCodes(HeapNode * currNode, string code) {
    if(currNode->left == nullptr && currNode->right == nullptr)
    {
        this->HuffmanCodes[currNode->c] = code;
        this->decompressingMap[code] = currNode->c;
    }
    else{
        if(currNode->left)
                getCodes(currNode->left, code+"0");
            if(currNode->right)
                getCodes(currNode->right, code+"1");
        }
}

void HuffmanTree::compress(string path){
    vector<char> chars;
    vector <int> freqs;
    createTree(chars, freqs, path);
    this->getCodes(root, "");
    ifstream fin;
    ofstream fout;
    fout.open("compressed.txt");
    fin.open(path);
    char c;
    while(fin.get(c)){
        fout << this->HuffmanCodes[c];
    }
}

void HuffmanTree::decompress(){
    ifstream fin;
    ofstream fout;
    fin.open("C:\\Users\\Hamza Beder\\Documents\\MyProjects\\huffmanCoding\\compressed.txt");
    fout.open("decompressed.txt");
    char c;
    string code = "";
    HeapNode * temp = this->root;
    while(fin.get(c)){

            if(c == '0'){
                code+="0";
                temp = temp->left;
            }
            else if(c == '1'){
                code+="1";
                temp = temp->right;
            }
        if(temp->left == nullptr && temp->right == nullptr){
            fout << decompressingMap[code];
            temp = this->root;
            code = "";
        }
        }
    }
