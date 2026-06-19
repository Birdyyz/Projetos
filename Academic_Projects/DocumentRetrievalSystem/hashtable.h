#ifndef HASHTABLE_H
#define HASHTABLE_H

#include "servidor.h" 

#define HASH_SIZE 10007 // tamanho do array que suporta a hash table, independente do tamanho da cache

extern int CACHE_SIZE;

typedef struct DocNode {
    Document doc;
    struct DocNode* prev;
    struct DocNode* next;
} DocNode;

extern DocNode* hash_table[HASH_SIZE];

unsigned int hash(int key);
void inserirNaHash(Document d);
DocNode* procurarNaHash(int key);
int removerDaHash(int key);
void limparHash();
void removerElementoMaisAntigo(void);


#endif

